// =============================================================================
// wcp_runtime_with_sa.cpp
//
// WCP (Weak-Causally-Precedes) race detector with Sharing Analysis fast path.
//
// ARCHITECTURE
// ============
// The SA layer sits in front of the WCP core exactly as it does in the FT+SA
// runtime.  The shadow table and hot-word state machine are identical:
//
//   UNACCESSED  ──read──►  OWNED_READ  ──other thread──►  SHARED
//   UNACCESSED  ─write──►  OWNED_WRITE ──other thread──►  SHARED
//   OWNED_*     ──same──►  OWNED_*     (fast path, no WCP work at all)
//   SHARED      ──any───►  wcp_{slow_read,slow_write}
//
// The WCP client replaces every call that was previously to ft_read_core /
// ft_write_core.  Everything else — shadow table, hot-word CAS, can_reclaim,
// owner_{read,write}_epoch cache — stays byte-for-byte the same.
//
// WCP STATE PER THREAD
//   N_t  — local integer clock
//   H_t  — HB vector clock
//   P_t  — WCP-predecessor vector clock
//   C_t  = P_t[t := N_t]   (computed on demand)
//
// WCP STATE PER LOCK
//   H_ℓ, P_ℓ         — last-release clocks
//   Acq_ℓ(t), Rel_ℓ(t) — FIFO queues (for WCP-predecessor propagation)
//   Lr[ℓ][x], Lw[ℓ][x]  — per-variable release summaries
//
// WCP STATE PER VARIABLE  (stored inside VarState)
//   Wx  — join of C_t for all writes
//   Rx  — join of C_t for all reads
//
// WCP RACE CONDITIONS
//   read(t,x):  ¬(Wx ⊑ C_t)  →  W-R
//   write(t,x): ¬(Rx ⊑ C_t)  →  R-W
//               ¬(Wx ⊑ C_t)  →  W-W
//
// SHARING ANALYSIS PURPOSE
//   Skips the WCP slow path entirely when a variable is owned by the current
//   thread (OWNED_READ or OWNED_WRITE state).  Entering the slow path is the
//   only place WCP work — vector-clock joins, Lr/Lw lookups, CS-frame
//   recording — is performed.  This matches the FT+SA design exactly.
// =============================================================================

#include <bits/stdc++.h>
#include <pthread.h>
#include <mutex>
#include <atomic>
#include <time.h>

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

// Global lock for the summary map
// Heap-allocated mutex to survive C++ static destruction sequence
std::mutex& get_race_summary_lock() {
    static auto* mtx = new std::mutex();
    return *mtx;
}

// Heap-allocated map to survive C++ static destruction sequence
std::unordered_map<void*, VariableRaceSummary>& get_race_summary() {
    static auto* instance = new std::unordered_map<void*, VariableRaceSummary>();
    return *instance;
}
// =============================================================================
// SECTION 1 — SHARING ANALYSIS LAYER  (unchanged from FT+SA)
// =============================================================================

// ── Shadow table dimensions ───────────────────────────────────────────────────
#define SHADOW_SIZE  (1 << 20)
#define SHADOW_MASK  (SHADOW_SIZE - 1)

// ── SA hot-word state machine ─────────────────────────────────────────────────
enum class ShareState : uint32_t {
    UNACCESSED  = 0,
    OWNED_READ  = 1,
    OWNED_WRITE = 2,
    SHARED      = 3
};

static inline uint64_t pack_hot(int owner_tid, ShareState ss) {
    return ((uint64_t)(uint32_t)owner_tid << 32) | (uint32_t)ss;
}
static inline ShareState hot_state(uint64_t w) {
    return (ShareState)(uint32_t)(w & 0xFFFFFFFFULL);
}
static inline int hot_owner(uint64_t w) {
    return (int)(uint32_t)(w >> 32);
}

// =============================================================================
// SECTION 2 — WCP VECTOR CLOCK HELPERS
// =============================================================================

using VClock = std::vector<int>;

static inline void vc_ensure(VClock& v, int idx) {
    if ((int)v.size() <= idx) v.resize(idx + 1, 0);
}

// dst = dst ⊔ src  (point-wise max, resize as needed)
static inline void vc_join(VClock& dst, const VClock& src) {
    if (src.size() > dst.size()) dst.resize(src.size(), 0);
    for (size_t i = 0; i < src.size(); ++i)
        if (src[i] > dst[i]) dst[i] = src[i];
}

