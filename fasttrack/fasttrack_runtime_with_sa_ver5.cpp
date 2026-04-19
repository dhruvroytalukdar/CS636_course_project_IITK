// fasttrack_runtime_with_sa_efficient.cpp
//
// Performance-first SA + FastTrack.
//
// THE CORE PERFORMANCE CONTRACT
// ══════════════════════════════
// For a privately-accessed variable (OWNED by the current thread), the
// entire __ft_read / __ft_write call must:
//   • touch exactly ONE cache line  (the ShadowEntry in the flat table)
//   • execute exactly ZERO atomic RMW operations  (only atomic loads)
//   • acquire ZERO mutexes
//   • branch-predict perfectly  (the fast-path branch is almost always taken)
//
// This is achieved by storing share_state + owner_tid as a single 64-bit
// atomic word packed into the ShadowEntry itself, alongside the VarState*.
// A private access only reads that one word, compares, and returns.
// The heap-allocated VarState (with its mutex, W, R, Rvc) is touched only
// on the slow path, i.e. when a variable is SHARED or transitions to SHARED.
//
// SA STATE MACHINE
// ════════════════
//  UNACCESSED  → first access sets owner, goes to OWNED_READ or OWNED_WRITE.
//                No FT call. (No prior access ⟹ no race possible.)
//
//  OWNED_*  (owner == current thread)
//               → Update FT's W/R to stay accurate for future SHARED seeding.
//                 No FT call. No mutex. Just atomic loads + a store.
//
//  OWNED_*  (owner != current thread)
//               → Transition to SHARED. Seed FT from stored owner epoch.
//                 Always call FT.
//
//  SHARED       → Always call FT. Attempt reclaim after every non-racing call.
//
// OWNERSHIP RECLAIM
// ═════════════════
//  Thread T can reclaim ownership iff T's VC dominates FT's W/R/Rvc.
//  No separate access_vc — FT's own state is the reclaim predicate.
//  Reclaim fires automatically on the next SHARED access after any
//  HB-establishing event (pthread_join, mutex acquire, cond_wait).

#include <bits/stdc++.h>
#include <pthread.h>
#include <mutex>
#include <atomic>
#include <time.h>

// ──────────────────────────────────────────────────────────────────
// 1. CONSTANTS AND EPOCH HELPERS
// ──────────────────────────────────────────────────────────────────

#define SHADOW_SIZE  (1 << 20)
#define SHADOW_MASK  (SHADOW_SIZE - 1)

typedef unsigned long long Epoch;

const Epoch READ_SHARED = (Epoch)-1;
const int   CLOCK_BITS  = 32;
const Epoch CLOCK_MASK  = 0xFFFFFFFF;

static inline Epoch make_epoch(int tid, int clock) {
    return ((Epoch)tid << CLOCK_BITS) | (Epoch)(clock & (int)CLOCK_MASK);
}
static inline int get_tid  (Epoch e) { return (int)(e >> CLOCK_BITS); }
static inline int get_clock(Epoch e) { return (int)(e & CLOCK_MASK); }

// ──────────────────────────────────────────────────────────────────
// 2. SA STATE ENUM
// ──────────────────────────────────────────────────────────────────

enum class ShareState : uint32_t {
    UNACCESSED  = 0,
    OWNED_READ  = 1,
    OWNED_WRITE = 2,
    SHARED      = 3
};

// ──────────────────────────────────────────────────────────────────
// 3. THE HOT WORD — packed into ShadowEntry alongside the VarState*
//
// Layout of the 64-bit hot_word:
//   bits [63:32] = owner_tid  (int32, -1 means no owner)
//   bits [31: 0] = ShareState (uint32)
//
// Both fields are read/written as a single 64-bit atomic, so the
// fast-path check is a single load + compare — one instruction.
// ──────────────────────────────────────────────────────────────────

static inline uint64_t pack_hot(int owner_tid, ShareState ss) {
    return ((uint64_t)(uint32_t)owner_tid << 32) | (uint32_t)ss;
}
static inline ShareState hot_state(uint64_t w) {
    return (ShareState)(uint32_t)(w & 0xFFFFFFFFULL);
}
static inline int hot_owner(uint64_t w) {
    return (int)(uint32_t)(w >> 32);
}

