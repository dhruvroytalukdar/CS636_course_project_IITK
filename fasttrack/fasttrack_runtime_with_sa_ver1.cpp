#include <bits/stdc++.h>
#include <cstdio>
#include <pthread.h>
#include <mutex>
#include <atomic>
#include <cassert>
#include <time.h>

#define SHADOW_SIZE  (1 << 20)
#define SHADOW_MASK  (SHADOW_SIZE - 1)

typedef unsigned long long Epoch;

const Epoch READ_SHARED = (Epoch)-1;
const int   CLOCK_BITS  = 32;
const Epoch CLOCK_MASK  = 0xFFFFFFFF;

Epoch make_epoch(int tid, int clock) {
    return ((Epoch)tid << CLOCK_BITS) | (clock & CLOCK_MASK);
}
int get_tid(Epoch e)   { return (int)(e >> CLOCK_BITS); }
int get_clock(Epoch e) { return (int)(e & CLOCK_MASK); }


// ==========================================
// 2. SHARING ANALYSIS STATE
// ==========================================

enum class ShareState : uint8_t {
    UNACCESSED,   // No thread has ever accessed this location
    OWNED,        // Exactly one thread owns this location exclusively
    SHARED        // Two+ threads have accessed without HB ordering → call client
};


// ==========================================
// 3. STATE CLASSES
// ==========================================

struct ThreadState {
    int tid;
    std::vector<int> C;   // Vector clock: C[u] = latest known clock of thread u
    Epoch epoch;          
    std::recursive_mutex mtx;

    ThreadState(int id) : tid(id) {
        if (tid >= (int)C.size()) C.resize(tid + 1, 0);
        C[tid] = 1;
        epoch  = make_epoch(tid, 1);
    }

    int get_clock_of(int u) const {
        if (u >= (int)C.size()) return 0;
        return C[u];
    }
};

struct VarState {
    // ── Sharing analysis fields ────────────────────────────────────
    std::atomic<ShareState> share_state { ShareState::UNACCESSED };
    std::atomic<int>        owner_tid   { 0 };

    // owner_epoch: C[owner_tid] at the time ownership was last confirmed.
    // Only meaningful when share_state == OWNED and accessed by a different
    // thread. NOT updated on every same-thread access [primary optimization].
    int owner_epoch { 0 };

    // When SHARED: track the latest access epoch per thread so we can
    // detect when a writer has seen all prior accessors (then collapse back to OWNED).
    // Mirrors the role of FastTrack's Rvc but for sharing analysis.
    std::unordered_map<int, int> access_vc;

    Epoch W { 0 };
    Epoch R { 0 };
    std::unordered_map<int, Epoch> Rvc;

    std::recursive_mutex mtx;
};

struct LockState {
    std::vector<int> L;   // Lock vector clock
    std::recursive_mutex mtx;
};

struct ShadowEntry {
    std::atomic<uintptr_t> key {0};
    std::atomic<VarState*> state {nullptr};
};

// ==========================================
// 4. GLOBAL STATE
// ==========================================

static std::atomic<int> next_tid   { 1 };
static std::atomic<int> race_count { 0 };
static ShadowEntry shadow_table[SHADOW_SIZE];
static thread_local ThreadState* tl_thread_state = nullptr;

std::recursive_mutex& get_thread_map_lock() {
    static std::recursive_mutex mtx; return mtx;
}
std::map<pthread_t, ThreadState*>& get_threads_map() {
    static auto* m = new std::map<pthread_t, ThreadState*>(); return *m;
}
std::recursive_mutex& get_shadow_lock() {
    static std::recursive_mutex mtx; return mtx;
}
std::unordered_map<void*, VarState*>& get_shadow_vars() {
    static auto* m = new std::unordered_map<void*, VarState*>(); return *m;
}
std::recursive_mutex& get_lock_registry_lock() {
    static std::recursive_mutex mtx; return mtx;
}
std::unordered_map<void*, LockState*>& get_shadow_locks() {
    static auto* m = new std::unordered_map<void*, LockState*>(); return *m;
}


