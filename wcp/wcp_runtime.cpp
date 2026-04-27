// =============================================================================
// Runtime library for the WCP (Weak-Causally-Precedes) race detector.
// =============================================================================
//
//   State per thread t:
//     N_t   — local integer clock (starts at 1, incremented after each release)
//     H_t   — vector clock: HB time of last event in t
//     P_t   — vector clock: WCP-predecessor time of last event in t
//     C_t   = P_t[t := N_t]
//
//   State per lock ℓ:
//     H_ℓ        — HB time of last rel(ℓ) seen
//     P_ℓ        — WCP-predecessor time of last rel(ℓ) seen
//     Acq_ℓ(t)  — FIFO of C_t snapshots from acq(ℓ) events by threads t'≠t
//     Rel_ℓ(t)  — FIFO of H_t snapshots from rel(ℓ) events by threads t'≠t
//
//   State per (lock ℓ, variable x):
//     Lr[ℓ][x]  — join of H_t of all rel(ℓ) whose CS contained r(x)
//     Lw[ℓ][x]  — join of H_t of all rel(ℓ) whose CS contained w(x)
//
//   State per variable x:
//     Rx, Wx  — join of C_e for reads/writes (for WCP-race checking)
//
//   procedure acquire(t, ℓ)
//     1: H_t := H_t ⊔ H_ℓ
//     2: P_t := P_t ⊔ P_ℓ
//     3: ∀ t'≠t: Acq_ℓ(t').Enqueue(C_t)
//
//   procedure release(t, ℓ, R, W)
//     4-6: while Acq_ℓ(t).front() ⊑ C_t:
//              Acq_ℓ(t).Dequeue()
//              P_t := P_t ⊔ Rel_ℓ(t).Dequeue()
//     7:   ∀ x∈R: Lr[ℓ][x] := Lr[ℓ][x] ⊔ H_t
//     8:   ∀ x∈W: Lw[ℓ][x] := Lw[ℓ][x] ⊔ H_t
//     9:   H_ℓ := H_t;  P_ℓ := P_t
//    10:   ∀ t'≠t: Rel_ℓ(t').Enqueue(H_t)
//          N_t++  (local clock bump after every release)
//
//   procedure read(t, x, L)
//    11: P_t := P_t ⊔ (⊔_{ℓ∈L} Lw[ℓ][x])
//        Race: ¬(Wx ⊑ C_t)  → W-R
//        Rx := Rx ⊔ C_t
//
//   procedure write(t, x, L)
//    12: P_t := P_t ⊔ (⊔_{ℓ∈L} (Lr[ℓ][x] ⊔ Lw[ℓ][x]))
//        Race: ¬(Rx ⊑ C_t)  → R-W
//              ¬(Wx ⊑ C_t)  → W-W
//        Wx := Wx ⊔ C_t
//
// ── FORK / JOIN ──────────────────────────────────────────────────────────────
//   fork:  parent N_t++, snapshot (H_t, P_t) → child initialises from snapshot
//   join:  H_parent ⊔= H_child;  P_parent ⊔= P_child
//
// =============================================================================

#include <bits/stdc++.h>
#include <pthread.h>
#include <mutex>
#include <atomic>
#include <cstdio>
#include <ctime>

// #define DEBUG
// #define DEBUG

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
// Heap-allocated mutex to survive C++ static destruction sequence
std::mutex& get_race_summary_lock() {
    static auto* mtx = new std::mutex();
    return *mtx;
}
// Global lock for the summary map


// Heap-allocated map to survive C++ static destruction sequence
std::unordered_map<void*, VariableRaceSummary>& get_race_summary() {
    static auto* instance = new std::unordered_map<void*, VariableRaceSummary>();
    return *instance;
}
// =============================================================================
// 1.  VECTOR-CLOCK TYPE AND HELPERS
// =============================================================================

using VClock = std::vector<int>;

static void vc_join(VClock &dst, const VClock &src) {
    if (src.size() > dst.size())
        dst.resize(src.size(), 0);
    for (size_t i = 0; i < src.size(); i++)
        if (src[i] > dst[i]) dst[i] = src[i];
}

// Is src ⊑ dst  (point-wise ≤)
static bool vc_leq(const VClock &src, const VClock &dst) {
    for (size_t i = 0; i < src.size(); i++) {
        int d = (i < dst.size()) ? dst[i] : 0;
        if (src[i] > d) return false;
    }
    return true;
}

static void vc_ensure(VClock &v, int idx) {
    if ((size_t)idx >= v.size()) v.resize(idx + 1, 0);
}