// ──────────────────────────────────────────────────────────────────
// 4. SHADOW TABLE ENTRY  (exactly one cache line)
//
//  hot_word  : SA fast-path state (share_state + owner_tid), atomic
//  state     : pointer to VarState (heap), atomic; null until allocated
//  key       : address key for open-addressing hash table
//
// The fast path only reads hot_word and never touches *state.
//
// Forward-declare VarState so it can be used as a pointer type here.
// VarState is defined fully after ShadowEntry.
// ──────────────────────────────────────────────────────────────────

struct VarState;   // forward declaration

// No false sharing
struct alignas(64) ShadowEntry {
    std::atomic<uint64_t>  hot_word { pack_hot(-1, ShareState::UNACCESSED) };
    std::atomic<VarState*> state    { nullptr };
    std::atomic<uintptr_t> key      { 0 };
};
static_assert(sizeof(ShadowEntry) == 64, "ShadowEntry must be exactly one cache line");

// ──────────────────────────────────────────────────────────────────
// 5. VarState  — only touched on slow path
//
// Does NOT contain share_state or owner_tid (those live in ShadowEntry).
// Contains only FT-layer state and the slow-path mutex.
// Also stores owner_clock so OWNED→SHARED seeding is accurate.
// ──────────────────────────────────────────────────────────────────

struct VarState {
    // FT layer
    Epoch W { 0 };
    Epoch R { 0 };
    std::vector<Epoch> Rvc;

    // Owner's clock at last ownership update, used to seed FT on SHARED transition.
    // Only meaningful while state is OWNED_*.
    int owner_clock { 0 };

    std::recursive_mutex mtx;
};

// ──────────────────────────────────────────────────────────────────
// 6. ThreadState and LockState
// ──────────────────────────────────────────────────────────────────

struct ThreadState {
    int tid;
    std::vector<int> C;
    Epoch epoch;
    std::recursive_mutex mtx;

    ThreadState(int id) : tid(id) {
        if (tid >= (int)C.size()) C.resize(tid + 1, 0);
        C[tid] = 1;
        epoch  = make_epoch(tid, 1);
    }

    int get_clock_of(int u) const {
        if (u < 0 || u >= (int)C.size()) return 0;
        return C[u];
    }
};

struct LockState {
    std::vector<int> L;
    std::recursive_mutex mtx;
};

// ──────────────────────────────────────────────────────────────────
// 7. GLOBAL STATE
// ──────────────────────────────────────────────────────────────────

static std::atomic<int> next_tid   {1};
static std::atomic<int> race_count {0};
static ShadowEntry      shadow_table[SHADOW_SIZE];
static thread_local ThreadState* tl_thread_state = nullptr;

static std::recursive_mutex& get_thread_map_lock() {
    static std::recursive_mutex m; return m;
}
static std::map<pthread_t, ThreadState*>& get_threads_map() {
    static auto* m = new std::map<pthread_t, ThreadState*>(); return *m;
}
static std::recursive_mutex& get_lock_registry_lock() {
    static std::recursive_mutex m; return m;
}
static std::unordered_map<void*, LockState*>& get_shadow_locks() {
    static auto* m = new std::unordered_map<void*, LockState*>(); return *m;
}

// ──────────────────────────────────────────────────────────────────
// 8. INFRASTRUCTURE HELPERS
// ──────────────────────────────────────────────────────────────────

static void vec_set_epoch(std::vector<Epoch>& v, int idx, Epoch val) {
    if (idx >= (int)v.size()) v.resize(idx + 1, 0);
    v[idx] = val;
}

static ThreadState* get_current_thread() {
    if (tl_thread_state) return tl_thread_state;
    pthread_t self = pthread_self();
    std::lock_guard<std::recursive_mutex> lk(get_thread_map_lock());
    auto& threads = get_threads_map();
    if (!threads.count(self))
        threads[self] = new ThreadState(next_tid++);
    tl_thread_state = threads[self];
    return tl_thread_state;
}