// ==========================================
// 5. INFRASTRUCTURE HELPERS
// ==========================================

ThreadState* get_current_thread() {
    // If thread information is already stored then just return it
    if (tl_thread_state) return tl_thread_state;

    // Otherwise, create new thread state and store it
    pthread_t self = pthread_self();
    std::lock_guard<std::recursive_mutex> lock(get_thread_map_lock());
    auto& threads = get_threads_map();
    if (threads.find(self) == threads.end())
        threads[self] = new ThreadState(next_tid++);
    tl_thread_state = threads[self];
    return tl_thread_state;
}

// ThreadState* get_thread_by_tid(int tid) {
//     std::lock_guard<std::recursive_mutex> lock(get_thread_map_lock());
//     for (auto& [pt, ts] : get_threads_map())
//         if (ts->tid == tid) return ts;
//     return nullptr;
// }

VarState* get_var_state(void* addr) {
    uintptr_t key  = (uintptr_t)addr >> 2;   // 4-byte granularity
    size_t    slot = (key * 2654435761ULL) & SHADOW_MASK;  // Knuth hash

    while (true) {
        uintptr_t current_key = shadow_table[slot].key.load(std::memory_order_acquire);
        
        if (current_key == key) {
            // Key matches. Wait for the winner of the CAS to finish initializing state.
            VarState* s;
            while ((s = shadow_table[slot].state.load(std::memory_order_acquire)) == nullptr) {
                // ## CHECK: Spin-wait briefly otherwise showing error. Dont know why.
                // Putting this works
                std::this_thread::yield();
            }
            return s;
        }

        if (current_key == 0) {
            // Slot is empty. Try to claim it.
            uintptr_t expected = 0;
            if (shadow_table[slot].key.compare_exchange_strong(expected, key, std::memory_order_acq_rel)) {
                // We won the race! Initialize the state.
                VarState* new_state = new VarState();
                shadow_table[slot].state.store(new_state, std::memory_order_release);
                return new_state;
            }
            // If CAS failed, someone else claimed it. Loop around and check again.
            continue;
        }

        // Hash collision. Probe next.
        slot = (slot + 1) & SHADOW_MASK;
    }
}

LockState* get_lock_state(void* mutex_addr) {
    std::lock_guard<std::recursive_mutex> lock(get_lock_registry_lock());
    auto& sl = get_shadow_locks();
    if (sl.find(mutex_addr) == sl.end()) sl[mutex_addr] = new LockState();
    return sl[mutex_addr];
}

void report_race(const char* type, void* addr, int tid1, int tid2, char* inst_str) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    uint64_t ns = (uint64_t)ts.tv_sec * 1000000000ULL
                + (uint64_t)ts.tv_nsec;

    printf("[FASTTRACK LOG] | TYPE: %s | ADDR: %p | THREADS: %d-%d | TS_NS: %llu\n",
           type, addr, tid1, tid2, (unsigned long long)ns);
    printf("    IR INST: %s\n", inst_str);
}


// ==========================================
// 6. SHARING ANALYSIS HELPERS
// ==========================================

// Core decision: has thread `t` seen the access made by `owner_tid` at `owner_epoch`?
bool is_ordered(ThreadState* t, int owner_tid, int owner_epoch) {
    if (t->tid == owner_tid) return true;           // same thread → always ordered
    return t->get_clock_of(owner_tid) >= owner_epoch; // HB check via vector clock
}

// Can thread `t` reclaim exclusive ownership of a SHARED location?
// YES iff t's vector clock dominates every entry in access_vc.
// This mirrors FastTrack's READ_SHARED → exclusive collapse on write.
bool can_reclaim_ownership(ThreadState* t,
                           const std::unordered_map<int, int>& access_vc) {
    for (auto& [uid, uepoch] : access_vc) {
        if (uid == t->tid) continue;
        if (t->get_clock_of(uid) < uepoch) return false; // t hasn't seen uid's access
    }
    return true;
}