// C_t = P_t with the component for tid overridden by N
static VClock make_Ct(const VClock &P, int tid, int N) {
    VClock C = P;
    vc_ensure(C, tid);
    C[tid] = N;
    return C;
}

// Return the first index where src[i] > dst[i] (for race reporting).
static int first_violating_tid(const VClock &src, const VClock &dst) {
    for (size_t i = 0; i < src.size(); i++) {
        int d = (i < dst.size()) ? dst[i] : 0;
        if (src[i] > d) return (int)i;
    }
    return -1;
}

// =============================================================================
// 2.  CRITICAL-SECTION FRAMES
//     Tracks variable addresses accessed inside each lock's CS so that
//     Lr / Lw can be updated at release time.
// =============================================================================

struct CSFrame {
    void *lock_addr;
    std::unordered_set<uintptr_t> reads; // reads inside the critical section
    std::unordered_set<uintptr_t> writes;  // writes inside the critical section
};

static std::recursive_mutex                          g_csframe_mtx;
static std::unordered_map<int, std::vector<CSFrame>> g_csframes;

// Push a new frame when a lock is acquired.
static void csframe_push(int tid, void *lock_addr) {
    std::lock_guard<std::recursive_mutex> lk(g_csframe_mtx);
    g_csframes[tid].push_back({lock_addr, {}, {}});
}

// Pop the innermost frame for lock_addr; fill out_R / out_W with its sets.
static bool csframe_pop(int tid, void *lock_addr,
                        std::unordered_set<uintptr_t> &out_R,
                        std::unordered_set<uintptr_t> &out_W) {
    std::lock_guard<std::recursive_mutex> lk(g_csframe_mtx);
    auto it = g_csframes.find(tid);
    if (it == g_csframes.end()) return false;
    auto &stack = it->second;
    for (int i = (int)stack.size() - 1; i >= 0; --i) {
        if (stack[i].lock_addr == lock_addr) {
            out_R = std::move(stack[i].reads);
            out_W = std::move(stack[i].writes);
            stack.erase(stack.begin() + i);
            return true;
        }
    }
    return false;
}

// Record a read inside every currently-open CS frame for this thread.
static void csframe_record_read(int tid, uintptr_t addr) {
    std::lock_guard<std::recursive_mutex> lk(g_csframe_mtx);
    auto it = g_csframes.find(tid);
    if (it == g_csframes.end()) return;
    for (auto &frame : it->second)
        frame.reads.insert(addr);
}

// Record a write inside every currently-open CS frame for this thread.
static void csframe_record_write(int tid, uintptr_t addr) {
    std::lock_guard<std::recursive_mutex> lk(g_csframe_mtx);
    auto it = g_csframes.find(tid);
    if (it == g_csframes.end()) return;
    for (auto &frame : it->second)
        frame.writes.insert(addr);
}

// Return the lock addresses of all currently held locks for this thread.
// This is the set L passed to the read / write procedures
static std::vector<void*> get_held_locks(int tid) {
    std::lock_guard<std::recursive_mutex> lk(g_csframe_mtx);
    std::vector<void*> held;
    auto it = g_csframes.find(tid);
    if (it == g_csframes.end()) return held;
    for (auto &frame : it->second)
        held.push_back(frame.lock_addr);
    return held;
}

// =============================================================================
// 3.  STATE STRUCTURES
// =============================================================================


struct ThreadState {
    int    tid;
    int    N;
    VClock H;
    VClock P;

    mutable std::recursive_mutex mtx;

    explicit ThreadState(int id) : tid(id), N(1) {
        vc_ensure(H, id);
        H[id] = 1;
    }

    VClock Ct() const { return make_Ct(P, tid, N); }
};

// ── Per-lock ──────────────────────────────────────────────────────────────────
struct LockState {
    VClock H_lock;
    VClock P_lock;

    // FIFO queues indexed by the destination thread.
    // Acq_ℓ(t): C_t snapshots from acq events by threads t'≠t
    // Rel_ℓ(t): H_t snapshots from rel events by threads t'≠t
    std::unordered_map<int, std::deque<VClock>> Acq;
    std::unordered_map<int, std::deque<VClock>> Rel;

    // Lr[x] and Lw[x] for this lock
    std::unordered_map<uintptr_t, VClock> Lr;
    std::unordered_map<uintptr_t, VClock> Lw;

    mutable std::recursive_mutex mtx;
};

// ── Per-variable ──────────────────────────────────────────────────────────────
struct VarState {
    VClock Wx;
    VClock Rx;
    mutable std::recursive_mutex mtx;
};