// Is src ⊑ dst  (point-wise ≤)?
static inline bool vc_leq(const VClock& src, const VClock& dst) {
    for (size_t i = 0; i < src.size(); ++i) {
        int d = (i < dst.size()) ? dst[i] : 0;
        if (src[i] > d) return false;
    }
    return true;
}

// Return the first index i where src[i] > dst[i]  (for race-report tid).
static inline int first_violating_tid(const VClock& src, const VClock& dst) {
    for (size_t i = 0; i < src.size(); ++i) {
        int d = (i < dst.size()) ? dst[i] : 0;
        if (src[i] > d) return (int)i;
    }
    return -1;
}

// C_t = P_t with component tid forced to N.
static inline VClock make_Ct(const VClock& P, int tid, int N) {
    VClock C = P;
    vc_ensure(C, tid);
    C[tid] = N;
    return C;
}

// =============================================================================
// SECTION 3 — STATE STRUCTURES
// =============================================================================

// ── VarState: WCP variable metadata + SA owner-epoch cache ───────────────────
//
// The SA layer caches the last-seen owner_write_epoch and owner_read_epoch so
// that when the variable transitions from OWNED_* to SHARED the slow path can
// reconstruct Wx / Rx without having to re-run every historical access.
//
// In the WCP world Wx and Rx are full VClocks, not scalar Epochs.  So the
// "owner cache" stores the C_t snapshot taken at the moment the owner last
// wrote / read — exactly the value that would have been joined into Wx / Rx
// by wcp_write_core / wcp_read_core had the slow path been called.
//
struct VarState {
    // WCP per-variable clocks (the "real" FT-equivalent of W/R/Rvc).
    VClock Wx;   // join of C_t for all writes seen in slow path
    VClock Rx;   // join of C_t for all reads  seen in slow path

    // SA owner-epoch cache: the C_t snapshot from the last time the
    // owning thread wrote / read this variable while in OWNED_* state.
    // On transition to SHARED these are merged into Wx / Rx before the
    // WCP race check runs, ensuring no history is lost.
    VClock owner_write_Ct;   // last write  C_t while OWNED
    VClock owner_read_Ct;    // last read   C_t while OWNED

    std::recursive_mutex mtx;
};

// Forward declaration so ShadowEntry can hold a pointer.
struct ShadowEntry;

// ── SA shadow table entry  (one cache line) ───────────────────────────────────
struct alignas(64) ShadowEntry {
    std::atomic<uint64_t>  hot_word { pack_hot(-1, ShareState::UNACCESSED) };
    std::atomic<VarState*> state    { nullptr };
    std::atomic<uintptr_t> key      { 0 };
};
static_assert(sizeof(ShadowEntry) == 64,
              "ShadowEntry must be exactly one cache line");

// ── WCP ThreadState ───────────────────────────────────────────────────────────
struct ThreadState {
    int    tid;
    int    N;      // local clock
    VClock H;      // HB vector clock
    VClock P;      // WCP-predecessor vector clock

    mutable std::recursive_mutex mtx;

    explicit ThreadState(int id) : tid(id), N(1) {
        vc_ensure(H, id);
        H[id] = 1;
        // P starts as zero vector — no predecessor at birth.
    }

    // C_t = P_t[tid := N_t]
    VClock Ct() const { return make_Ct(P, tid, N); }
};

// ── WCP LockState ─────────────────────────────────────────────────────────────
struct LockState {
    VClock H_lock;   // HB clock of last release
    VClock P_lock;   // WCP-pred clock of last release

    // FIFO queues per destination thread.
    std::unordered_map<int, std::deque<VClock>> Acq;  // C_t from acq events
    std::unordered_map<int, std::deque<VClock>> Rel;  // H_t from rel events

    // Per-variable release summaries for this lock.
    std::unordered_map<uintptr_t, VClock> Lr;   // join of H_t of rels that contained r(x)
    std::unordered_map<uintptr_t, VClock> Lw;   // join of H_t of rels that contained w(x)

    mutable std::recursive_mutex mtx;
};

// ── Thread-create context ──────────────────────────────────────────────────────
struct ThreadContext {
    void *(*original_routine)(void *);
    void  *original_arg;
    VClock parent_H;   // snapshot of parent's H at fork
    VClock parent_P;   // snapshot of parent's P at fork
};

