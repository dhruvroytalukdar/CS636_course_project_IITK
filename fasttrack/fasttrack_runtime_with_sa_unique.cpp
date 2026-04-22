#include <bits/stdc++.h>
#include <pthread.h>
#include <mutex>
#include <atomic>
#include <time.h>

// ──────────────────────────────────────────────────────────────────
// CONSTANTS AND EPOCH HELPERS
// ──────────────────────────────────────────────────────────────────

// The size of the last lookup table to store variable metadata
#define SHADOW_SIZE  (1 << 20)
#define SHADOW_MASK  (SHADOW_SIZE - 1)

#include <cstring> // Required for strcmp

struct RaceExample {
    bool occurred = false;
    int tid1 = 0;
    int tid2 = 0;
    int line_no = 0;
};

struct VariableRaceSummary {
    RaceExample wr;
    RaceExample ww;
    RaceExample rw;
    char* var_name;
};

// Global lock for the summary map
std::mutex& get_race_summary_lock() {
    static std::mutex mtx;
    return mtx;
}

// Heap-allocated map to survive C++ static destruction sequence
std::unordered_map<void*, VariableRaceSummary>& get_race_summary() {
    static auto* instance = new std::unordered_map<void*, VariableRaceSummary>();
    return *instance;
}
// Encapsulates TID+Clock in a single variable
typedef unsigned long long Epoch;

// Special number to signify READ_SHARED
const Epoch READ_SHARED = (Epoch)-1;
// Last 32 bits represents clock bits
const int   CLOCK_BITS  = 32;
const Epoch CLOCK_MASK  = 0xFFFFFFFF;

static inline Epoch make_epoch(int tid, int clock) {
    return ((Epoch)tid << CLOCK_BITS) | (Epoch)(clock & (int)CLOCK_MASK);
}
static inline int get_tid  (Epoch e) { return (int)(e >> CLOCK_BITS); }
static inline int get_clock(Epoch e) { return (int)(e & CLOCK_MASK); }

// ──────────────────────────────────────────────────────────────────
// SA STATE ENUM
// ──────────────────────────────────────────────────────────────────

enum class ShareState : uint32_t {
    UNACCESSED  = 0,
    OWNED_READ  = 1,
    OWNED_WRITE = 2,
    SHARED      = 3
};

// ──────────────────────────────────────────────────────────────────
// A single word representing both owner tid and shared state
// For fast lookup
//   bits [63:32] = owner_tid  (int32, -1 means no owner)
//   bits [31: 0] = ShareState (uint32)
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
// TABLE ENTRY  (exactly one cache line)
// ──────────────────────────────────────────────────────────────────

struct VarState;

// To take care of false sharing
struct alignas(64) ShadowEntry {
    // Info about owner and shared state
    std::atomic<uint64_t>  hot_word { pack_hot(-1, ShareState::UNACCESSED) };
    // Additional metadata about the variable
    std::atomic<VarState*> state    { nullptr };
    // Acts as a key of the hashtable based on granularity to obtain metadata for a variable address
    std::atomic<uintptr_t> key      { 0 };
};
static_assert(sizeof(ShadowEntry) == 64, "ShadowEntry must be exactly one cache line");

// ──────────────────────────────────────────────────────────────────
// VarState
// ──────────────────────────────────────────────────────────────────

struct VarState {
    std::atomic<Epoch> W  { 0 };
    std::atomic<Epoch> R  { 0 };
    std::vector<Epoch> Rvc;

    std::atomic<Epoch> owner_write_epoch { 0 };
    std::atomic<Epoch> owner_read_epoch  { 0 };

    std::recursive_mutex mtx;
};

// ──────────────────────────────────────────────────────────────────
// ThreadState and LockState
// ──────────────────────────────────────────────────────────────────

struct ThreadState {
    int tid;
    std::vector<int> C;
    Epoch epoch;

    // Made atomic to read these without holding a lock
    std::atomic<int>   self_clock { 0 };
    std::atomic<Epoch> self_epoch { 0 };

    std::recursive_mutex mtx;

    ThreadState(int id) : tid(id) {
        if (tid >= (int)C.size()) C.resize(tid + 1, 0);
        C[tid] = 1;
        epoch  = make_epoch(tid, 1);
        // Because the state is getting created and updates can happen lazily
        self_clock.store(1,     std::memory_order_relaxed);
        self_epoch.store(epoch, std::memory_order_relaxed);
    }