// ==========================================
// 7. FASTTRACK CLIENT FUNCTIONS
// ==========================================

void __ft_read_client(void* addr, char* inst_str,
                      VarState* x, ThreadState* t,
                      std::unique_lock<std::recursive_mutex>& var_lock,
                      std::unique_lock<std::recursive_mutex>& thread_lock) {

    assert(var_lock.owns_lock()    && "VarState lock must be held by caller");
    assert(thread_lock.owns_lock() && "ThreadState lock must be held by caller");

    // Fast path: same epoch → no state change needed
    if (x->R == t->epoch) return;

    // Write-Read race check: was the last write unseen by t?
    int w_tid   = get_tid(x->W);
    int w_clock = get_clock(x->W);
    if (w_clock > t->get_clock_of(w_tid)) {
        report_race("W-R", addr, w_tid, t->tid, inst_str);
        return;
    }

    // Update read state
    if (x->R == READ_SHARED) {
        // Already shared reads → just record this thread's epoch
        x->Rvc[t->tid] = t->epoch;
    } else {
        int r_tid   = get_tid(x->R);
        int r_clock = get_clock(x->R);
        if (r_clock <= t->get_clock_of(r_tid)) {
            // Previous reader is HB-before us → take exclusive read ownership
            x->R = t->epoch;
        } else {
            // Two concurrent readers → transition to READ_SHARED
            x->Rvc.clear();
            x->Rvc[r_tid]  = x->R;
            x->Rvc[t->tid] = t->epoch;
            x->R = READ_SHARED;
        }
    }
}

void __ft_write_client(void* addr, char* inst_str,
                       VarState* x, ThreadState* t,
                       std::unique_lock<std::recursive_mutex>& var_lock,
                       std::unique_lock<std::recursive_mutex>& thread_lock) {

    assert(var_lock.owns_lock()    && "VarState lock must be held by caller");
    assert(thread_lock.owns_lock() && "ThreadState lock must be held by caller");

    // Fast path: same epoch → no state change needed
    if (x->W == t->epoch) return;

    // Write-Write race check
    int w_tid   = get_tid(x->W);
    int w_clock = get_clock(x->W);
    if (w_clock > t->get_clock_of(w_tid)) {
        report_race("W-W", addr, w_tid, t->tid, inst_str);
        return;
    }

    // Read-Write race check
    if (x->R != READ_SHARED) {
        if (x->R != 0) {
            int r_tid   = get_tid(x->R);
            int r_clock = get_clock(x->R);
            if (r_clock > t->get_clock_of(r_tid)) {
                report_race("R-W", addr, r_tid, t->tid, inst_str);
                return;
            }
        }
    } else {
        for (auto const& [u_tid, u_epoch] : x->Rvc) {
            int u_clock = get_clock(u_epoch);
            if (u_clock > t->get_clock_of(u_tid)) {
                report_race("R-W", addr, u_tid, t->tid, inst_str);
                return;
            }
        }
    }

    x->W = t->epoch;
}


// ==========================================
// 8. PUBLIC MEMORY ACCESS CALLBACKS
// ==========================================

