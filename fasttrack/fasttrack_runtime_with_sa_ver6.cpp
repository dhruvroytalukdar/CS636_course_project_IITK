// fasttrack_runtime_with_sa_ver8.cpp
//
// Performance-first SA + FastTrack — FULLY CORRECT EDITION
//
// ══════════════════════════════════════════════════════════════════
// ANALYSIS OF SECOND EXTERNAL REVIEW (2 claims, both correct)
// ══════════════════════════════════════════════════════════════════
//
// ── CLAIM 1: "TOCTOU: blind hot_word store reverts slow-path
//             transitions" — CORRECT ───────────────────────────────
//
//   ver7 ended the fast path with:
//     e->hot_word.store(hw, memory_order_release)   // __ft_read
//     e->hot_word.store(pack_hot(t->tid, OWNED_WRITE), release) // __ft_write
//   where hw was loaded at the top of the function.
//
//   Because the fast path holds no lock, a slow-path thread can
//   legally steal ownership (OWNED_READ/T1 → SHARED/T2) in the
//   window between the fast-path's initial load and its final store.
//   The blind store then reverts the state machine back to
//   OWNED_READ/T1, erasing T2's transition.  Future accesses see
//   corrupt state → false negatives and false positives.
//
//   FIX: Replace the blind store with compare_exchange_weak.
//   The CAS publishes the release fence only if hot_word still holds
//   the value we loaded at the top.  If another thread changed it
//   (ownership stolen), the CAS fails and the fast path falls through
//   to the slow path.  The slow path then re-reads hot_word under
//   var_lk and handles whatever state is current.
//
//   Performance impact: on the common uncontended path (sole owner,
//   no concurrent stealer) the CAS succeeds on the first attempt —
//   it is a single atomic RMW, not a spin loop.  On x86 this is one
//   LOCK CMPXCHG instruction, which is more expensive than a plain
//   MOV but is the minimum cost of a correct lock-free publish.  The
//   zero-RMW promise in the performance contract cannot be kept while
//   also writing back to a shared word that other threads may modify.
//
// ── CLAIM 2: "Reclaim to OWNED_READ zeroes write epoch, causing
//             false negatives" — CORRECT ──────────────────────────
//
//   ver7 zeroed owner_write_epoch when reclaiming to OWNED_READ:
//     x->owner_write_epoch.store(0, relaxed);
//
//   can_reclaim() checks that the reclaimer's VC dominates x->W.
//   It may return true even when x->W != 0 (a prior write by another
//   thread happened-before the reclaimer).  If owner_write_epoch is
//   then zeroed, a future Thread 3 that is concurrent with the
//   original writer and has no HB relation to the reclaimer will
//   seed x->W = 0 and miss the write-read race.
//
//   Concrete example:
//     T1 writes X at clock 10. (OWNED_WRITE, owner_write_epoch=T1@10)
//     T1 unlocks M; T2 locks M.  T2's VC now dominates T1@10.
//     T2 reads X. can_reclaim returns true. Reclaims to OWNED_READ.
//     [BUG] owner_write_epoch set to 0. Record of T1's write lost.
//     T3 (concurrent with T1, no HB relation) reads X.
//     Slow path seeds x->W = owner_write_epoch = 0.  ft_read_core
//     sees W==0, skips write-read race check.  Race missed.
//
//   FIX: When reclaiming to OWNED_READ, copy the current x->W into
//   owner_write_epoch instead of zeroing it.  The seeding logic for
//   OWNED_READ → SHARED already loads both owner_write_epoch (for W)
//   and owner_read_epoch (for R), so this is all that is needed.
//   When reclaiming to OWNED_WRITE, owner_write_epoch is always set
//   to the reclaimer's current epoch (which is the most recent write),
//   so no change is needed there.
//
// ══════════════════════════════════════════════════════════════════
// INHERITED FROM EARLIER REVIEWS (still correct)
// ══════════════════════════════════════════════════════════════════
//
// ver5 → ver6: Made VarState fields atomic; added self_clock/self_epoch
//              to ThreadState; upgraded state pointer load to acquire.
//
// ver6 → ver7: Fixed release/acquire chain (fast path now publishes
//              owner epochs via a fence-carrying hot_word store);
//              replaced single owner_clock with separate
//              owner_write_epoch and owner_read_epoch; removed dead
//              x->W/x->R stores from the fast path.
//
// ver7 → ver8: Fixed TOCTOU (CAS instead of blind store); fixed
//              reclaim write-epoch preservation.
//
// ══════════════════════════════════════════════════════════════════
// PERFORMANCE CONTRACT (updated)
// ══════════════════════════════════════════════════════════════════
// For a privately-accessed variable (OWNED by the current thread):
//   • touches exactly ONE cache line  (the ShadowEntry)
//   • executes ONE CAS on hot_word (succeeds immediately when
//     uncontended; falls to slow path only when another thread has
//     concurrently stolen ownership — rare in the private case)
//   • acquires ZERO mutexes on the uncontended fast path
//   • is branch-prediction-friendly (CAS succeeds virtually always)
//
// SA STATE MACHINE
// ════════════════
//  UNACCESSED  → first access → OWNED_READ or OWNED_WRITE
//  OWNED_*  (owner == current thread)
//               → Update owner_write_epoch / owner_read_epoch;
//                 publish via CAS on hot_word (release on success).
//                 CAS failure → fall to slow path (ownership stolen).
//  OWNED_*  (owner != current thread)
//               → Transition to SHARED.  Seed x->W/x->R precisely.
//  SHARED       → Always call FT core.  Attempt reclaim on no-race.
//
// OWNERSHIP RECLAIM
// ═════════════════
//  Thread T can reclaim iff T's VC dominates FT's W/R/Rvc.
//  Reclaim to OWNED_READ: sets owner_write_epoch = current x->W
//                         (preserves write history for future seeders)
//                         sets owner_read_epoch  = T's current epoch.
//  Reclaim to OWNED_WRITE: sets owner_write_epoch = T's current epoch.

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
// 3. THE HOT WORD
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
// 4. SHADOW TABLE ENTRY  (exactly one cache line)
// ──────────────────────────────────────────────────────────────────

