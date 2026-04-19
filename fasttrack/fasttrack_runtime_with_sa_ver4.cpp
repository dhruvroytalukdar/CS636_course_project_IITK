#include <bits/stdc++.h>
#include <pthread.h>
#include <mutex>
#include <atomic>
#include <cassert>
#include <time.h>

// ──────────────────────────────────────────────────────────────────
// 1. EPOCH HELPERS
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
// 2. SHARING-ANALYSIS STATE ENUM
// ──────────────────────────────────────────────────────────────────

enum class ShareState : uint8_t {
    UNACCESSED,
    OWNED_READ,
    OWNED_WRITE,
    SHARED
};

// ──────────────────────────────────────────────────────────────────
// 3. STATE STRUCTS
// ──────────────────────────────────────────────────────────────────

struct ThreadState {
    int tid;
    std::vector<int> C;   // vector clock; C[u] = latest known clock of thread u
    Epoch epoch;
    std::recursive_mutex mtx;

    ThreadState(int id) : tid(id) {
        if ((size_t)tid >= (int)C.size()) C.resize(tid + 1, 0);
        C[tid] = 1;
        epoch  = make_epoch(tid, 1);
    }

    int get_clock_of(int u) const {
        if (u < 0 || u >= (int)C.size()) return 0;
        return C[u];
    }
};

struct VarState {
    // ── SA layer ──────────────────────────────────────────────────
    ShareState  share_state { ShareState::UNACCESSED };
    int         owner_tid   { -1 };
    std::vector<Epoch> shared_accessors;


    // ── FT layer ──────────────────────────────────────────────────
    Epoch W { 0 };
    Epoch R { 0 };
    std::vector<Epoch> Rvc;

    std::recursive_mutex mtx;
};

struct LockState {
    std::vector<int> L;
    std::recursive_mutex mtx;
};

struct alignas(64) ShadowEntry {
    std::atomic<uintptr_t> key   {0};
    std::atomic<VarState*> state {nullptr};
};

// ──────────────────────────────────────────────────────────────────
// 4. GLOBAL STATE
// ──────────────────────────────────────────────────────────────────

static std::atomic<int>  next_tid   {1};
static std::atomic<int>  race_count {0};
static ShadowEntry       shadow_table[SHADOW_SIZE];
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
static std::shared_mutex& get_shared_vars_lock() {
    static std::shared_mutex m; return m;
}
static std::unordered_set<VarState*>& get_shared_vars() {
    static auto* s = new std::unordered_set<VarState*>(); return *s;
}

// ──────────────────────────────────────────────────────────────────
// 5. INFRASTRUCTURE HELPERS
// ──────────────────────────────────────────────────────────────────

static ThreadState* get_current_thread() {
    if (tl_thread_state) return tl_thread_state;
    pthread_t self = pthread_self();
    std::lock_guard<std::recursive_mutex> lk(get_thread_map_lock());
    auto& threads = get_threads_map();
    if (threads.find(self) == threads.end())
        threads[self] = new ThreadState(next_tid++);
    tl_thread_state = threads[self];
    return tl_thread_state;
}

static VarState* get_var_state(void* addr) {
    uintptr_t key  = ((uintptr_t)addr >> 2) + 1;
    size_t    slot = (key * 2654435761ULL) & SHADOW_MASK;

    for (;;) {
        uintptr_t cur = shadow_table[slot].key.load(std::memory_order_acquire);
        if (cur == key) {
            VarState* s;
            while ((s = shadow_table[slot].state.load(std::memory_order_acquire)) == nullptr)
                ; // spin while winner initialises
            return s;
        }
        if (cur == 0) {
            uintptr_t expected = 0;
            if (shadow_table[slot].key.compare_exchange_strong(
                    expected, key, std::memory_order_acq_rel)) {
                VarState* ns = new VarState();
                shadow_table[slot].state.store(ns, std::memory_order_release);
                return ns;
            }
            continue; // CAS lost, retry
        }
        slot = (slot + 1) & SHADOW_MASK;
    }
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
    
    // Print the line number cleanly!
    printf("[FASTTRACK LOG] | TYPE: %s | ADDR: %p | THREADS: %d-%d | LINE: %d | TS_NS: %llu\n",
           type, addr, tid1, tid2, line_no, (unsigned long long)ns);
}

// Safe indexed set helpers
static void vec_set_int(std::vector<int>& v, int idx, int val) {
    if (idx >= (int)v.size()) v.resize(idx + 1, 0);
    v[idx] = val;
}
static void vec_set_epoch(std::vector<Epoch>& v, int idx, Epoch val) {
    if (idx >= (int)v.size()) v.resize(idx + 1, 0);
    v[idx] = val;
}

// ──────────────────────────────────────────────────────────────────
// 6. SA HELPERS
// ──────────────────────────────────────────────────────────────────