// Returns the ShadowEntry for addr.
// The entry's hot_word and state pointer are managed separately:
// hot_word is set atomically; state is lazily allocated on first slow-path access.
static ShadowEntry* get_shadow_entry(void* addr) {
    uintptr_t key  = ((uintptr_t)addr >> 2) + 1;   // +1 ensures key != 0
    size_t    slot = (key * 2654435761ULL) & SHADOW_MASK;

    for (;;) {
        uintptr_t cur = shadow_table[slot].key.load(std::memory_order_acquire);
        if (cur == key) return &shadow_table[slot];
        if (cur == 0) {
            uintptr_t expected = 0;
            if (shadow_table[slot].key.compare_exchange_strong(
                    expected, key, std::memory_order_acq_rel))
                return &shadow_table[slot];
            continue;
        }
        slot = (slot + 1) & SHADOW_MASK;
    }
}

// Returns the VarState for a shadow entry, allocating it if necessary.
// Only called on slow path.
static VarState* get_or_alloc_var_state(ShadowEntry* e) {
    VarState* s = e->state.load(std::memory_order_acquire);
    if (s) return s;
    // Allocate. Use CAS
    VarState* ns = new VarState();
    VarState* expected = nullptr;
    if (!e->state.compare_exchange_strong(expected, ns,
            std::memory_order_acq_rel, std::memory_order_acquire)) {
        delete ns;       
        return expected;
    }
    return ns;
}

static LockState* get_lock_state(void* addr) {
    std::lock_guard<std::recursive_mutex> lk(get_lock_registry_lock());
    auto& sl = get_shadow_locks();
    if (!sl.count(addr)) sl[addr] = new LockState();
    return sl[addr];
}

static void report_race(const char* type, void* addr, int tid1, int tid2, int line_no) {
    race_count.fetch_add(1, std::memory_order_relaxed);
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    uint64_t ns = (uint64_t)ts.tv_sec * 1000000000ULL + (uint64_t)ts.tv_nsec;
    printf("[FASTTRACK LOG] | TYPE: %s | ADDR: %p | THREADS: %d-%d | LINE: %d | TS_NS: %llu\n",
           type, addr, tid1, tid2, line_no, (unsigned long long)ns);
}

// ──────────────────────────────────────────────────────────────────
// 9. RECLAIM CHECK
//
// Returns true iff t's VC dominates every epoch in FT's W/R/Rvc,
// meaning t has happened-after all prior accesses and can safely
// take sole ownership.
// ──────────────────────────────────────────────────────────────────

static bool can_reclaim(ThreadState* t, VarState* x) {
    if (x->W != 0) {
        int w_tid   = get_tid(x->W);
        int w_clock = get_clock(x->W);
        if (w_tid != t->tid && t->get_clock_of(w_tid) < w_clock)
            return false;
    }
    if (x->R == READ_SHARED) {
        for (int i = 0; i < (int)x->Rvc.size(); ++i) {
            if (x->Rvc[i] == 0) continue;
            int r_clock = get_clock(x->Rvc[i]);
            if (i != t->tid && t->get_clock_of(i) < r_clock)
                return false;
        }
    } else if (x->R != 0) {
        int r_tid   = get_tid(x->R);
        int r_clock = get_clock(x->R);
        if (r_tid != t->tid && t->get_clock_of(r_tid) < r_clock)
            return false;
    }
    return true;
}

// ──────────────────────────────────────────────────────────────────
// 10. FT CORE  (var mutex + thread mutex must be held by caller)
//
// Returns true  → race reported  → caller must NOT reclaim ownership
// Returns false → no race        → caller may attempt reclaim
// ──────────────────────────────────────────────────────────────────

static bool ft_read_core(void* addr, int line_no, VarState* x, ThreadState* t) {
    if (x->R == t->epoch) return false;   // fast path: same epoch

    int w_tid   = get_tid(x->W);
    int w_clock = get_clock(x->W);
    if (w_clock > t->get_clock_of(w_tid)) {
        report_race("W-R", addr, w_tid, t->tid, line_no);
        x->W = 0;
        x->R = t->epoch;
        return true;
    }

    if (x->R == READ_SHARED) {
        vec_set_epoch(x->Rvc, t->tid, t->epoch);
    } else {
        int r_tid   = get_tid(x->R);
        int r_clock = get_clock(x->R);
        if (r_clock <= t->get_clock_of(r_tid)) {
            x->R = t->epoch;
        } else {
            Epoch old_R = x->R;
            x->Rvc.clear();
            vec_set_epoch(x->Rvc, r_tid,  old_R);
            vec_set_epoch(x->Rvc, t->tid, t->epoch);
            x->R = READ_SHARED;
        }
    }
    return false;
}