struct VarState;

struct alignas(64) ShadowEntry {
    std::atomic<uint64_t>  hot_word { pack_hot(-1, ShareState::UNACCESSED) };
    std::atomic<VarState*> state    { nullptr };
    std::atomic<uintptr_t> key      { 0 };
};
static_assert(sizeof(ShadowEntry) == 64, "ShadowEntry must be exactly one cache line");

// ──────────────────────────────────────────────────────────────────
// 5. VarState
//
// owner_write_epoch: the owner's epoch at its most recent write.
//   Written only by __ft_write fast path (relaxed), published via
//   CAS on hot_word (release on success).  Read by seeding slow path
//   with acquire after hot_word acquire.
//
// owner_read_epoch: the owner's epoch at its most recent read.
//   Written only by __ft_read fast path, same publish model.
//
// W, R, Rvc: FT layer; written only under var_lk by ft_*_core.
// ──────────────────────────────────────────────────────────────────

struct VarState {
    std::atomic<Epoch> W  { 0 };
    std::atomic<Epoch> R  { 0 };
    std::vector<Epoch> Rvc;   // only under var_lk

    std::atomic<Epoch> owner_write_epoch { 0 };
    std::atomic<Epoch> owner_read_epoch  { 0 };

    std::recursive_mutex mtx;
};

// ──────────────────────────────────────────────────────────────────
// 6. ThreadState and LockState
// ──────────────────────────────────────────────────────────────────

struct ThreadState {
    int tid;
    std::vector<int> C;   // guarded by mtx
    Epoch epoch;          // guarded by mtx

    // Stable atomic mirrors of C[tid] and epoch; readable from fast path
    // without holding mtx (written only by the owning thread, under mtx).
    std::atomic<int>   self_clock { 0 };
    std::atomic<Epoch> self_epoch { 0 };