// Returns true iff thread t has seen (happens-after) epoch (owner_tid, owner_clock).
static bool hb_before(ThreadState* t, int owner_tid, int owner_clock) {
    if (t->tid == owner_tid) return true;
    return t->get_clock_of(owner_tid) >= owner_clock;
}

static void try_reclaim_ownership(ThreadState* t) {
    std::lock_guard<std::shared_mutex> sl(get_shared_vars_lock());
    auto& sv = get_shared_vars();

    for (auto it = sv.begin(); it != sv.end(); ) {
        VarState* x = *it;
        std::lock_guard<std::recursive_mutex> var_lk(x->mtx);

        bool can_reclaim = true;
        for (int u = 0; u < (int)x->shared_accessors.size(); ++u) {
            Epoch e = x->shared_accessors[u];
            if (e == 0) continue;
            if (!hb_before(t, u, get_clock(e))) {
                can_reclaim = false;
                break;
            }
        }

        if (can_reclaim) {
            x->share_state = ShareState::OWNED_WRITE;
            x->owner_tid   = t->tid;
            x->shared_accessors.clear();
            it = sv.erase(it);
        } else {
            ++it;
        }
    }
}

// ──────────────────────────────────────────────────────────────────
// 7. FT CORE FUNCTIONS (require var_lock + thread_lock held)
//    These are identical to plain FT — SA just decides when to call them.
// ──────────────────────────────────────────────────────────────────

// Returns true if a race was reported.
static bool ft_read_core(void* addr, int line_no,
                         VarState* x, ThreadState* t) {
    // Fast path: same epoch
    if (x->R == t->epoch) return false;

    // Write-Read race check
    int w_tid   = get_tid(x->W);
    int w_clock = get_clock(x->W);
    if (w_clock > t->get_clock_of(w_tid)) {
        report_race("W-R", addr, w_tid, t->tid, line_no);
        x->R = t->epoch;
        return true;
    }

    // Update read state
    if (x->R == READ_SHARED) {
        vec_set_epoch(x->Rvc, t->tid, t->epoch);
    } else {
        int r_tid   = get_tid(x->R);
        int r_clock = get_clock(x->R);
        if (r_clock <= t->get_clock_of(r_tid)) {
            x->R = t->epoch;   // take exclusive read ownership
        } else {
            // Two concurrent readers → transition to READ_SHARED
            Epoch old_R = x->R;
            x->Rvc.clear();
            vec_set_epoch(x->Rvc, r_tid,   old_R);
            vec_set_epoch(x->Rvc, t->tid,  t->epoch);
            x->R = READ_SHARED;
        }
    }
    return false;
}

// Returns true if a race was reported.
static bool ft_write_core(void* addr, int line_no,
                          VarState* x, ThreadState* t) {
    // Fast path: same epoch
    if (x->W == t->epoch) return false;

    // Write-Write race check
    int w_tid   = get_tid(x->W);
    int w_clock = get_clock(x->W);
    if (w_clock > t->get_clock_of(w_tid)) {
        report_race("W-W", addr, w_tid, t->tid, line_no);
        x->W = t->epoch;
        return true;
    }

    bool race_reported = false;
    // Read-Write race check
    if (x->R != READ_SHARED) {
        if (x->R != 0) {
            int r_tid   = get_tid(x->R);
            int r_clock = get_clock(x->R);
            if (r_clock > t->get_clock_of(r_tid)) {
                report_race("R-W", addr, r_tid, t->tid, line_no);
                race_reported = true;
            }
        }
    } else {
        for (int i = 0; i < (int)x->Rvc.size(); ++i) {
            if (x->Rvc[i] == 0) continue;
            int u_clock = get_clock(x->Rvc[i]);
            if (u_clock > t->get_clock_of(i)) {
                report_race("R-W", addr, i, t->tid, line_no);
                race_reported = true;
            }
        }
    }

    x->W = t->epoch;
    x->R = 0;
    x->Rvc.clear();
    return race_reported;
}

// ──────────────────────────────────────────────────────────────────
// 8. PUBLIC MEMORY ACCESS CALLBACKS
// ──────────────────────────────────────────────────────────────────