static bool ft_write_core(void* addr, int line_no, VarState* x, ThreadState* t) {
    if (x->W == t->epoch) return false;

    bool raced = false;

    int w_tid   = get_tid(x->W);
    int w_clock = get_clock(x->W);
    if (w_clock > t->get_clock_of(w_tid)) {
        report_race("W-W", addr, w_tid, t->tid, line_no);
        raced = true;
    }

    if (x->R != READ_SHARED) {
        if (x->R != 0) {
            int r_tid   = get_tid(x->R);
            int r_clock = get_clock(x->R);
            if (r_clock > t->get_clock_of(r_tid)) {
                report_race("R-W", addr, r_tid, t->tid, line_no);
                raced = true;
            }
        }
    } else {
        for (int i = 0; i < (int)x->Rvc.size(); ++i) {
            if (x->Rvc[i] == 0) continue;
            if (get_clock(x->Rvc[i]) > t->get_clock_of(i)) {
                report_race("R-W", addr, i, t->tid, line_no);
                raced = true;
            }
        }
    }

    x->W = t->epoch;
    x->R = 0;
    x->Rvc.clear();
    return raced;
}

// ──────────────────────────────────────────────────────────────────
// 11. PUBLIC MEMORY ACCESS CALLBACKS
// ──────────────────────────────────────────────────────────────────