// =============================================================================
// SECTION 4 — WCP CRITICAL-SECTION FRAME TRACKER
//
// Tracks which variable addresses are read / written inside each lock's CS so
// that Lr[ℓ][x] and Lw[ℓ][x] can be updated at release time (WCP lines 7-8).
// This is purely a WCP concept — the SA layer never touches it.
// =============================================================================

struct CSFrame {
    void *lock_addr;
    std::unordered_set<uintptr_t> reads;
    std::unordered_set<uintptr_t> writes;
};

static std::recursive_mutex                          g_csframe_mtx;
static std::unordered_map<int, std::vector<CSFrame>> g_csframes;

static void csframe_push(int tid, void *lock_addr) {
    std::lock_guard<std::recursive_mutex> lk(g_csframe_mtx);
    g_csframes[tid].push_back({lock_addr, {}, {}});
}

static bool csframe_pop(int tid, void *lock_addr,
                        std::unordered_set<uintptr_t>& out_R,
                        std::unordered_set<uintptr_t>& out_W) {
    std::lock_guard<std::recursive_mutex> lk(g_csframe_mtx);
    auto it = g_csframes.find(tid);
    if (it == g_csframes.end()) return false;
    auto& stack = it->second;
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

static void csframe_record_read(int tid, uintptr_t addr) {
    std::lock_guard<std::recursive_mutex> lk(g_csframe_mtx);
    auto it = g_csframes.find(tid);
    if (it == g_csframes.end()) return;
    for (auto& frame : it->second) frame.reads.insert(addr);
}

static void csframe_record_write(int tid, uintptr_t addr) {
    std::lock_guard<std::recursive_mutex> lk(g_csframe_mtx);
    auto it = g_csframes.find(tid);
    if (it == g_csframes.end()) return;
    for (auto& frame : it->second) frame.writes.insert(addr);
}

static std::vector<void*> get_held_locks(int tid) {
    std::lock_guard<std::recursive_mutex> lk(g_csframe_mtx);
    std::vector<void*> held;
    auto it = g_csframes.find(tid);
    if (it == g_csframes.end()) return held;
    for (auto& frame : it->second) held.push_back(frame.lock_addr);
    return held;
}

// =============================================================================
// SECTION 5 — GLOBAL STATE
// =============================================================================

static std::atomic<int>  next_tid   {1};
static std::atomic<int>  race_count {0};
static ShadowEntry        shadow_table[SHADOW_SIZE];

static thread_local ThreadState* tl_thread_state = nullptr;
// Re-entrancy guard: prevents instrumented stdlib internals (e.g. allocator
// loads/stores inside new VarState()) from recursively entering the runtime.
static thread_local bool in_wcp_runtime = false;

// Thread registry
static std::recursive_mutex              g_thread_map_mtx;
static std::map<pthread_t, ThreadState*> g_thread_map;

// Lock registry
static std::recursive_mutex                  g_lock_map_mtx;
static std::unordered_map<void*, LockState*> g_lock_map;

// =============================================================================
// SECTION 6 — REGISTRY HELPERS
// =============================================================================

static ThreadState* get_current_thread() {
    if (tl_thread_state) return tl_thread_state;
    pthread_t self = pthread_self();
    std::lock_guard<std::recursive_mutex> lk(g_thread_map_mtx);
    auto it = g_thread_map.find(self);
    if (it == g_thread_map.end()) {
        int id = next_tid.fetch_add(1, std::memory_order_relaxed);
        auto* ts = new ThreadState(id);
        g_thread_map[self] = ts;
        tl_thread_state    = ts;
    } else {
        tl_thread_state = it->second;
    }
    return tl_thread_state;
}

static LockState* get_lock_state(void* addr) {
    std::lock_guard<std::recursive_mutex> lk(g_lock_map_mtx);
    auto& p = g_lock_map[addr];
    if (!p) p = new LockState();
    return p;
}

// SA shadow table lookup — lock-free, same as FT+SA.
static ShadowEntry* get_shadow_entry(void* addr) {
    uintptr_t key  = ((uintptr_t)addr >> 2) + 1;
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

static VarState* get_or_alloc_var_state(ShadowEntry* e) {
    VarState* s = e->state.load(std::memory_order_acquire);
    if (s) return s;
    VarState* ns = new VarState();
    VarState* expected = nullptr;
    if (!e->state.compare_exchange_strong(expected, ns,
            std::memory_order_acq_rel, std::memory_order_acquire)) {
        delete ns;
        return expected;
    }
    return ns;
}

// Returns all TIDs in the thread map except exclude_tid.
static std::vector<int> other_tids(int exclude_tid) {
    std::vector<int> result;
    std::lock_guard<std::recursive_mutex> lk(g_thread_map_mtx);
    for (auto& kv : g_thread_map)
        if (kv.second->tid != exclude_tid)
            result.push_back(kv.second->tid);
    return result;
}

// =============================================================================
// SECTION 7 — RACE REPORTING
// =============================================================================
void report_race(const char* type, void* addr, int tid1, int tid2, int line_no, char* var_name) {
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
#else
        struct timespec ts;
        clock_gettime(CLOCK_MONOTONIC, &ts);
        uint64_t ns = (uint64_t)ts.tv_sec * 1000000000ULL + (uint64_t)ts.tv_nsec;
        printf("[FASTTRACK LOG] | TYPE: %s | ADDR: %p | THREADS: %d-%d | LINE: %d | TS_NS: %llu\n",
        type, addr, tid1, tid2, line_no, (unsigned long long)ns);
    #endif
}


// =============================================================================
// SECTION 8 — WCP CORE: ACQUIRE / RELEASE
// =============================================================================

// ── do_acquire ───────────────────────────────────────────────────────────────
//  1: H_t := H_t ⊔ H_ℓ
//  2: P_t := P_t ⊔ P_ℓ
//  3: ∀ t'≠t: Acq_ℓ(t').Enqueue(C_t)
static void do_acquire(ThreadState* t, LockState* ls) {
    std::lock_guard<std::recursive_mutex> lk_t(t->mtx);
    std::lock_guard<std::recursive_mutex> lk_l(ls->mtx);
    vc_join(t->H, ls->H_lock);
    vc_join(t->P, ls->P_lock);
    VClock Ct = t->Ct();
    for (int tp : other_tids(t->tid))
        ls->Acq[tp].push_back(Ct);
}

// ── do_release ────────────────────────────────────────────────────────────────
//  4-6: while Acq_ℓ(t).front() ⊑ C_t: dequeue, P_t ⊔= Rel_ℓ(t).dequeue()
//  7:   ∀ x∈R: Lr[ℓ][x] ⊔= H_t
//  8:   ∀ x∈W: Lw[ℓ][x] ⊔= H_t
//  9:   H_ℓ := H_t;  P_ℓ := P_t
//  10:  ∀ t'≠t: Rel_ℓ(t').Enqueue(H_t)
//       N_t++
static void do_release(ThreadState* t, LockState* ls, void* lock_addr) {
    // Harvest CS sets before taking the main locks to avoid ordering issues
    // with g_csframe_mtx.
    std::unordered_set<uintptr_t> cs_R, cs_W;
    csframe_pop(t->tid, lock_addr, cs_R, cs_W);

    std::lock_guard<std::recursive_mutex> lk_t(t->mtx);
    std::lock_guard<std::recursive_mutex> lk_l(ls->mtx);

    VClock Ct = t->Ct();

    auto& acq_q = ls->Acq[t->tid];
    auto& rel_q = ls->Rel[t->tid];
    while (!acq_q.empty() && !rel_q.empty() &&
           vc_leq(acq_q.front(), Ct)) {
        acq_q.pop_front();
        vc_join(t->P, rel_q.front());
        rel_q.pop_front();
    }

    for (uintptr_t xaddr : cs_R) vc_join(ls->Lr[xaddr], t->H);
    for (uintptr_t xaddr : cs_W) vc_join(ls->Lw[xaddr], t->H);

    ls->H_lock = t->H;
    ls->P_lock = t->P;

    for (int tp : other_tids(t->tid))
        ls->Rel[tp].push_back(t->H);

    t->N++;
    vc_ensure(t->H, t->tid);
    t->H[t->tid] = t->N;
}

// =============================================================================
// SECTION 9 — WCP CORE: READ / WRITE  (the "slow path" called by SA)
//
// These operate under the var_lk + thr_lk already held by the SA slow path,
// so all accesses to x and t fields use relaxed / direct reads.
//
// Unlike FT's scalar Epochs, WCP's Wx and Rx are full VClocks.  The "owner
// cache" in VarState stores VClock snapshots (owner_write_Ct, owner_read_Ct)
// so the SA layer can restore Wx / Rx before running the WCP check when a
// variable transitions from OWNED_* to SHARED.
// =============================================================================

// ── wcp_read_core ─────────────────────────────────────────────────────────────
//
//  P_t := P_t ⊔ (⊔_{ℓ∈L} Lw[ℓ][x])    [line 11]
//  if ¬(Wx ⊑ C_t)  →  W-R race
//  Rx := Rx ⊔ C_t
//
// Returns true if a race was detected (used by can_reclaim guard in SA layer).
static bool wcp_read_core(void* addr, int line_no,
                          VarState* x, ThreadState* t, char* var) {
    uintptr_t xaddr = (uintptr_t)addr;

    // Record access in CS frames (for Lr update at release, line 7).
    csframe_record_read(t->tid, xaddr);

    // Line 11: P_t ⊔= Lw[ℓ][x] for each held lock ℓ.
    std::vector<void*> held = get_held_locks(t->tid);
    for (void* la : held) {
        LockState* ls = get_lock_state(la);
        std::lock_guard<std::recursive_mutex> lk_l(ls->mtx);
        auto it = ls->Lw.find(xaddr);
        if (it != ls->Lw.end())
            vc_join(t->P, it->second);
    }

    VClock Ct = t->Ct();

    bool raced = false;
    if (!vc_leq(x->Wx, Ct)) {
        int other = first_violating_tid(x->Wx, Ct);
        report_race("W-R", addr, other, t->tid, line_no, var);
        // Clear Wx so the same race is not re-reported on every subsequent
        // read — mirrors how FT clears x->W after a W-R report.
        x->Wx.clear();
        raced = true;
    }

    vc_join(x->Rx, Ct);
    return raced;
}

// ── wcp_write_core ────────────────────────────────────────────────────────────
//
//  P_t := P_t ⊔ (⊔_{ℓ∈L} (Lr[ℓ][x] ⊔ Lw[ℓ][x]))   [line 12]
//  if ¬(Rx ⊑ C_t)  →  R-W race
//  if ¬(Wx ⊑ C_t)  →  W-W race
//  Wx := Wx ⊔ C_t;  Rx := ∅
static bool wcp_write_core(void* addr, int line_no,
                           VarState* x, ThreadState* t, char* var) {
    uintptr_t xaddr = (uintptr_t)addr;

    // Record access in CS frames (for Lw update at release, line 8).
    csframe_record_write(t->tid, xaddr);

    // Line 12: P_t ⊔= Lr[ℓ][x] ⊔ Lw[ℓ][x] for each held lock ℓ.
    std::vector<void*> held = get_held_locks(t->tid);
    for (void* la : held) {
        LockState* ls = get_lock_state(la);
        std::lock_guard<std::recursive_mutex> lk_l(ls->mtx);
        auto itr = ls->Lr.find(xaddr);
        if (itr != ls->Lr.end()) vc_join(t->P, itr->second);
        auto itw = ls->Lw.find(xaddr);
        if (itw != ls->Lw.end()) vc_join(t->P, itw->second);
    }

    VClock Ct = t->Ct();

    bool raced = false;
    if (!vc_leq(x->Rx, Ct)) {
        int other = first_violating_tid(x->Rx, Ct);
        report_race("R-W", addr, other, t->tid, line_no, var);
        raced = true;
    }
    if (!vc_leq(x->Wx, Ct)) {
        int other = first_violating_tid(x->Wx, Ct);
        report_race("W-W", addr, other, t->tid, line_no, var);
        raced = true;
    }

    vc_join(x->Wx, Ct);
    x->Rx.clear();
    return raced;
}

// =============================================================================
// SECTION 10 — SA can_reclaim
//
// Decides whether the current thread can re-claim exclusive ownership of a
// variable after a SHARED-state slow-path access.  In FT+SA this checked
// whether the thread's scalar vector clock had "seen" all previous readers
// and writers.  In WCP+SA we do the same check but using the full VClock
// Wx / Rx and the WCP C_t.
//
// Invariant: called under var_lk + thr_lk.
// =============================================================================

static bool can_reclaim(ThreadState* t, VarState* x) {
    VClock Ct = t->Ct();

    // All previous writers must be causally before t under WCP.
    if (!vc_leq(x->Wx, Ct)) return false;

    // All previous readers must be causally before t under WCP.
    if (!vc_leq(x->Rx, Ct)) return false;

    return true;
}

// =============================================================================
// SECTION 11 — SA SLOW PATHS
//
// Structural copy of ft_slow_read / ft_slow_write from FT+SA, with every
// call to ft_read_core / ft_write_core replaced by wcp_read_core /
// wcp_write_core, and every use of scalar Epochs for owner cache replaced
// by VClock snapshots (owner_write_Ct / owner_read_Ct).
// =============================================================================

static void wcp_sa_slow_read(void* addr, int line_no,
                             ShadowEntry* e, ThreadState* t, char* var) {
    VarState* x = get_or_alloc_var_state(e);
    std::lock_guard<std::recursive_mutex> var_lk(x->mtx);
    std::lock_guard<std::recursive_mutex> thr_lk(t->mtx);

    // Re-read hot_word under the lock — another thread may have changed it
    // between our fast-path load and acquiring the lock.
    uint64_t   hw    = e->hot_word.load(std::memory_order_acquire);
    ShareState ss    = hot_state(hw);
    int        owner = hot_owner(hw);

    switch (ss) {
        // ── UNACCESSED: first access ever → take exclusive read ownership ──
        case ShareState::UNACCESSED: {
            VClock Ct = t->Ct();
            x->owner_write_Ct.clear();
            x->owner_read_Ct = Ct;
            x->Wx.clear();
            x->Rx = Ct;
            // Record in CS frames even on first access so Lr is populated.
            csframe_record_read(t->tid, (uintptr_t)addr);
            e->hot_word.store(pack_hot(t->tid, ShareState::OWNED_READ),
                              std::memory_order_release);
            return;
        }

        // ── OWNED_* by this thread: update owner cache, no race check ──────
        case ShareState::OWNED_READ:
        case ShareState::OWNED_WRITE:
            if (owner == t->tid) {
                VClock Ct = t->Ct();
                x->owner_read_Ct = Ct;
                // Keep OWNED_READ; a read never downgrades OWNED_WRITE.
                ShareState new_ss = (ss == ShareState::OWNED_WRITE)
                                  ? ShareState::OWNED_WRITE
                                  : ShareState::OWNED_READ;
                e->hot_word.store(pack_hot(t->tid, new_ss),
                                  std::memory_order_release);
                // Still record in CS frames for correct Lr/Lw at release.
                csframe_record_read(t->tid, (uintptr_t)addr);
                return;
            }

            // ── OWNED_* by a different thread: restore Wx/Rx from cache,
            //    transition to SHARED, then run WCP check. ─────────────────
            //
            // Why restore from cache before the WCP check?
            //   While the variable was OWNED_* the slow path was never called,
            //   so Wx / Rx were not updated.  The owner-cache fields hold the
            //   C_t values that *would* have been joined into Wx / Rx had the
            //   slow path run every time.  We must replay them now so the WCP
            //   race check sees a complete history.
            if (ss == ShareState::OWNED_WRITE) {
                // Previous owner was writing: Wx gets its write cache; Rx=∅.
                x->Wx = x->owner_write_Ct;
                x->Rx.clear();
            } else {
                // Previous owner was reading: Wx from write cache; Rx from read cache.
                x->Wx = x->owner_write_Ct;
                x->Rx = x->owner_read_Ct;
            }
            e->hot_word.store(pack_hot(t->tid, ShareState::SHARED),
                              std::memory_order_release);
            {
                bool raced = wcp_read_core(addr, line_no, x, t, var);
                if (!raced && can_reclaim(t, x)) {
                    x->owner_write_Ct = x->Wx;
                    x->owner_read_Ct  = t->Ct();
                    x->Rx.clear();
                    e->hot_word.store(pack_hot(t->tid, ShareState::OWNED_READ),
                                      std::memory_order_release);
                }
            }
            return;

        // ── SHARED: run WCP check directly ───────────────────────────────
        case ShareState::SHARED: {
            bool raced = wcp_read_core(addr, line_no, x, t, var);
            if (!raced && can_reclaim(t, x)) {
                x->owner_write_Ct = x->Wx;
                x->owner_read_Ct  = t->Ct();
                x->Rx.clear();
                e->hot_word.store(pack_hot(t->tid, ShareState::OWNED_READ),
                                  std::memory_order_release);
            }
            return;
        }
    }
}

static void wcp_sa_slow_write(void* addr, int line_no,
                              ShadowEntry* e, ThreadState* t, char* var) {
    VarState* x = get_or_alloc_var_state(e);
    std::lock_guard<std::recursive_mutex> var_lk(x->mtx);
    std::lock_guard<std::recursive_mutex> thr_lk(t->mtx);

    uint64_t   hw    = e->hot_word.load(std::memory_order_acquire);
    ShareState ss    = hot_state(hw);
    int        owner = hot_owner(hw);

    switch (ss) {
        case ShareState::UNACCESSED: {
            VClock Ct = t->Ct();
            x->owner_write_Ct = Ct;
            x->owner_read_Ct.clear();
            x->Wx = Ct;
            x->Rx.clear();
            csframe_record_write(t->tid, (uintptr_t)addr);
            e->hot_word.store(pack_hot(t->tid, ShareState::OWNED_WRITE),
                              std::memory_order_release);
            return;
        }

        case ShareState::OWNED_READ:
        case ShareState::OWNED_WRITE:
            if (owner == t->tid) {
                VClock Ct = t->Ct();
                x->owner_write_Ct = Ct;
                // A write always upgrades to OWNED_WRITE.
                e->hot_word.store(pack_hot(t->tid, ShareState::OWNED_WRITE),
                                  std::memory_order_release);
                csframe_record_write(t->tid, (uintptr_t)addr);
                return;
            }

            // Restore Wx / Rx from owner caches before transitioning.
            x->Wx = x->owner_write_Ct;
            x->Rx = x->owner_read_Ct;
            e->hot_word.store(pack_hot(t->tid, ShareState::SHARED),
                              std::memory_order_release);
            {
                bool raced = wcp_write_core(addr, line_no, x, t, var);
                if (!raced && can_reclaim(t, x)) {
                    x->owner_write_Ct = t->Ct();
                    x->owner_read_Ct.clear();
                    x->Rx.clear();
                    e->hot_word.store(pack_hot(t->tid, ShareState::OWNED_WRITE),
                                      std::memory_order_release);
                }
            }
            return;

        case ShareState::SHARED: {
            bool raced = wcp_write_core(addr, line_no, x, t, var);
            if (!raced && can_reclaim(t, x)) {
                x->owner_write_Ct = t->Ct();
                x->owner_read_Ct.clear();
                x->Rx.clear();
                e->hot_word.store(pack_hot(t->tid, ShareState::OWNED_WRITE),
                                  std::memory_order_release);
            }
            return;
        }
    }
}

// =============================================================================
// SECTION 12 — PUBLIC API  (extern "C")
// =============================================================================

extern "C" {

// ── __wcp_read ────────────────────────────────────────────────────────────────
//
// Fast path: if hot_word says this variable is OWNED by the current thread,
// update owner_read_Ct and return without any WCP work.
// CAS validates that no other thread stole ownership between the load and now.
// On CAS failure or non-owned state, fall through to wcp_sa_slow_read.
void __wcp_read(void* addr, int line_no, char* var) {
    if (in_wcp_runtime) return;
    struct Guard { ~Guard() { in_wcp_runtime = false; } } g;
    in_wcp_runtime = true;

    ThreadState* t = get_current_thread();
    ShadowEntry* e = get_shadow_entry(addr);

    uint64_t   hw    = e->hot_word.load(std::memory_order_acquire);
    ShareState ss    = hot_state(hw);
    int        owner = hot_owner(hw);

    if ((ss == ShareState::OWNED_READ || ss == ShareState::OWNED_WRITE)
        && owner == t->tid) {
        // Update owner read cache without running WCP machinery.
        VarState* x = e->state.load(std::memory_order_acquire);
        if (x) {
            // t->mtx not held here intentionally — owner_read_Ct is only
            // read/written by the owner thread on the fast path.
            std::lock_guard<std::recursive_mutex> lk(x->mtx);
            x->owner_read_Ct = t->Ct();
        }
        // Still record in CS frames — WCP requires all accesses tracked.
        csframe_record_read(t->tid, (uintptr_t)addr);

        uint64_t desired = hw; // keep same state
        if (e->hot_word.compare_exchange_strong(hw, desired,
                std::memory_order_release, std::memory_order_relaxed))
            return;
        // CAS failed — ownership changed; fall through to slow path.
    }

    wcp_sa_slow_read(addr, line_no, e, t, var);
}

// ── __wcp_write ───────────────────────────────────────────────────────────────
void __wcp_write(void* addr, int line_no, char* var) {
    if (in_wcp_runtime) return;
    struct Guard { ~Guard() { in_wcp_runtime = false; } } g;
    in_wcp_runtime = true;

    ThreadState* t = get_current_thread();
    ShadowEntry* e = get_shadow_entry(addr);

    uint64_t   hw    = e->hot_word.load(std::memory_order_acquire);
    ShareState ss    = hot_state(hw);
    int        owner = hot_owner(hw);

    if ((ss == ShareState::OWNED_READ || ss == ShareState::OWNED_WRITE)
        && owner == t->tid) {
        VarState* x = e->state.load(std::memory_order_acquire);
        if (x) {
            std::lock_guard<std::recursive_mutex> lk(x->mtx);
            x->owner_write_Ct = t->Ct();
        }
        csframe_record_write(t->tid, (uintptr_t)addr);

        uint64_t desired = pack_hot(t->tid, ShareState::OWNED_WRITE);
        if (e->hot_word.compare_exchange_weak(hw, desired,
                std::memory_order_release, std::memory_order_relaxed))
            return;
    }

    wcp_sa_slow_write(addr, line_no, e, t, var);
}

// ── Thread lifecycle ──────────────────────────────────────────────────────────

void* __wcp_prepare_context(void* routine, void* arg) {
    auto* ctx             = new ThreadContext();
    ctx->original_routine = reinterpret_cast<void*(*)(void*)>(routine);
    ctx->original_arg     = arg;

    ThreadState* parent = get_current_thread();
    {
        std::lock_guard<std::recursive_mutex> lk(parent->mtx);
        // Fork event: advance parent's local clock and stamp H_parent.
        parent->N++;
        vc_ensure(parent->H, parent->tid);
        parent->H[parent->tid] = parent->N;
        ctx->parent_H = parent->H;
        ctx->parent_P = parent->P;
    }
    return ctx;
}

void* thread_wrapper(void* raw_arg) {
    auto* ctx   = reinterpret_cast<ThreadContext*>(raw_arg);
    int   id    = next_tid.fetch_add(1, std::memory_order_relaxed);
    auto* child = new ThreadState(id);

    {
        std::lock_guard<std::recursive_mutex> lk(child->mtx);
        child->H = ctx->parent_H;
        child->P = ctx->parent_P;
        child->N = 1;
        vc_ensure(child->H, child->tid);
        child->H[child->tid] = child->N;
    }

    {
        std::lock_guard<std::recursive_mutex> lk(g_thread_map_mtx);
        g_thread_map[pthread_self()] = child;
    }
    tl_thread_state = child;

    void* (*fn)(void*) = ctx->original_routine;
    void*  fn_arg      = ctx->original_arg;
    delete ctx;
    return fn(fn_arg);
}

void __wcp_thread_create(uint64_t /*child_id_raw*/) {
    // No-op: parent clock already incremented in __wcp_prepare_context.
}

void __wcp_thread_join(uint64_t child_raw_id) {
    ThreadState* parent = get_current_thread();
    ThreadState* child  = nullptr;

    std::map<pthread_t, ThreadState*>::iterator it;
    {
        std::lock_guard<std::recursive_mutex> lk(g_thread_map_mtx);
        it = g_thread_map.find((pthread_t)child_raw_id);
        if (it != g_thread_map.end()) child = it->second;
    }

    if (!child) {
        fprintf(stderr, "[WCP+SA] WARNING: joined thread %lu not in registry\n",
                (unsigned long)child_raw_id);
        return;
    }

    {
        std::lock_guard<std::recursive_mutex> lk_p(parent->mtx);
        std::lock_guard<std::recursive_mutex> lk_c(child->mtx);
        vc_join(parent->H, child->H);
        vc_join(parent->P, child->P);
        vc_ensure(parent->H, parent->tid);
        parent->H[parent->tid] = parent->N;
    }

    {
        std::lock_guard<std::recursive_mutex> lk(g_thread_map_mtx);
        g_thread_map.erase(it);
    }
    delete child;
}

// ── Lock events ───────────────────────────────────────────────────────────────

void __wcp_lock(void* mutex_addr) {
    ThreadState* t  = get_current_thread();
    LockState*   ls = get_lock_state(mutex_addr);
    do_acquire(t, ls);
    csframe_push(t->tid, mutex_addr);
}

void __wcp_unlock(void* mutex_addr) {
    ThreadState* t  = get_current_thread();
    LockState*   ls = get_lock_state(mutex_addr);
    do_release(t, ls, mutex_addr);
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

// extern "C"