extern "C" {

void __ft_read(void* addr, char* inst_str) {
    ThreadState* t = get_current_thread();
    VarState*    x = get_var_state(addr);

    // ── LOCK-FREE FAST PATH ────────────────────────────────────────
    // If location is OWNED by the current thread, skip entirely.
    if (x->share_state.load(std::memory_order_acquire) == ShareState::OWNED
        && x->owner_tid.load(std::memory_order_relaxed) == t->tid) {
        return;
    }

    // ── acquire locks and handle all other cases ────────
    std::unique_lock<std::recursive_mutex> var_lock(x->mtx);
    std::unique_lock<std::recursive_mutex> thread_lock(t->mtx);

    // Re-check under lock
    switch (x->share_state.load(std::memory_order_acquire)) {

        case ShareState::UNACCESSED:
            // First ever access → take ownership
            x->owner_tid.store(t->tid, std::memory_order_relaxed);
            x->owner_epoch = t->C[t->tid];
            x->share_state.store(ShareState::OWNED, std::memory_order_release);
            return;

        case ShareState::OWNED: {
            if (x->owner_tid.load() == t->tid) {
                // Same thread confirmed under lock → nothing to do
                return;
            }

            // Different thread → check HB ordering using owner's current clock
            int owner_tid_val   = x->owner_tid.load();
            int current_o_epoch = x->owner_epoch;

            if (is_ordered(t, owner_tid_val, current_o_epoch)) {
                // HB edge exists
                x->owner_tid.store(t->tid, std::memory_order_relaxed);
                x->owner_epoch = t->C[t->tid];
                return;
            }

            // No HB → truly shared
            x->access_vc[owner_tid_val] = current_o_epoch;
            x->access_vc[t->tid]        = t->C[t->tid];
            x->share_state.store(ShareState::SHARED, std::memory_order_release);
            x->W = make_epoch(owner_tid_val, current_o_epoch); 
            x->R = 0; x->Rvc.clear();
        }

        case ShareState::SHARED:
            // Record access in sharing VC (used for SHARED→OWNED collapse on write)
            x->access_vc[t->tid] = t->C[t->tid];
            __ft_read_client(addr, inst_str, x, t, var_lock, thread_lock);
            break;
    }
}

void __ft_write(void* addr, char* inst_str) {
    ThreadState* t = get_current_thread();
    VarState*    x = get_var_state(addr);

    // ── LOCK-FREE FAST PATH ────────────────────────────────────────
    if (x->share_state.load(std::memory_order_acquire) == ShareState::OWNED
        && x->owner_tid.load(std::memory_order_relaxed) == t->tid) {
        return;
    }

    // ── SLOW PATH ──────────────────────────────────────────────────
    std::unique_lock<std::recursive_mutex> var_lock(x->mtx);
    std::unique_lock<std::recursive_mutex> thread_lock(t->mtx);

    switch (x->share_state.load(std::memory_order_acquire)) {

    case ShareState::UNACCESSED:
        x->owner_tid.store(t->tid, std::memory_order_relaxed);
        x->owner_epoch = t->C[t->tid];
        x->share_state.store(ShareState::OWNED, std::memory_order_release);
        return;

    case ShareState::OWNED: {
        if (x->owner_tid.load() == t->tid) {
            return;  // FastTrack never called
        }

        int owner_tid_val   = x->owner_tid.load();
        int current_o_epoch = x->owner_epoch;

        if (is_ordered(t, owner_tid_val, current_o_epoch)) {
            x->owner_tid.store(t->tid, std::memory_order_relaxed);
            x->owner_epoch = t->C[t->tid];
            return;
        }

        x->access_vc[owner_tid_val] = current_o_epoch;
        x->access_vc[t->tid]        = t->C[t->tid];
        x->share_state.store(ShareState::SHARED, std::memory_order_release);
        x->W = 0; x->R = 0; x->Rvc.clear();
        // FALL THROUGH
    }

    case ShareState::SHARED: {
        // ── SHARED → OWNED COLLAPSE (mirrors FastTrack's READ_SHARED → exclusive)
        // A write by T that has seen ALL prior accessors can reclaim exclusivity.
        // This is the key optimization: after a barrier/join, a single-writer
        // phase no longer pays FastTrack overhead.
        if (can_reclaim_ownership(t, x->access_vc)) {
            // T has seen everyone → safe to reclaim exclusive ownership
            x->share_state.store(ShareState::OWNED, std::memory_order_release);
            x->owner_tid.store(t->tid, std::memory_order_relaxed);
            x->owner_epoch = t->C[t->tid];
            x->access_vc.clear();

            // Reset FastTrack state: T owns everything, clean slate
            x->W = t->epoch;
            x->R = 0;
            x->Rvc.clear();
            return;  // FastTrack NOT called — we just reclaimed
        }

        // Cannot reclaim → update access_vc and delegate to FastTrack
        x->access_vc[t->tid] = t->C[t->tid];
        __ft_write_client(addr, inst_str, x, t, var_lock, thread_lock);
        break;
    }
    }
}


// ==========================================
// 9. THREAD LIFECYCLE CALLBACKS
// ==========================================

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
    std::lock_guard<std::recursive_mutex> lock(parent->mtx);
    ctx->parent_vc_snapshot = parent->C;
    return ctx;
}