    int get_clock_of(int u) const {
        if (u < 0 || u >= (int)C.size()) return 0;
        return C[u];
    }

    void sync_self_atomics() {
        // Usually called while holding a lock
        self_clock.store(C[tid], std::memory_order_relaxed);
        self_epoch.store(epoch,  std::memory_order_relaxed);
    }
};

struct LockState {
    std::vector<int> L;
    std::recursive_mutex mtx;
};

// ──────────────────────────────────────────────────────────────────
// GLOBAL STATE
// ──────────────────────────────────────────────────────────────────

static std::atomic<int> next_tid   {1};
static std::atomic<int> race_count {0};
static ShadowEntry      shadow_table[SHADOW_SIZE];
static thread_local ThreadState* tl_thread_state = nullptr;
static thread_local bool in_ft_runtime = false;


static std::recursive_mutex& get_thread_map_lock() {
    static auto* m = new std::recursive_mutex(); return *m;
}
static std::map<pthread_t, ThreadState*>& get_threads_map() {
    static auto* m = new std::map<pthread_t, ThreadState*>(); return *m;
}
static std::recursive_mutex& get_lock_registry_lock() {
    static auto* m = new std::recursive_mutex(); return *m;
}
static std::unordered_map<void*, LockState*>& get_shadow_locks() {
    static auto* m = new std::unordered_map<void*, LockState*>(); return *m;
}

// ──────────────────────────────────────────────────────────────────
// INFRASTRUCTURE HELPERS
// ──────────────────────────────────────────────────────────────────

// Sets the v[idx] = val, resizing if needed
static void vec_set_epoch(std::vector<Epoch>& v, int idx, Epoch val) {
    if (idx >= (int)v.size()) v.resize(idx + 1, 0);
    v[idx] = val;
}

// Returns the thread state of the current thread
static ThreadState* get_current_thread() {
    // Return cached state if present
    if (tl_thread_state) return tl_thread_state;
    // Init threadstate if not cached
    pthread_t self = pthread_self();
    std::lock_guard<std::recursive_mutex> lk(get_thread_map_lock());
    auto& threads = get_threads_map();
    if (!threads.count(self))
        threads[self] = new ThreadState(next_tid++);
    tl_thread_state = threads[self];
    return tl_thread_state;
}