static std::atomic<unsigned long long> slow_read_count{0};
static std::atomic<unsigned long long> slow_write_count{0};

// ── Thread context: passed parent → child through pthread_create ──────────────
struct ThreadContext {
    void *(*original_routine)(void *);
    void  *original_arg;
    VClock parent_H;
    VClock parent_P;
};

// =============================================================================
// 4.  GLOBAL STATE
// =============================================================================

static std::atomic<int> next_tid{1};
static std::atomic<int> race_count{0};

static std::recursive_mutex              g_thread_map_mtx;
static std::map<pthread_t, ThreadState*> g_thread_map;

static std::recursive_mutex                  g_lock_map_mtx;
static std::unordered_map<void*, LockState*> g_lock_map;

static std::recursive_mutex                 g_var_map_mtx;
static std::unordered_map<void*, VarState*> g_var_map;

static thread_local ThreadState *tl_thread_state = nullptr;

// =============================================================================
// 5.  REGISTRY HELPERS
// =============================================================================

static ThreadState *get_current_thread() {
    if (tl_thread_state) return tl_thread_state;
    pthread_t self = pthread_self();
    std::lock_guard<std::recursive_mutex> lk(g_thread_map_mtx);
    auto it = g_thread_map.find(self);
    if (it == g_thread_map.end()) {
        int id   = next_tid.fetch_add(1, std::memory_order_relaxed);
        auto *ts = new ThreadState(id);
        g_thread_map[self] = ts;
        tl_thread_state    = ts;
    } else {
        tl_thread_state = it->second;
    }
    return tl_thread_state;
}

static LockState *get_lock_state(void *addr) {
    std::lock_guard<std::recursive_mutex> lk(g_lock_map_mtx);
    auto &p = g_lock_map[addr];
    if (!p) p = new LockState();
    return p;
}

static VarState *get_var_state(void *addr) {
    std::lock_guard<std::recursive_mutex> lk(g_var_map_mtx);
    auto &p = g_var_map[addr];
    if (!p) p = new VarState();
    return p;
}


static std::vector<int> other_tids(int exclude_tid) {
    std::vector<int> result;
    std::lock_guard<std::recursive_mutex> lk(g_thread_map_mtx);
    for (auto &kv : g_thread_map)
        if (kv.second->tid != exclude_tid)
            result.push_back(kv.second->tid);
    return result;
}

// =============================================================================
// 6.  RACE REPORTING
// =============================================================================

static void report_race(const char *type, void *addr,
                        int tid1, int tid2, int line_no, char* var_name) {
    race_count.fetch_add(1, std::memory_order_relaxed);
                            
    #ifndef DEBUG
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

        // count unique races
    #else
        struct timespec ts;
        clock_gettime(CLOCK_MONOTONIC, &ts);
        uint64_t ns = (uint64_t)ts.tv_sec * 1000000000ULL + (uint64_t)ts.tv_nsec;
        printf("[WCP LOG] | TYPE: %s | ADDR: %p | THREADS: %d-%d "
            "| LINE: %d | TS_NS: %llu\n",
            type, addr, tid1, tid2, line_no,
            (unsigned long long)ns);
    #endif
}