void* thread_wrapper(void* raw_args) {
    ThreadContext* ctx   = (ThreadContext*)raw_args;
    ThreadState*   child = get_current_thread();

    {
        std::lock_guard<std::recursive_mutex> lock(child->mtx);
        child->C = ctx->parent_vc_snapshot;
        if (child->tid >= (int)child->C.size())
            child->C.resize(child->tid + 1, 0);
        child->C[child->tid] = 1;
        child->epoch = make_epoch(child->tid, child->C[child->tid]);
    }

    void* result = ctx->original_routine(ctx->original_arg);
    delete ctx;
    return result;
}

void __ft_thread_create(uint64_t /*child_id_raw*/) {
    ThreadState* parent = get_current_thread();
    std::lock_guard<std::recursive_mutex> lock(parent->mtx);
    parent->C[parent->tid]++;
    parent->epoch = make_epoch(parent->tid, parent->C[parent->tid]);
}

void __ft_thread_join(uint64_t child_raw_id) {
    ThreadState* parent = get_current_thread();
    ThreadState* child  = nullptr;

    {
        std::lock_guard<std::recursive_mutex> lock(get_thread_map_lock());
        auto& threads = get_threads_map();
        auto it = threads.find((pthread_t)child_raw_id);
        if (it != threads.end()) child = it->second;
    }

    if (!child) {
        printf("[FastTrack] WARNING: joined thread %lu not found.\n",
               (unsigned long)child_raw_id);
        return;
    }

    std::lock_guard<std::recursive_mutex> pl(parent->mtx);
    std::lock_guard<std::recursive_mutex> cl(child->mtx);

    size_t len = std::max(parent->C.size(), child->C.size());
    if (parent->C.size() < len) parent->C.resize(len, 0);

    for (size_t i = 0; i < child->C.size(); i++)
        if (child->C[i] > parent->C[i]) parent->C[i] = child->C[i];

    parent->epoch = make_epoch(parent->tid, parent->C[parent->tid]);
}


// ==========================================
// 10. LOCK CALLBACKS
// ==========================================

void __ft_lock(void* mutex_addr) {
    ThreadState* t = get_current_thread();
    LockState*   m = get_lock_state(mutex_addr);

    std::lock_guard<std::recursive_mutex> lm(m->mtx);
    std::lock_guard<std::recursive_mutex> lt(t->mtx);

    if (m->L.size() > t->C.size()) t->C.resize(m->L.size(), 0);
    for (size_t i = 0; i < m->L.size(); i++)
        if (m->L[i] > t->C[i]) t->C[i] = m->L[i];

    // Update epoch after clock merge
    t->epoch = make_epoch(t->tid, t->C[t->tid]);
}

void __ft_unlock(void* mutex_addr) {
    ThreadState* t = get_current_thread();
    LockState*   m = get_lock_state(mutex_addr);

    std::lock_guard<std::recursive_mutex> lm(m->mtx);
    std::lock_guard<std::recursive_mutex> lt(t->mtx);

    if (t->C.size() > m->L.size()) m->L.resize(t->C.size(), 0);
    for (size_t i = 0; i < t->C.size(); i++) m->L[i] = t->C[i];

    t->C[t->tid]++;
    t->epoch = make_epoch(t->tid, t->C[t->tid]);
}

} // extern "C"