// Given a memory address return the var metadata
static ShadowEntry* get_shadow_entry(void* addr) {
    // Generate key, 4 byte granularity to save memory
    uintptr_t key  = ((uintptr_t)addr >> 2) + 1;
    // To avoid primary clustering in hashing (Knuths Multiplicative Hash)
    size_t    slot = (key * 2654435761ULL) & SHADOW_MASK;
    // Do linear probing if collisons happen
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

static VarState* get_or_alloc_var_state(ShadowEntry* e) {
    // acquire semantics to make sure the previous release event is complete and we know about it
    VarState* s = e->state.load(std::memory_order_acquire);
    if (s) return s;
    VarState* ns = new VarState();
    VarState* expected = nullptr;
    // Compare the value of e->state with expected
    // If the value is same then update it with ns -> True -> return ns
    //    acquire the data read and then release semantics to publish values to memory
    // If not same then read that value in expected -> False -> delete ns -> return prev value(expected)
    //    acquire semantics to sync with previous value
    // cmp_xchange_strong to ensure there is no spurious failures
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
void report_race(const char* type, void* addr, int tid1, int tid2, int line_no, char* var_name) {
    race_count.fetch_add(1, std::memory_order_relaxed);
    
    std::lock_guard<std::mutex> lock(get_race_summary_lock());
    auto& summary = get_race_summary()[addr];
    if(var_name != nullptr)summary.var_name = var_name;
    // Record the first instance of each race type for this specific address
    if (strcmp(type, "W-R") == 0 && !summary.wr.occurred) {
        summary.wr = {true, tid1, tid2, line_no};
    } else if (strcmp(type, "W-W") == 0 && !summary.ww.occurred) {
        summary.ww = {true, tid1, tid2, line_no};
    } else if (strcmp(type, "R-W") == 0 && !summary.rw.occurred) {
        summary.rw = {true, tid1, tid2, line_no};
    }
}
__attribute__((destructor))
void print_final_race_summary() {
    std::lock_guard<std::mutex> lock(get_race_summary_lock());
    auto& summary_map = get_race_summary();

    if (summary_map.empty()) return;

    printf("\n================ RACE SUMMARY BY VARIABLE ================\n");
    for (const auto& pair : summary_map) {
        void* addr = pair.first;
        const auto& summary = pair.second;

        printf("Variable ADDR: %p\n", addr);
        printf("Variable Name: %s\n", summary.var_name);

        if (summary.ww.occurred) {
            printf("  [W-W] Example: Thread %d and Thread %d at line %d\n",
                   summary.ww.tid1, summary.ww.tid2, summary.ww.line_no);
        }
        if (summary.rw.occurred) {
            printf("  [R-W] Example: Thread %d and Thread %d at line %d\n",
                   summary.rw.tid1, summary.rw.tid2, summary.rw.line_no);
        }
        if (summary.wr.occurred) {
            printf("  [W-R] Example: Thread %d and Thread %d at line %d\n",
                   summary.wr.tid1, summary.wr.tid2, summary.wr.line_no);
        }
        printf("----------------------------------------------------------\n");
    }
    printf("==========================================================\n");
}
// static void report_race(const char* type, void* addr, int tid1, int tid2, int line_no) {
//     race_count.fetch_add(1, std::memory_order_relaxed);
//     struct timespec ts;
//     clock_gettime(CLOCK_MONOTONIC, &ts);
//     uint64_t ns = (uint64_t)ts.tv_sec * 1000000000ULL + (uint64_t)ts.tv_nsec;
//     printf("[FASTTRACK LOG] | TYPE: %s | ADDR: %p | THREADS: %d-%d | LINE: %d | TS_NS: %llu\n",
//            type, addr, tid1, tid2, line_no, (unsigned long long)ns);
// }

// ──────────────────────────────────────────────────────────────────
// RECLAIM CHECK
// ──────────────────────────────────────────────────────────────────
// Called when we are holding a lock on t and x -> we can use memory order relax to load atomic vars
// from x and t
static bool can_reclaim(ThreadState* t, VarState* x) {
    Epoch W = x->W.load(std::memory_order_relaxed);
    if (W != 0) {
        int w_tid   = get_tid(W);
        int w_clock = get_clock(W);
        // current thread was not the previous writer and current thread has state knowledge
        // about previous writer -> Cannot reclaim
        if (w_tid != t->tid && w_clock > t->get_clock_of(w_tid))
            return false;
    }
    // The current thread has knowledge about every threads who read from x
    Epoch R = x->R.load(std::memory_order_relaxed);
    if (R == READ_SHARED) {
        for (int i = 0; i < (int)x->Rvc.size(); ++i) {
            if (x->Rvc[i] == 0) continue;
            if (i != t->tid &&
                t->get_clock_of(i) < get_clock(x->Rvc[i]))
                return false;
        }
    } else if (R != 0) {
        int r_tid   = get_tid(R);
        int r_clock = get_clock(R);
        if (r_tid != t->tid && t->get_clock_of(r_tid) < r_clock)
            return false;
    }
    return true;
}

// ──────────────────────────────────────────────────────────────────
// FT CORE
// ──────────────────────────────────────────────────────────────────
// Called holding a lock over x and t so we can use relaxed mode
static bool ft_read_core(void* addr, int line_no, VarState* x, ThreadState* t, char* var_name) {
    Epoch R = x->R.load(std::memory_order_relaxed);
    if (R == t->epoch) return false;

    Epoch W       = x->W.load(std::memory_order_relaxed);
    int   w_tid   = get_tid(W);
    int   w_clock = get_clock(W);
    bool raced = false;
    if (w_clock > t->get_clock_of(w_tid)) {
        report_race("W-R", addr, w_tid, t->tid, line_no, var_name);
        // Remove the previous write history
        x->W.store(0,        std::memory_order_relaxed);
        raced = true;
    }

    // Standared fasttrack rules
    if (R == READ_SHARED) {
        vec_set_epoch(x->Rvc, t->tid, t->epoch);
    } else {
        int r_tid   = get_tid(R);
        int r_clock = get_clock(R);
        if (r_clock <= t->get_clock_of(r_tid)) {
            x->R.store(t->epoch, std::memory_order_relaxed);
        } else {
            Epoch old_R = R;
            x->Rvc.clear();
            vec_set_epoch(x->Rvc, r_tid,  old_R);
            vec_set_epoch(x->Rvc, t->tid, t->epoch);
            x->R.store(READ_SHARED, std::memory_order_relaxed);
        }
    }
    return raced;
}

static bool ft_write_core(void* addr, int line_no, VarState* x, ThreadState* t, char* var_name) {
    Epoch W = x->W.load(std::memory_order_relaxed);
    if (W == t->epoch) return false;

    bool raced   = false;
    int  w_tid   = get_tid(W);
    int  w_clock = get_clock(W);
    if (w_clock > t->get_clock_of(w_tid)) {
        report_race("W-W", addr, w_tid, t->tid, line_no, var_name);
        raced = true;
    }

    Epoch R = x->R.load(std::memory_order_relaxed);
    if (R != READ_SHARED) {
        if (R != 0) {
            int r_tid   = get_tid(R);
            int r_clock = get_clock(R);
            if (r_clock > t->get_clock_of(r_tid)) {
                report_race("R-W", addr, r_tid, t->tid, line_no, var_name);
                raced = true;
            }
        }
    } else {
        for (int i = 0; i < (int)x->Rvc.size(); ++i) {
            if (x->Rvc[i] == 0) continue;
            if (get_clock(x->Rvc[i]) > t->get_clock_of(i)) {
                report_race("R-W", addr, i, t->tid, line_no, var_name);
                raced = true;
            }
        }
    }

    // Overwrite the previous information
    x->W.store(t->epoch, std::memory_order_relaxed);
    x->R.store(0,        std::memory_order_relaxed);
    x->Rvc.clear();
    return raced;
}

// ──────────────────────────────────────────────────────────────────
// SLOW PATH
//
// Acquires var_lk + thr_lk, re-reads hot_word, and handles all
// non-fast-path cases.  Separated into a helper so the fast path
// in __ft_read / __ft_write can fall through cleanly after a CAS
// failure without duplicating the entire switch.
// ──────────────────────────────────────────────────────────────────

static void ft_slow_read(void* addr, int line_no, ShadowEntry* e, ThreadState* t, char* var_name) {
    VarState* x = get_or_alloc_var_state(e);
    std::lock_guard<std::recursive_mutex> var_lk(x->mtx);
    std::lock_guard<std::recursive_mutex> thr_lk(t->mtx);

    uint64_t   hw    = e->hot_word.load(std::memory_order_acquire);
    ShareState ss    = hot_state(hw);
    int        owner = hot_owner(hw);

    switch (ss) {
        case ShareState::UNACCESSED:
            x->owner_write_epoch.store(0,        std::memory_order_relaxed);
            x->owner_read_epoch.store(t->epoch,  std::memory_order_relaxed);
            x->W.store(0,        std::memory_order_relaxed);
            x->R.store(t->epoch, std::memory_order_relaxed);
            e->hot_word.store(pack_hot(t->tid, ShareState::OWNED_READ),
                              std::memory_order_release);
            return;

        case ShareState::OWNED_READ:
        case ShareState::OWNED_WRITE:
            if (owner == t->tid) {
                // We own it — update read epoch and re-publish.
                x->owner_read_epoch.store(t->epoch, std::memory_order_relaxed);
                x->R.store(t->epoch, std::memory_order_relaxed);
                e->hot_word.store(pack_hot(t->tid, ss),
                                  std::memory_order_release);
                return;
            }
            
            if (ss == ShareState::OWNED_WRITE) {
                x->W.store(x->owner_write_epoch.load(std::memory_order_acquire),
                           std::memory_order_relaxed);
                x->R.store(0, std::memory_order_relaxed);
            } else {
                x->W.store(x->owner_write_epoch.load(std::memory_order_acquire),
                           std::memory_order_relaxed);
                x->R.store(x->owner_read_epoch.load(std::memory_order_acquire),
                           std::memory_order_relaxed);
            }
            x->Rvc.clear();
            e->hot_word.store(pack_hot(t->tid, ShareState::SHARED),
                              std::memory_order_release);
            {
                bool raced = ft_read_core(addr, line_no, x, t, var_name);
                if (!raced && can_reclaim(t, x)) {
                    x->owner_write_epoch.store(
                        x->W.load(std::memory_order_relaxed),
                        std::memory_order_relaxed);
                    x->owner_read_epoch.store(t->epoch, std::memory_order_relaxed);
                    x->Rvc.clear();
                    e->hot_word.store(pack_hot(t->tid, ShareState::OWNED_READ),
                                        std::memory_order_release);
                }
            }
            return;

        case ShareState::SHARED: {
            bool raced = ft_read_core(addr, line_no, x, t, var_name);
            if (!raced && can_reclaim(t, x)) {
                x->owner_write_epoch.store(
                    x->W.load(std::memory_order_relaxed),
                    std::memory_order_relaxed);
                x->owner_read_epoch.store(t->epoch, std::memory_order_relaxed);
                x->Rvc.clear();
                e->hot_word.store(pack_hot(t->tid, ShareState::OWNED_READ),
                                  std::memory_order_release);
            }
            return;
        }
    }
}

static void ft_slow_write(void* addr, int line_no, ShadowEntry* e, ThreadState* t, char* var_name) {
    VarState* x = get_or_alloc_var_state(e);
    std::lock_guard<std::recursive_mutex> var_lk(x->mtx);
    std::lock_guard<std::recursive_mutex> thr_lk(t->mtx);

    uint64_t   hw    = e->hot_word.load(std::memory_order_acquire);
    ShareState ss    = hot_state(hw);
    int        owner = hot_owner(hw);

    switch (ss) {
        case ShareState::UNACCESSED:
            x->owner_write_epoch.store(t->epoch, std::memory_order_relaxed);
            x->owner_read_epoch.store(0,         std::memory_order_relaxed);
            x->W.store(t->epoch, std::memory_order_relaxed);
            x->R.store(0,        std::memory_order_relaxed);
            e->hot_word.store(pack_hot(t->tid, ShareState::OWNED_WRITE),
                              std::memory_order_release);
            return;

        case ShareState::OWNED_READ:
        case ShareState::OWNED_WRITE:
            if (owner == t->tid) {
                x->owner_write_epoch.store(t->epoch, std::memory_order_relaxed);
                x->W.store(t->epoch, std::memory_order_relaxed);
                x->R.store(0,        std::memory_order_relaxed);
                e->hot_word.store(pack_hot(t->tid, ShareState::OWNED_WRITE),
                                  std::memory_order_release);
                return;
            }
            x->W.store(x->owner_write_epoch.load(std::memory_order_acquire),
                       std::memory_order_relaxed);
            x->R.store(x->owner_read_epoch.load(std::memory_order_acquire),
                       std::memory_order_relaxed);
            x->Rvc.clear();
            e->hot_word.store(pack_hot(t->tid, ShareState::SHARED),
                              std::memory_order_release);
            {
                bool raced = ft_write_core(addr, line_no, x, t, var_name);
                if (!raced && can_reclaim(t, x)) {
                    x->owner_write_epoch.store(t->epoch, std::memory_order_relaxed);
                    x->owner_read_epoch.store(0,         std::memory_order_relaxed);
                    x->R.store(0, std::memory_order_relaxed);
                    x->Rvc.clear();
                    e->hot_word.store(pack_hot(t->tid, ShareState::OWNED_WRITE),
                                        std::memory_order_release);
                }
            }
            return;

        case ShareState::SHARED: {
            bool raced = ft_write_core(addr, line_no, x, t, var_name);
            if (!raced && can_reclaim(t, x)) {
                x->owner_write_epoch.store(t->epoch, std::memory_order_relaxed);
                x->owner_read_epoch.store(0,         std::memory_order_relaxed);
                x->R.store(0, std::memory_order_relaxed);
                x->Rvc.clear();
                e->hot_word.store(pack_hot(t->tid, ShareState::OWNED_WRITE),
                                  std::memory_order_release);
            }
            return;
        }
    }
}

// ──────────────────────────────────────────────────────────────────
// PUBLIC MEMORY ACCESS CALLBACKS
// ──────────────────────────────────────────────────────────────────

extern "C" {

// ── __ft_read ───────────────────────────────────────────────────
//
// FAST PATH (owner read):
//   1. Load hot_word with acquire.
//   2. If OWNED by us: store owner_read_epoch (relaxed).
//   3. CAS hot_word: expected = loaded hw, desired = same value.
//      • success → the relaxed store in step 2 is now sequenced-before
//        the CAS release, so any future acquirer of hot_word sees the
//        updated owner_read_epoch.  Return.
//      • failure → another thread changed hot_word (stole ownership).
//        Fall through to slow path to re-examine under var_lk.

void __ft_read(void* addr, int line_no, char* var_name) {
    if (in_ft_runtime) return;
    struct Guard { ~Guard(){ in_ft_runtime=false; } } g;
    in_ft_runtime = true;
    
    ThreadState* t = get_current_thread();
    ShadowEntry* e = get_shadow_entry(addr);

    // Make sure to load hot_word with acquire semantics to synchronize with the previous release store.
    uint64_t   hw    = e->hot_word.load(std::memory_order_acquire);
    ShareState ss    = hot_state(hw);
    int        owner = hot_owner(hw);

    if ((ss == ShareState::OWNED_READ || ss == ShareState::OWNED_WRITE)
        && owner == t->tid) {
        
        VarState* x = e->state.load(std::memory_order_acquire);
        // update x and read t using relaxed mode
        // because current thread is the exclusive owner.
        if (x) {
            x->owner_read_epoch.store(
                t->self_epoch.load(std::memory_order_relaxed),
                std::memory_order_relaxed);
        }


        uint64_t desired = hw;
        // try to update the hotword back with CAS
        // because after loading at the start of the function another thread might claim ownership
        // If hw is equal to e->hot_word -> update with desired with release semantics -> return true
        // else update hw with the value stored in e->hot_word with relaxed semantics -> return false
        if (e->hot_word.compare_exchange_strong(hw, desired,
                std::memory_order_release,
                std::memory_order_relaxed)) {
            return;
        }
    }

    ft_slow_read(addr, line_no, e, t, var_name);
}

// ── __ft_write ──────────────────────────────────────────────────
//
// FAST PATH (owner write):
//   1. Load hot_word with acquire.
//   2. If OWNED by us: store owner_write_epoch (relaxed).
//   3. CAS hot_word: expected = loaded hw,
//                   desired  = OWNED_WRITE/us (upgrade if needed).
//      • success → Return.
//      • failure → fall to slow path.

void __ft_write(void* addr, int line_no, char* var_name) {
    if (in_ft_runtime) return;
    struct Guard { ~Guard(){ in_ft_runtime=false; } } g;
    in_ft_runtime = true;
    
    ThreadState* t = get_current_thread();
    ShadowEntry* e = get_shadow_entry(addr);

    uint64_t   hw    = e->hot_word.load(std::memory_order_acquire);
    ShareState ss    = hot_state(hw);
    int        owner = hot_owner(hw);

    if ((ss == ShareState::OWNED_READ || ss == ShareState::OWNED_WRITE)
        && owner == t->tid) {

        VarState* x = e->state.load(std::memory_order_acquire);
        if (x) {
            x->owner_write_epoch.store(
                t->self_epoch.load(std::memory_order_relaxed),
                std::memory_order_relaxed);
        }

        uint64_t desired = pack_hot(t->tid, ShareState::OWNED_WRITE);
        if (e->hot_word.compare_exchange_weak(hw, desired,
                std::memory_order_release,
                std::memory_order_relaxed)) {
            return;   // ← HOT PRIVATE WRITE PATH — common case
        }
    }

    ft_slow_write(addr, line_no, e, t, var_name);
}

// ──────────────────────────────────────────────────────────────────
// THREAD LIFECYCLE CALLBACKS
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
    parent->sync_self_atomics();
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
        child->sync_self_atomics();
    }
    void* result = ctx->original_routine(ctx->original_arg);
    delete ctx;
    tl_thread_state = nullptr;
    return result;
}

void __ft_thread_create(uint64_t /*child_id_raw*/) {
    // ThreadState* parent = get_current_thread();
    // std::lock_guard<std::recursive_mutex> lk(parent->mtx);
    // parent->C[parent->tid]++;
    // parent->epoch = make_epoch(parent->tid, parent->C[parent->tid]);
    // parent->sync_self_atomics();
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
        parent->sync_self_atomics();
    }
    {
        std::lock_guard<std::recursive_mutex> lk(get_thread_map_lock());
        get_threads_map().erase(it);
    }
    delete child;
}

// ──────────────────────────────────────────────────────────────────
// LOCK CALLBACKS
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
    t->sync_self_atomics();
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
    t->sync_self_atomics();
}

} // extern "C"