__attribute__((destructor))
void print_final_race_summary() {
    printf("\n================ PERFORMANCE METRICS =====================\n");
    printf("  Total FT Read calls : %llu\n", slow_read_count.load());
    printf("  Total FT Write calls: %llu\n", slow_write_count.load());

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

// =============================================================================
// 7.  Acquire
// =============================================================================
//
//  1: H_t := H_t ⊔ H_ℓ
//  2: P_t := P_t ⊔ P_ℓ
//  3: ∀ t'≠t: Acq_ℓ(t').Enqueue(C_t)

static void do_acquire(ThreadState *t, LockState *ls) {
    std::lock_guard<std::recursive_mutex> lk_t(t->mtx);
    std::lock_guard<std::recursive_mutex> lk_l(ls->mtx);

    vc_join(t->H, ls->H_lock);
    vc_join(t->P, ls->P_lock);

    VClock Ct = t->Ct();
    for (int tp : other_tids(t->tid))
        ls->Acq[tp].push_back(Ct);
}

// =============================================================================
// 8.  Release
// =============================================================================
//
//  1: while Acq_ℓ(t).front() ⊑ C_t:
//           Acq_ℓ(t).Dequeue()
//           P_t := P_t ⊔ Rel_ℓ(t).Dequeue()
//  2:   ∀ x∈R: Lr[ℓ][x] ⊔= H_t
//  3:   ∀ x∈W: Lw[ℓ][x] ⊔= H_t
//  4:   H_ℓ := H_t;  P_ℓ := P_t
//  5:   ∀ t'≠t: Rel_ℓ(t').Enqueue(H_t)

static void do_release(ThreadState *t, LockState *ls, void *lock_addr) {
    // Harvest CS variable sets BEFORE acquiring the main locks to avoid
    // lock-ordering issues with g_csframe_mtx.
    std::unordered_set<uintptr_t> cs_R, cs_W;
    csframe_pop(t->tid, lock_addr, cs_R, cs_W);

    std::lock_guard<std::recursive_mutex> lk_t(t->mtx);
    std::lock_guard<std::recursive_mutex> lk_l(ls->mtx);

    VClock Ct = t->Ct();

    auto &acq_q = ls->Acq[t->tid];
    auto &rel_q = ls->Rel[t->tid];
    while (!acq_q.empty() && !rel_q.empty() &&
           vc_leq(acq_q.front(), Ct)) {
        acq_q.pop_front();
        vc_join(t->P, rel_q.front());  // line 6
        rel_q.pop_front();
    }

    for (uintptr_t xaddr : cs_R)
        vc_join(ls->Lr[xaddr], t->H);

    for (uintptr_t xaddr : cs_W)
        vc_join(ls->Lw[xaddr], t->H);

    ls->H_lock = t->H;
    ls->P_lock = t->P;

    for (int tp : other_tids(t->tid))
        ls->Rel[tp].push_back(t->H);

    t->N++;
    vc_ensure(t->H, t->tid);
    t->H[t->tid] = t->N;
}

// =============================================================================
// 9.  EXPORTED RUNTIME FUNCTIONS
// =============================================================================

extern "C" {

void *__wcp_prepare_context(void *routine, void *arg) {
    auto *ctx             = new ThreadContext();
    ctx->original_routine = reinterpret_cast<void*(*)(void*)>(routine);
    ctx->original_arg     = arg;

    ThreadState *parent = get_current_thread();
    {
        std::lock_guard<std::recursive_mutex> lk(parent->mtx);

        // Fork event: advance parent's local clock.
        parent->N++;
        vc_ensure(parent->H, parent->tid);
        parent->H[parent->tid] = parent->N;

        ctx->parent_H = parent->H;
        ctx->parent_P = parent->P;
    }
    return ctx;
}

void *thread_wrapper(void *raw_arg) {
    auto *ctx = reinterpret_cast<ThreadContext*>(raw_arg);

    int    id    = next_tid.fetch_add(1, std::memory_order_relaxed);
    auto  *child = new ThreadState(id);

    // Fork edge: child inherits parent's HB and WCP-pred clocks.
    {
        std::lock_guard<std::recursive_mutex> lk(child->mtx);
        child->H = ctx->parent_H;
        child->P = ctx->parent_P;
        child->N = 1;
        // Stamp the child's own component: H_child[child_tid] = N_child = 1.
        vc_ensure(child->H, child->tid);
        child->H[child->tid] = child->N;
    }

    {
        std::lock_guard<std::recursive_mutex> lk(g_thread_map_mtx);
        g_thread_map[pthread_self()] = child;
    }
    tl_thread_state = child;

    void *(*fn)(void*) = ctx->original_routine;
    void  *fn_arg      = ctx->original_arg;
    delete ctx;

    return fn(fn_arg);
}

void __wcp_thread_create(uint64_t /*child_id_raw*/) {
    // No-op: parent clock already incremented in __wcp_prepare_context.
}

void __wcp_thread_join(uint64_t child_raw_id) {
    ThreadState *parent = get_current_thread();
    ThreadState *child  = nullptr;

    std::map<pthread_t, ThreadState*>::iterator it;
    {
        std::lock_guard<std::recursive_mutex> lk(g_thread_map_mtx);
        it = g_thread_map.find((pthread_t)child_raw_id);
        if (it != g_thread_map.end())
            child = it->second;
    }

    if (!child) {
        fprintf(stderr, "[WCP] WARNING: joined thread %lu not in registry\n",
                (unsigned long)child_raw_id);
        return;
    }

    {
        std::lock_guard<std::recursive_mutex> lk_p(parent->mtx);
        std::lock_guard<std::recursive_mutex> lk_c(child->mtx);

        // Merge child's clocks into parent (join edge).
        vc_join(parent->H, child->H);
        vc_join(parent->P, child->P);

        // Keep H_parent[parent_tid] = N_parent.
        vc_ensure(parent->H, parent->tid);
        parent->H[parent->tid] = parent->N;
    }

    {
        std::lock_guard<std::recursive_mutex> lk(g_thread_map_mtx);
        g_thread_map.erase(it);
    }
    delete child;
}

void __wcp_lock(void *mutex_addr) {
    ThreadState *t  = get_current_thread();
    LockState   *ls = get_lock_state(mutex_addr);

    do_acquire(t, ls);

    // Open a CS frame to begin tracking variable accesses inside this CS.
    csframe_push(t->tid, mutex_addr);
}

void __wcp_unlock(void *mutex_addr) {
    ThreadState *t  = get_current_thread();
    LockState   *ls = get_lock_state(mutex_addr);

    do_release(t, ls, mutex_addr);
}

// ── __wcp_read ────────────────────────────────────────────────────────────────
//
//   P_t := P_t ⊔ (⊔_{ℓ∈L} Lw[ℓ][x])
//   if ¬(Wx ⊑ C_t) → W-R race
//   Rx := Rx ⊔ C_t
void __wcp_read(void *addr, int line_no, char* var) {
    slow_read_count.fetch_add(1, std::memory_order_relaxed);

    ThreadState *t  = get_current_thread();
    VarState    *vs = get_var_state(addr);
    uintptr_t xaddr = (uintptr_t)addr;

    // Record in all enclosing CS frames (to populate Lr at release, line 7).
    csframe_record_read(t->tid, xaddr);

    // L = set of locks currently held by t.
    std::vector<void*> held = get_held_locks(t->tid);

    std::lock_guard<std::recursive_mutex> lk_t(t->mtx);
    std::lock_guard<std::recursive_mutex> lk_v(vs->mtx);

    // Line 11: P_t := P_t ⊔ (⊔_{ℓ∈L} Lw[ℓ][x])
    for (void *la : held) {
        LockState *ls = get_lock_state(la);
        std::lock_guard<std::recursive_mutex> lk_l(ls->mtx);
        auto it = ls->Lw.find(xaddr);
        if (it != ls->Lw.end())
            vc_join(t->P, it->second);
    }

    VClock Ct = t->Ct();

    // Race check: ¬(Wx ⊑ C_t)  →  W-R WCP-race
    if (!vc_leq(vs->Wx, Ct)) {
        int other = first_violating_tid(vs->Wx, Ct);
        report_race("W-R", addr, other, t->tid, line_no, var);
    }

    // Rx := Rx ⊔ C_t
    vc_join(vs->Rx, Ct);
}

// ── __wcp_write ───────────────────────────────────────────────────────────────
//
//   P_t := P_t ⊔ (⊔_{ℓ∈L} (Lr[ℓ][x] ⊔ Lw[ℓ][x]))
//   if ¬(Rx ⊑ C_t)  → R-W race
//   if ¬(Wx ⊑ C_t)  → W-W race
//   Wx := Wx ⊔ C_t
void __wcp_write(void *addr, int line_no, char* var) {
    slow_write_count.fetch_add(1, std::memory_order_relaxed);
    ThreadState *t  = get_current_thread();
    VarState    *vs = get_var_state(addr);
    uintptr_t xaddr = (uintptr_t)addr;

    // Record in all enclosing CS frames (to populate Lw at release, line 8).
    csframe_record_write(t->tid, xaddr);

    std::vector<void*> held = get_held_locks(t->tid);

    std::lock_guard<std::recursive_mutex> lk_t(t->mtx);
    std::lock_guard<std::recursive_mutex> lk_v(vs->mtx);

    for (void *la : held) {
        LockState *ls = get_lock_state(la);
        std::lock_guard<std::recursive_mutex> lk_l(ls->mtx);
        auto itr = ls->Lr.find(xaddr);
        if (itr != ls->Lr.end())
            vc_join(t->P, itr->second);
        auto itw = ls->Lw.find(xaddr);
        if (itw != ls->Lw.end())
            vc_join(t->P, itw->second);
    }

    VClock Ct = t->Ct();

    // Race check: ¬(Rx ⊑ C_t)  →  R-W WCP-race
    if (!vc_leq(vs->Rx, Ct)) {
        int other = first_violating_tid(vs->Rx, Ct);
        report_race("R-W", addr, other, t->tid, line_no, var);
    }

    // Race check: ¬(Wx ⊑ C_t)  →  W-W WCP-race
    if (!vc_leq(vs->Wx, Ct)) {
        int other = first_violating_tid(vs->Wx, Ct);
        report_race("W-W", addr, other, t->tid, line_no, var);
    }

    // Wx := Wx ⊔ C_t
    vc_join(vs->Wx, Ct);
}

} // extern "C"