extern "C" {

void __ft_read(void* addr, int line_no) {
    ThreadState* t = get_current_thread();
    VarState* x = get_var_state(addr);

    std::lock_guard<std::recursive_mutex> var_lk(x->mtx);
    std::lock_guard<std::recursive_mutex> thr_lk(t->mtx);

    switch (x->share_state) {
        case ShareState::UNACCESSED:
            x->owner_tid   = t->tid;
            x->share_state = ShareState::OWNED_READ;
            x->R = t->epoch;
            x->W = 0;
            return;

        case ShareState::OWNED_READ:
        case ShareState::OWNED_WRITE:
            if (x->owner_tid == t->tid) {
                // Owner is reading. Update R.
                // Do NOT downgrade OWNED_WRITE to OWNED_READ.
                x->R = t->epoch;
                return;
            }
            
            // Different thread. Transition to SHARED.
            // W and R are already accurate from the owner's phase.
            x->share_state = ShareState::SHARED;
            {
                std::lock_guard<std::shared_mutex> sl(get_shared_vars_lock());
                get_shared_vars().insert(x);
            }
            vec_set_epoch(x->shared_accessors, t->tid, t->epoch);
            ft_read_core(addr, line_no, x, t);
            return;

        case ShareState::SHARED:
            // vec_set_epoch(x->shared_accessors, t->tid, t->epoch);
            if (x->shared_accessors.size() <= (size_t)t->tid ||
                x->shared_accessors[t->tid] != t->epoch) {
                vec_set_epoch(x->shared_accessors, t->tid, t->epoch);
            }
            ft_read_core(addr, line_no, x, t);
            return;
    }
}

void __ft_write(void* addr, int line_no) {
    ThreadState* t = get_current_thread();
    VarState* x = get_var_state(addr);

    std::lock_guard<std::recursive_mutex> var_lk(x->mtx);
    std::lock_guard<std::recursive_mutex> thr_lk(t->mtx);

    switch (x->share_state) {
        case ShareState::UNACCESSED:
            x->owner_tid   = t->tid;
            x->share_state = ShareState::OWNED_WRITE;
            x->W = t->epoch;
            x->R = 0;
            return;

        case ShareState::OWNED_READ:
        case ShareState::OWNED_WRITE:
            if (x->owner_tid == t->tid) {
                // Owner is writing. Update state and W.
                x->share_state = ShareState::OWNED_WRITE;
                x->W = t->epoch;
                x->R = 0; // Write supersedes owner's previous reads
                return;
            }

            // Different thread. Transition to SHARED.
            x->share_state = ShareState::SHARED;
            {
                std::lock_guard<std::shared_mutex> sl(get_shared_vars_lock());
                get_shared_vars().insert(x);
            }
            vec_set_epoch(x->shared_accessors, t->tid, t->epoch);
            ft_write_core(addr, line_no, x, t);
            return;

        case ShareState::SHARED:
            // vec_set_epoch(x->shared_accessors, t->tid, t->epoch);
            if (x->shared_accessors.size() <= (size_t)t->tid ||
                x->shared_accessors[t->tid] != t->epoch) {
                vec_set_epoch(x->shared_accessors, t->tid, t->epoch);
            }
            ft_write_core(addr, line_no, x, t);
            return;
    }
}


// ──────────────────────────────────────────────────────────────────
// 9. THREAD LIFECYCLE CALLBACKS
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
    parent->C[parent->tid]++;
    parent->epoch = make_epoch(parent->tid, parent->C[parent->tid]);
    ctx->parent_vc_snapshot = parent->C;
    return ctx;
}

void* thread_wrapper(void* raw_args) {
    ThreadContext* ctx   = (ThreadContext*)raw_args;
    ThreadState*   child = get_current_thread();
    {
        std::lock_guard<std::recursive_mutex> lk(child->mtx);
        child->C = ctx->parent_vc_snapshot;
        if ((size_t)child->tid >= child->C.size())
            child->C.resize(child->tid + 1, 0);
        child->C[child->tid] = 1;
        child->epoch = make_epoch(child->tid, child->C[child->tid]);
    }
 
    void* result = ctx->original_routine(ctx->original_arg);
    delete ctx;
    tl_thread_state = nullptr;
    return result;
}

void __ft_thread_create(uint64_t child_id_raw) {
    // ThreadState* parent = get_current_thread();
    // std::lock_guard<std::recursive_mutex> lk(parent->mtx);
    // parent->C[parent->tid]++;
    // parent->epoch = make_epoch(parent->tid, parent->C[parent->tid]);
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
    }

    // try_reclaim_ownership(parent);

    {
        std::lock_guard<std::recursive_mutex> lock(get_thread_map_lock());
        get_threads_map().erase(it);
    }
    delete child;
}


// ──────────────────────────────────────────────────────────────────
// 10. LOCK CALLBACKS
// ──────────────────────────────────────────────────────────────────

void __ft_lock(void* mutex_addr) {
    ThreadState* t = get_current_thread();
    LockState* m = get_lock_state(mutex_addr);
 
    std::lock_guard<std::recursive_mutex> lock(m->mtx);
    std::lock_guard<std::recursive_mutex> lock2(t->mtx);
 
    // FT vector clock merge (unchanged)
    if (m->L.size() > t->C.size())
        t->C.resize(m->L.size(), 0);
    for (size_t i = 0; i < m->L.size(); i++)
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
}