extern "C" {

void __ft_read(void* addr, int line_no) {
    ThreadState* t = get_current_thread();

    // ── FAST PATH (private variable, no lock, no heap dereference) ──
    //
    // get_shadow_entry only touches the flat shadow_table array.
    // If share_state == OWNED_READ or OWNED_WRITE and owner == t->tid,
    // we update x->R (to keep FT state accurate for a future SHARED
    // transition) and return.  The only memory touched is:
    //   [1] shadow_table[slot]  — one cache line in the flat array
    //   [2] the VarState on the heap — to write x->R
    //
    // NOTE ON x->R UPDATE:
    //   We must write x->R here so that when a different thread arrives
    //   and triggers OWNED→SHARED, FT has the correct last-read epoch.
    //   This write is to x->owner_clock (an int), which lives in the
    //   VarState.  We avoid the mutex because the owner is the only
    //   writer of owner_clock while in OWNED state.
    // ──────────────────────────────────────────────────────────────

    ShadowEntry* e = get_shadow_entry(addr);

    uint64_t hw = e->hot_word.load(std::memory_order_acquire);
    ShareState ss = hot_state(hw);
    int owner     = hot_owner(hw);

    if ((ss == ShareState::OWNED_READ || ss == ShareState::OWNED_WRITE)
        && owner == t->tid) {
        // Private read by owner. Update owner_clock so SHARED seeding
        // will be accurate. No mutex needed — we are the sole writer.
        VarState* x = e->state.load(std::memory_order_relaxed);
        if (x) {
            // No lock: only we write owner_clock + R while OWNED.
            x->owner_clock = t->C[t->tid];
            x->R = t->epoch;
        }
        return;
    }

    // ── SLOW PATH ──────────────────────────────────────────────────
    VarState* x = get_or_alloc_var_state(e);
    std::lock_guard<std::recursive_mutex> var_lk(x->mtx);
    std::lock_guard<std::recursive_mutex> thr_lk(t->mtx);

    // Re-read hot_word under lock — state may have changed.
    hw = e->hot_word.load(std::memory_order_acquire);
    ss = hot_state(hw);
    owner = hot_owner(hw);

    switch (ss) {
        case ShareState::UNACCESSED:
            x->owner_clock = t->C[t->tid];
            x->W = 0;
            x->R = t->epoch;
            e->hot_word.store(pack_hot(t->tid, ShareState::OWNED_READ),
                              std::memory_order_release);
            return;

        case ShareState::OWNED_READ:
        case ShareState::OWNED_WRITE:
            if (owner == t->tid) {
                x->owner_clock = t->C[t->tid];
                x->R = t->epoch;
                return;
            }
            if (ss == ShareState::OWNED_WRITE) {
                x->W = make_epoch(owner, x->owner_clock);
                x->R = 0;
            } else {
                x->W = 0;
                x->R = make_epoch(owner, x->owner_clock);
            }
            x->Rvc.clear();
            e->hot_word.store(pack_hot(t->tid, ShareState::SHARED),
                              std::memory_order_release);
            {
                bool raced = ft_read_core(addr, line_no, x, t);
                if (!raced && can_reclaim(t, x)) {
                    x->owner_clock = t->C[t->tid];
                    e->hot_word.store(pack_hot(t->tid, ShareState::OWNED_READ),
                                      std::memory_order_release);
                }
            }
            return;

        case ShareState::SHARED: {
            bool raced = ft_read_core(addr, line_no, x, t);
            if (!raced && can_reclaim(t, x)) {
                x->owner_clock = t->C[t->tid];
                x->Rvc.clear();
                e->hot_word.store(pack_hot(t->tid, ShareState::OWNED_READ),
                                  std::memory_order_release);
            }
            return;
        }
    }
}

void __ft_write(void* addr, int line_no) {
    ThreadState* t = get_current_thread();

    // ── FAST PATH ──────────────────────────────────────────────────
    ShadowEntry* e = get_shadow_entry(addr);

    uint64_t hw = e->hot_word.load(std::memory_order_acquire);
    ShareState ss = hot_state(hw);
    int owner     = hot_owner(hw);

    if ((ss == ShareState::OWNED_READ || ss == ShareState::OWNED_WRITE)
        && owner == t->tid) {
        VarState* x = e->state.load(std::memory_order_relaxed);
        if (x) {
            x->owner_clock = t->C[t->tid];
            x->W = t->epoch;
            x->R = 0;
        }
        // Upgrade to OWNED_WRITE if not already (single atomic store).
        if (ss != ShareState::OWNED_WRITE)
            e->hot_word.store(pack_hot(t->tid, ShareState::OWNED_WRITE),
                              std::memory_order_release);
        return;   // ← THE HOT PRIVATE PATH ENDS HERE
    }

    // ── SLOW PATH ──────────────────────────────────────────────────
    VarState* x = get_or_alloc_var_state(e);
    std::lock_guard<std::recursive_mutex> var_lk(x->mtx);
    std::lock_guard<std::recursive_mutex> thr_lk(t->mtx);

    hw    = e->hot_word.load(std::memory_order_acquire);
    ss    = hot_state(hw);
    owner = hot_owner(hw);

    switch (ss) {
        case ShareState::UNACCESSED:
            x->owner_clock = t->C[t->tid];
            x->W = t->epoch;
            x->R = 0;
            e->hot_word.store(pack_hot(t->tid, ShareState::OWNED_WRITE),
                              std::memory_order_release);
            return;

        case ShareState::OWNED_READ:
        case ShareState::OWNED_WRITE:
            if (owner == t->tid) {
                x->owner_clock = t->C[t->tid];
                x->W = t->epoch;
                x->R = 0;
                e->hot_word.store(pack_hot(t->tid, ShareState::OWNED_WRITE),
                                  std::memory_order_release);
                return;
            }
            if (ss == ShareState::OWNED_WRITE) {
                x->W = make_epoch(owner, x->owner_clock);
                x->R = 0;
            } else {
                x->W = 0;
                x->R = make_epoch(owner, x->owner_clock);
            }
            x->Rvc.clear();
            e->hot_word.store(pack_hot(t->tid, ShareState::SHARED),
                              std::memory_order_release);
            {
                bool raced = ft_write_core(addr, line_no, x, t);
                if (!raced && can_reclaim(t, x)) {
                    x->owner_clock = t->C[t->tid];
                    x->R = 0;
                    x->Rvc.clear();
                    e->hot_word.store(pack_hot(t->tid, ShareState::OWNED_WRITE),
                                      std::memory_order_release);
                }
            }
            return;

        case ShareState::SHARED: {
            bool raced = ft_write_core(addr, line_no, x, t);
            if (!raced && can_reclaim(t, x)) {
                x->owner_clock = t->C[t->tid];
                x->R = 0;
                x->Rvc.clear();
                e->hot_word.store(pack_hot(t->tid, ShareState::OWNED_WRITE),
                                  std::memory_order_release);
            }
            return;
        }
    }
}

// ──────────────────────────────────────────────────────────────────
// 12. THREAD LIFECYCLE CALLBACKS
// ──────────────────────────────────────────────────────────────────

struct ThreadContext {
    void* (*original_routine)(void*);
    void* original_arg;
    std::vector<int> parent_vc_snapshot;
};

void* __ft_prepare_context(void* routine, void* arg) {
    ThreadContext* ctx = new ThreadContext();
    ctx->original_routine = (void*(*)(void*))routine;
    ctx->original_arg     = arg;
    ThreadState* parent = get_current_thread();
    std::lock_guard<std::recursive_mutex> lk(parent->mtx);
    ctx->parent_vc_snapshot = parent->C;
    return ctx;
}

void* thread_wrapper(void* raw_args) {
    ThreadContext* ctx   = (ThreadContext*)raw_args;
    ThreadState*   child = get_current_thread();
    {
        std::lock_guard<std::recursive_mutex> lk(child->mtx);
        child->C = ctx->parent_vc_snapshot;
        if (child->tid >= (int)child->C.size())
            child->C.resize(child->tid + 1, 0);
        child->C[child->tid] = 1;
        child->epoch = make_epoch(child->tid, child->C[child->tid]);
    }
    void* result = ctx->original_routine(ctx->original_arg);
    delete ctx;
    tl_thread_state = nullptr;
    return result;
}

void __ft_thread_create(uint64_t /*child_id_raw*/) {
    ThreadState* parent = get_current_thread();
    std::lock_guard<std::recursive_mutex> lk(parent->mtx);
    parent->C[parent->tid]++;
    parent->epoch = make_epoch(parent->tid, parent->C[parent->tid]);
}

void __ft_thread_join(uint64_t child_raw_id) {
    ThreadState* parent = get_current_thread();
    ThreadState* child  = nullptr;
    std::map<pthread_t, ThreadState*>::iterator it;
    {
        std::lock_guard<std::recursive_mutex> lk(get_thread_map_lock());
        auto& threads = get_threads_map();
        it = threads.find((pthread_t)child_raw_id);
        if (it != threads.end()) child = it->second;
    }
    if (!child) {
        printf("[FastTrack] WARNING: joined thread %lu not found.\n",
               (unsigned long)child_raw_id);
        return;
    }
    {
        std::lock_guard<std::recursive_mutex> pl(parent->mtx);
        std::lock_guard<std::recursive_mutex> cl(child->mtx);
        size_t len = std::max(parent->C.size(), child->C.size());
        if (parent->C.size() < len) parent->C.resize(len, 0);
        for (size_t i = 0; i < child->C.size(); ++i)
            if (child->C[i] > parent->C[i]) parent->C[i] = child->C[i];
        parent->epoch = make_epoch(parent->tid, parent->C[parent->tid]);
        // Parent's VC now dominates the child's. On the parent's next access
        // to any SHARED variable last touched only by this child, can_reclaim()
        // returns true and the variable transitions back to OWNED_*.
    }
    {
        std::lock_guard<std::recursive_mutex> lk(get_thread_map_lock());
        get_threads_map().erase(it);
    }
    delete child;
}

// ──────────────────────────────────────────────────────────────────
// 13. LOCK CALLBACKS
// ──────────────────────────────────────────────────────────────────

void __ft_lock(void* mutex_addr) {
    ThreadState* t = get_current_thread();
    LockState*   m = get_lock_state(mutex_addr);
    std::lock_guard<std::recursive_mutex> lm(m->mtx);
    std::lock_guard<std::recursive_mutex> lt(t->mtx);
    if (m->L.size() > t->C.size()) t->C.resize(m->L.size(), 0);
    for (size_t i = 0; i < m->L.size(); ++i)
        if (m->L[i] > t->C[i]) t->C[i] = m->L[i];
    t->epoch = make_epoch(t->tid, t->C[t->tid]);
}

void __ft_unlock(void* mutex_addr) {
    ThreadState* t = get_current_thread();
    LockState*   m = get_lock_state(mutex_addr);
    std::lock_guard<std::recursive_mutex> lm(m->mtx);
    std::lock_guard<std::recursive_mutex> lt(t->mtx);
    if (t->C.size() > m->L.size()) m->L.resize(t->C.size(), 0);
    for (size_t i = 0; i < t->C.size(); ++i) m->L[i] = t->C[i];
    t->C[t->tid]++;
    t->epoch = make_epoch(t->tid, t->C[t->tid]);
}

} // extern "C"