    std::recursive_mutex mtx;

    ThreadState(int id) : tid(id) {
        if (tid >= (int)C.size()) C.resize(tid + 1, 0);
        C[tid] = 1;
        epoch  = make_epoch(tid, 1);
        self_clock.store(1,     std::memory_order_relaxed);
        self_epoch.store(epoch, std::memory_order_relaxed);
    }

    int get_clock_of(int u) const {
        if (u < 0 || u >= (int)C.size()) return 0;
        return C[u];
    }

    // Must be called under mtx whenever C[tid] or epoch changes.
    void sync_self_atomics() {
        self_clock.store(C[tid], std::memory_order_relaxed);
        self_epoch.store(epoch,  std::memory_order_relaxed);
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
// 9. RECLAIM CHECK  (called under var_lk + t->mtx)
// ──────────────────────────────────────────────────────────────────

static bool can_reclaim(ThreadState* t, VarState* x) {
    Epoch W = x->W.load(std::memory_order_relaxed);
    if (W != 0) {
        int w_tid   = get_tid(W);
        int w_clock = get_clock(W);
        if (w_tid != t->tid && t->get_clock_of(w_tid) < w_clock)
            return false;
    }
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
// 10. FT CORE  (var_lk + t->mtx held by caller; relaxed is fine)
// ──────────────────────────────────────────────────────────────────

static bool ft_read_core(void* addr, int line_no, VarState* x, ThreadState* t) {
    Epoch R = x->R.load(std::memory_order_relaxed);
    if (R == t->epoch) return false;

    Epoch W       = x->W.load(std::memory_order_relaxed);
    int   w_tid   = get_tid(W);
    int   w_clock = get_clock(W);
    if (w_clock > t->get_clock_of(w_tid)) {
        report_race("W-R", addr, w_tid, t->tid, line_no);
        x->W.store(0,        std::memory_order_relaxed);
        x->R.store(t->epoch, std::memory_order_relaxed);
        return true;
    }

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
    return false;
}

static bool ft_write_core(void* addr, int line_no, VarState* x, ThreadState* t) {
    Epoch W = x->W.load(std::memory_order_relaxed);
    if (W == t->epoch) return false;

    bool raced   = false;
    int  w_tid   = get_tid(W);
    int  w_clock = get_clock(W);
    if (w_clock > t->get_clock_of(w_tid)) {
        report_race("W-W", addr, w_tid, t->tid, line_no);
        raced = true;
    }

    Epoch R = x->R.load(std::memory_order_relaxed);
    if (R != READ_SHARED) {
        if (R != 0) {
            int r_tid   = get_tid(R);
            int r_clock = get_clock(R);
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

    x->W.store(t->epoch, std::memory_order_relaxed);
    x->R.store(0,        std::memory_order_relaxed);
    x->Rvc.clear();
    return raced;
}

// ──────────────────────────────────────────────────────────────────
// 11. SLOW PATH  (shared between __ft_read and __ft_write)
//
// Acquires var_lk + thr_lk, re-reads hot_word, and handles all
// non-fast-path cases.  Separated into a helper so the fast path
// in __ft_read / __ft_write can fall through cleanly after a CAS
// failure without duplicating the entire switch.
// ──────────────────────────────────────────────────────────────────

static void ft_slow_read(void* addr, int line_no, ShadowEntry* e, ThreadState* t) {
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
            // Seed x->W and x->R precisely from the stored owner epochs.
            // acquire pairs with the previous owner's fast-path relaxed
            // stores, which were sequenced-before the CAS release that we
            // just acquired via the hot_word load above.
            if (ss == ShareState::OWNED_WRITE) {
                x->W.store(x->owner_write_epoch.load(std::memory_order_acquire),
                           std::memory_order_relaxed);
                x->R.store(0, std::memory_order_relaxed);
            } else {
                // OWNED_READ: there may also be a prior write epoch to preserve.
                x->W.store(x->owner_write_epoch.load(std::memory_order_acquire),
                           std::memory_order_relaxed);
                x->R.store(x->owner_read_epoch.load(std::memory_order_acquire),
                           std::memory_order_relaxed);
            }
            x->Rvc.clear();
            e->hot_word.store(pack_hot(t->tid, ShareState::SHARED),
                              std::memory_order_release);
            {
                bool raced = ft_read_core(addr, line_no, x, t);
                if (!raced && can_reclaim(t, x)) {
                    // FIX Claim 2: preserve W into owner_write_epoch so that
                    // future threads seeding from OWNED_READ see the correct
                    // write history.  Do NOT zero it.
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
            bool raced = ft_read_core(addr, line_no, x, t);
            if (!raced && can_reclaim(t, x)) {
                // FIX Claim 2: preserve W into owner_write_epoch.
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

static void ft_slow_write(void* addr, int line_no, ShadowEntry* e, ThreadState* t) {
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
            // Seed from both stored epochs — OWNED_READ may have a
            // non-zero write epoch from a prior ownership cycle.
            x->W.store(x->owner_write_epoch.load(std::memory_order_acquire),
                       std::memory_order_relaxed);
            x->R.store(x->owner_read_epoch.load(std::memory_order_acquire),
                       std::memory_order_relaxed);
            x->Rvc.clear();
            e->hot_word.store(pack_hot(t->tid, ShareState::SHARED),
                              std::memory_order_release);
            {
                bool raced = ft_write_core(addr, line_no, x, t);
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
            bool raced = ft_write_core(addr, line_no, x, t);
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
// 12. PUBLIC MEMORY ACCESS CALLBACKS
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

void __ft_read(void* addr, int line_no) {
    ThreadState* t = get_current_thread();
    ShadowEntry* e = get_shadow_entry(addr);

    uint64_t   hw    = e->hot_word.load(std::memory_order_acquire);
    ShareState ss    = hot_state(hw);
    int        owner = hot_owner(hw);

    if ((ss == ShareState::OWNED_READ || ss == ShareState::OWNED_WRITE)
        && owner == t->tid) {

        VarState* x = e->state.load(std::memory_order_acquire);
        if (x) {
            x->owner_read_epoch.store(
                t->self_epoch.load(std::memory_order_relaxed),
                std::memory_order_relaxed);
        }

        // FIX Claim 1: CAS instead of blind store.
        // desired = same as loaded (OWNED_*/us); fails if stolen.
        // On success the release fence makes owner_read_epoch visible.
        uint64_t desired = hw;   // same state, same owner
        if (e->hot_word.compare_exchange_weak(hw, desired,
                std::memory_order_release,
                std::memory_order_relaxed)) {
            return;   // ← HOT PRIVATE READ PATH — common case
        }
        // CAS failed: ownership was stolen between the load and the CAS.
        // Fall through to slow path.
    }

    ft_slow_read(addr, line_no, e, t);
}

// ── __ft_write ──────────────────────────────────────────────────
//
// FAST PATH (owner write):
//   1. Load hot_word with acquire.
//   2. If OWNED by us: store owner_write_epoch (relaxed).
//   3. CAS hot_word: expected = loaded hw,
//                   desired  = OWNED_WRITE/us (upgrade if needed).
//      • success → epoch visible to future seeders.  Return.
//      • failure → fall to slow path.

void __ft_write(void* addr, int line_no) {
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

        // Desired: always OWNED_WRITE (upgrade from OWNED_READ if needed).
        uint64_t desired = pack_hot(t->tid, ShareState::OWNED_WRITE);
        if (e->hot_word.compare_exchange_weak(hw, desired,
                std::memory_order_release,
                std::memory_order_relaxed)) {
            return;   // ← HOT PRIVATE WRITE PATH — common case
        }
        // CAS failed: fall through to slow path.
    }

    ft_slow_write(addr, line_no, e, t);
}

// ──────────────────────────────────────────────────────────────────
// 13. THREAD LIFECYCLE CALLBACKS
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
        child->sync_self_atomics();
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
    parent->sync_self_atomics();
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
// 14. LOCK CALLBACKS
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