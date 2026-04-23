/**
 * sa_correctness_test.cpp
 * ─────────────────────────────────────────────────────────────────────────────
 * PURPOSE
 *   Prove correctness of the Sharing-Analysis (SA) + FastTrack race detector.
 *   Every test targets a specific SA state-machine transition or property that
 *   a plain FastTrack test suite cannot distinguish.
 *
 *   The key insight: SA introduces decisions that plain FT never makes.
 *   A correct SA must:
 *     (A) DETECT exactly the same races as plain FT           → no false negatives
 *     (B) NOT report races on correctly-synchronized code      → no false positives
 *     (C) Reclaim ownership exactly when HB is established     → reclaim correctness
 *     (D) Keep FT state accurate during the OWNED phase so the
 *         OWNED→SHARED transition seeds FT with the right epoch → seeding correctness
 *
 * ─────────────────────────────────────────────────────────────────────────────
 * HOW TO READ THE EXPECTED OUTPUT
 *
 *   [RACE EXPECTED]  The detector MUST fire at least one race report here.
 *                    If it is silent → false negative in the SA layer.
 *
 *   [SAFE]           The detector MUST be completely silent here.
 *                    If it fires    → false positive in the SA layer.
 *
 *   [RECLAIM PROBE]  Tests that ownership reclaim fires after an HB edge.
 *                    After the test the variable should be back in OWNED state,
 *                    so a private-only access phase must be silent.
 *
 * ─────────────────────────────────────────────────────────────────────────────
 * BUILD
 *   Without instrumentation (reference / baseline — no races reported):
 *     g++ -O1 -g -pthread -std=c++17 sa_correctness_test.cpp -o sa_test
 *
 *   With your instrumented pass:
 *     clang++ -O1 -g -pthread -std=c++17 -fpass-plugin=./RaceDetector.so \
 *             sa_correctness_test.cpp -o sa_test_inst
 *
 * RUN
 *   ./sa_test_inst [test_number]     — run one test (1-based)
 *   ./sa_test_inst                   — run all tests sequentially
 *
 * ─────────────────────────────────────────────────────────────────────────────
 * SA STATE-MACHINE COVERAGE MAP
 *
 *  Transition                  Tests that exercise it
 *  ──────────────────────────────────────────────────────────────────
 *  UNACCESSED → OWNED_READ     T1, T3, T7, T14
 *  UNACCESSED → OWNED_WRITE    T2, T4, T8
 *  OWNED_READ → OWNED_READ     T3  (same owner multiple reads)
 *  OWNED_WRITE → OWNED_WRITE   T4  (same owner multiple writes)
 *  OWNED_READ → OWNED_WRITE    T5  (owner upgrades read→write)
 *  OWNED_WRITE → OWNED_READ    T6  (owner reads after write — R must be updated)
 *  OWNED_READ → SHARED         T7  (second thread reads, no race)
 *  OWNED_WRITE → SHARED        T8  (second thread writes — W-W race expected)
 *  OWNED_WRITE → SHARED        T9  (second thread reads — W-R race expected)
 *  OWNED_READ → SHARED         T10 (second thread writes — R-W race expected)
 *  SHARED → OWNED (join)       T11, T12
 *  SHARED → OWNED (lock)       T13
 *  SHARED → OWNED → SHARED     T14 (reclaim then re-share)
 *  SHARED, 4 threads, W-W      T15
 *  SHARED, 4 threads, R-W      T16
 *  READ_SHARED state in FT     T17 (≥3 concurrent readers then write)
 *  No reclaim while live       T18 (reclaim must NOT fire prematurely)
 *  2 joins, staged reclaim     T19
 *  Lock-protected shared       T20 (SAFE — full lock discipline)
 * ─────────────────────────────────────────────────────────────────────────────
 */

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>
#include <atomic>
#include <vector>

/* ── formatting helpers ───────────────────────────────────────────────────── */
#define SEP  "────────────────────────────────────────────────────────\n"
#define RACE_EXPECTED(msg) printf("  [RACE EXPECTED]  " msg "\n")
#define SAFE(msg)          printf("  [SAFE]           " msg "\n")
#define RECLAIM(msg)       printf("  [RECLAIM PROBE]  " msg "\n")

static void spin_ms(int ms) {
    struct timespec ts = {0, (long)ms * 1000000L};
    nanosleep(&ts, nullptr);
}

/* Reusable two-thread rendezvous barrier */
struct Gate {
    std::atomic<int> val {0};
    void open()       { val.store(1, std::memory_order_release); }
    void wait_open()  { while (!val.load(std::memory_order_acquire)); }
    void reset()      { val.store(0, std::memory_order_relaxed); }
};


/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 1 — UNACCESSED → OWNED_READ transition
 *          Variable never touched before. Main thread reads it first.
 *          Then a second thread reads it concurrently (no race — both reads).
 *
 * SA correctness check:
 *   • First read must transition UNACCESSED → OWNED_READ, NOT call FT.
 *   • Second (concurrent) read by a different thread must transition to SHARED
 *     and call FT. FT sees W=0, so no W-R race is reported.
 *   Expected: SILENT (no race report).
 * ═══════════════════════════════════════════════════════════════════════════ */
static int t1_var;
static Gate t1_gate;

static void* t1_reader(void*) {
    t1_gate.wait_open();
    (void)t1_var;   /* concurrent read — no race because both sides read */
    return nullptr;
}
static void test1_unaccessed_to_owned_read() {
    printf(SEP "TEST 1  UNACCESSED → OWNED_READ: two concurrent readers, no writer\n");
    t1_var = 0;
    (void)t1_var;   /* main reads first → UNACCESSED → OWNED_READ */
    pthread_t t;
    pthread_create(&t, nullptr, t1_reader, nullptr);
    t1_gate.open();
    (void)t1_var;   /* main reads while thread also reads */
    pthread_join(t, nullptr);
    SAFE("concurrent reads only — no race expected");
}


/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 2 — UNACCESSED → OWNED_WRITE transition
 *          Variable never touched. Main thread writes it first.
 *          A second thread writes concurrently.
 *
 * SA correctness check:
 *   • First write → UNACCESSED → OWNED_WRITE, owner_clock seeded correctly.
 *   • Second thread's write transitions to SHARED; FT sees x->W = owner epoch.
 *     Since owner wrote without synchronisation, W-W race must be detected.
 *   Expected: W-W race.
 * ═══════════════════════════════════════════════════════════════════════════ */
static int t2_var;
static Gate t2_gate;

static void* t2_writer(void*) {
    t2_gate.wait_open();
    t2_var = 99;    /* concurrent write — W-W race */
    return nullptr;
}
static void test2_unaccessed_to_owned_write() {
    printf(SEP "TEST 2  UNACCESSED → OWNED_WRITE: concurrent writes, no sync\n");
    t2_var = 1;     /* main writes → UNACCESSED → OWNED_WRITE */
    pthread_t t;
    pthread_create(&t, nullptr, t2_writer, nullptr);
    t2_gate.open();
    t2_var = 2;     /* main writes again while thread also writes */
    pthread_join(t, nullptr);
    RACE_EXPECTED("W-W race: both threads write t2_var without synchronisation");
}


/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 3 — OWNED_READ → OWNED_READ: same owner reads many times
 *          Then a different thread writes → must detect R-W race.
 *
 * SA correctness check:
 *   • Many same-owner reads must stay in OWNED_READ, NOT call FT.
 *   • owner_clock must be updated on every same-owner read so that when
 *     the thread transitions to SHARED, FT's x->R reflects the LATEST
 *     read epoch, not the one from the first read.
 *   • If owner_clock is stale, FT may miss the R-W race or report a
 *     spurious "already HB" pass — this test catches that bug.
 *   Expected: R-W race.
 * ═══════════════════════════════════════════════════════════════════════════ */
static int t3_var;
static Gate t3_gate;

static void* t3_writer(void*) {
    t3_gate.wait_open();
    t3_var = 77;    /* write after many reads by main → R-W race */
    return nullptr;
}
static void test3_owned_read_many_then_rw_race() {
    printf(SEP "TEST 3  OWNED_READ × N → SHARED: stale owner_clock would miss R-W race\n");
    t3_var = 0;
    /* Many reads by owner: owner_clock must advance on each one */
    for (int i = 0; i < 50000; i++) (void)t3_var;
    pthread_t t;
    pthread_create(&t, nullptr, t3_writer, nullptr);
    t3_gate.open();
    (void)t3_var;   /* owner reads while thread writes → R-W */
    pthread_join(t, nullptr);
    RACE_EXPECTED("R-W race: thread writes after many private reads by main");
}


/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 4 — OWNED_WRITE → OWNED_WRITE: same owner writes many times
 *          Then a different thread writes → must detect W-W race.
 *
 * SA correctness check:
 *   • Many same-owner writes stay in OWNED_WRITE, do not call FT.
 *   • owner_clock updated to reflect latest write epoch.
 *   • On transition to SHARED, FT seeds x->W from the latest owner_clock.
 *     If stale, FT might not see a race because the seeded W epoch predates
 *     the second thread's VC, making it appear HB-ordered.
 *   Expected: W-W race.
 * ═══════════════════════════════════════════════════════════════════════════ */
static int t4_var;
static Gate t4_gate;

static void* t4_writer2(void*) {
    t4_gate.wait_open();
    t4_var = 55;    /* W-W race */
    return nullptr;
}
static void test4_owned_write_many_then_ww_race() {
    printf(SEP "TEST 4  OWNED_WRITE × N → SHARED: stale owner_clock would miss W-W race\n");
    t4_var = 0;
    for (int i = 0; i < 50000; i++) t4_var = i;   /* many private writes */
    pthread_t t;
    pthread_create(&t, nullptr, t4_writer2, nullptr);
    t4_gate.open();
    t4_var = -1;    /* owner writes while thread also writes → W-W */
    pthread_join(t, nullptr);
    RACE_EXPECTED("W-W race: thread writes after many private writes by main");
}


/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 5 — OWNED_READ → OWNED_WRITE upgrade (same owner)
 *          Owner first reads then writes. Then another thread writes.
 *
 * SA correctness check:
 *   • After the owner writes, share_state becomes OWNED_WRITE and x->W
 *     is updated; x->R must be cleared to 0.
 *   • On SHARED transition seeding: FT must use x->W (the write), NOT x->R
 *     (which is 0). The second thread writes → W-W race must fire.
 *   Expected: W-W race.
 * ═══════════════════════════════════════════════════════════════════════════ */
static int t5_var;
static Gate t5_gate;

static void* t5_writer(void*) {
    t5_gate.wait_open();
    t5_var = 5;     /* W-W race */
    return nullptr;
}
static void test5_owned_read_upgrade_to_write() {
    printf(SEP "TEST 5  OWNED_READ → OWNED_WRITE upgrade, then W-W race on SHARED\n");
    t5_var = 0;
    (void)t5_var;   /* UNACCESSED → OWNED_READ */
    t5_var = 10;    /* OWNED_READ → OWNED_WRITE; x->R must become 0 */
    pthread_t t;
    pthread_create(&t, nullptr, t5_writer, nullptr);
    t5_gate.open();
    t5_var = 20;    /* owner writes; thread also writes → W-W */
    pthread_join(t, nullptr);
    RACE_EXPECTED("W-W race after read→write upgrade; seeding must use W not R");
}


/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 6 — OWNED_WRITE → OWNED_READ: owner reads after writing
 *          Then another thread writes → W-R race (thread write vs owner read).
 *          Also checks that x->R is correctly updated on OWNED_WRITE→READ.
 *
 * SA correctness check:
 *   • Owner writes (OWNED_WRITE), then reads (must update x->R while
 *     staying in OWNED_WRITE — do NOT downgrade share_state).
 *   • On SHARED transition: state was OWNED_WRITE so FT seeds x->W.
 *     But main's last access was a read → FT should also see x->R.
 *   • A thread that then writes must trigger a W-R race against main's read.
 *   Expected: W-R race.
 * ═══════════════════════════════════════════════════════════════════════════ */
static int t6_var;
static Gate t6_gate;

static void* t6_writer(void*) {
    t6_gate.wait_open();
    t6_var = 6;     /* write races with owner's read */
    return nullptr;
}
static void test6_owned_write_then_read_then_wr_race() {
    printf(SEP "TEST 6  OWNED_WRITE, owner reads, thread writes → W-R race\n");
    t6_var = 100;   /* UNACCESSED → OWNED_WRITE */
    (void)t6_var;   /* owner reads: x->R must be updated, stay OWNED_WRITE */
    pthread_t t;
    pthread_create(&t, nullptr, t6_writer, nullptr);
    t6_gate.open();
    (void)t6_var;   /* owner reads while thread writes → W-R race */
    pthread_join(t, nullptr);
    RACE_EXPECTED("W-R race: thread write vs owner read after write→read pattern");
}


/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 7 — OWNED_READ → SHARED with no race (two concurrent readers)
 *          Owner reads, second thread reads concurrently.
 *          No writer anywhere → no race.
 *
 * SA correctness check:
 *   • On transition, SA sets x->W = 0, x->R = owner_epoch.
 *   • FT sees W=0 → no W-R race. Two concurrent reads → READ_SHARED.
 *   • Detector must be silent.
 *   Expected: SAFE.
 * ═══════════════════════════════════════════════════════════════════════════ */
static int t7_var;
static Gate t7_gate;

static void* t7_reader(void*) {
    t7_gate.wait_open();
    (void)t7_var;   /* concurrent read */
    return nullptr;
}
static void test7_owned_read_to_shared_safe() {
    printf(SEP "TEST 7  OWNED_READ → SHARED: two concurrent readers — no race\n");
    t7_var = 42;
    (void)t7_var;   /* UNACCESSED → OWNED_READ */
    pthread_t t;
    pthread_create(&t, nullptr, t7_reader, nullptr);
    t7_gate.open();
    (void)t7_var;   /* concurrent read */
    pthread_join(t, nullptr);
    SAFE("two concurrent reads, no write — must be silent");
}


/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 8 — OWNED_WRITE → SHARED: second thread writes (W-W race)
 *          This is the core FT seeding test for the write case.
 *
 * SA correctness check:
 *   • SA must seed x->W = make_epoch(owner_tid, owner_clock).
 *   • FT checks: w_clock > t2->get_clock_of(w_tid) → W-W race fires.
 *   • If SA seeds x->W = 0 instead, FT sees no prior write → MISS.
 *   Expected: W-W race.
 * ═══════════════════════════════════════════════════════════════════════════ */
static int t8_var;
static Gate t8_gate;

static void* t8_writer(void*) {
    t8_gate.wait_open();
    t8_var = 8;     /* W-W race */
    return nullptr;
}
static void test8_owned_write_to_shared_ww_race() {
    printf(SEP "TEST 8  OWNED_WRITE → SHARED: W-W race (FT seeding correctness)\n");
    t8_var = 1;     /* UNACCESSED → OWNED_WRITE; owner_clock recorded */
    pthread_t t;
    pthread_create(&t, nullptr, t8_writer, nullptr);
    t8_gate.open();
    t8_var = 2;     /* owner writes; thread also writes → W-W */
    pthread_join(t, nullptr);
    RACE_EXPECTED("W-W: wrong seeding (x->W=0) would cause a false negative here");
}


/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 9 — OWNED_WRITE → SHARED: second thread reads (W-R race)
 *          Owner wrote. Thread reads concurrently → W-R.
 *
 * SA correctness check:
 *   • SA seeds x->W = owner epoch, x->R = 0.
 *   • FT read: w_clock > t2->C[w_tid] → W-R race.
 *   Expected: W-R race.
 * ═══════════════════════════════════════════════════════════════════════════ */
static int t9_var;
static Gate t9_gate;

static void* t9_reader(void*) {
    t9_gate.wait_open();
    (void)t9_var;   /* read while owner wrote → W-R race */
    return nullptr;
}
static void test9_owned_write_to_shared_wr_race() {
    printf(SEP "TEST 9  OWNED_WRITE → SHARED: W-R race (thread reads, owner wrote)\n");
    t9_var = 9;     /* UNACCESSED → OWNED_WRITE */
    pthread_t t;
    pthread_create(&t, nullptr, t9_reader, nullptr);
    t9_gate.open();
    (void)t9_var;   /* owner reads; both unsynchronised relative to each other */
    pthread_join(t, nullptr);
    RACE_EXPECTED("W-R: thread reads after unsynchronised owner write");
}


/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 10 — OWNED_READ → SHARED: second thread writes (R-W race)
 *           Owner read. Thread writes concurrently → R-W.
 *
 * SA correctness check:
 *   • SA seeds x->W = 0, x->R = owner_epoch.
 *   • FT write: r_clock > t2->C[r_tid] → R-W race.
 *   • If SA seeds x->R = 0, FT sees no prior read → MISS.
 *   Expected: R-W race.
 * ═══════════════════════════════════════════════════════════════════════════ */
static int t10_var;
static Gate t10_gate;

static void* t10_writer(void*) {
    t10_gate.wait_open();
    t10_var = 10;   /* write while owner read → R-W race */
    return nullptr;
}
static void test10_owned_read_to_shared_rw_race() {
    printf(SEP "TEST 10 OWNED_READ → SHARED: R-W race (thread writes, owner read)\n");
    t10_var = 0;
    (void)t10_var;  /* UNACCESSED → OWNED_READ; owner_clock seeded */
    pthread_t t;
    pthread_create(&t, nullptr, t10_writer, nullptr);
    t10_gate.open();
    (void)t10_var;  /* owner reads concurrently with thread's write → R-W */
    pthread_join(t, nullptr);
    RACE_EXPECTED("R-W: wrong seeding (x->R=0) would cause a false negative here");
}


/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 11 — SHARED → OWNED reclaim after pthread_join (single child)
 *           Main and child share var. After join, main reclaims.
 *           Post-reclaim accesses by main must be silent.
 *
 * SA correctness check:
 *   • After join, main's VC dominates child's. can_reclaim() must return true.
 *   • Once reclaimed, main's subsequent accesses go through OWNED fast path.
 *   • A second child created AFTER reclaim must detect races again (variable
 *     re-enters SHARED properly).
 *   Phase 1 expected: W-W race (concurrent writes before join).
 *   Phase 2 expected: SAFE (post-join private access, reclaim fired).
 * ═══════════════════════════════════════════════════════════════════════════ */
static int t11_var;
static Gate t11_go;

static void* t11_child(void*) {
    t11_go.wait_open();
    t11_var = 11;   /* concurrent write → W-W race in phase 1 */
    return nullptr;
}
static void test11_reclaim_after_join() {
    printf(SEP "TEST 11 SHARED → OWNED reclaim after pthread_join\n");

    /* Phase 1: create a race */
    t11_var = 0;    /* main owns */
    pthread_t t;
    pthread_create(&t, nullptr, t11_child, nullptr);
    t11_go.open();
    t11_var = 1;    /* concurrent write → W-W race */
    pthread_join(t, nullptr);
    RACE_EXPECTED("phase 1 W-W: concurrent writes before join");

    /* Phase 2: post-join private access
     * join has established HB. can_reclaim() should fire on next access.
     * All subsequent accesses must be silent. */
    for (int i = 0; i < 10000; i++) t11_var = i;   /* private after reclaim */
    RECLAIM("phase 2: post-join private writes must be silent (reclaim fired)");
}


/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 12 — SHARED → OWNED reclaim, then re-shared (multi-phase lifecycle)
 *           Exercises the full OWNED→SHARED→OWNED→SHARED cycle.
 *
 * SA correctness check:
 *   • After join, reclaim fires → OWNED.
 *   • A new child is spawned → variable re-enters SHARED.
 *   • Race detection must work correctly in this second SHARED phase.
 *   Phase 2 expected: W-W race (new race after reclaim).
 * ═══════════════════════════════════════════════════════════════════════════ */
static int t12_var;
static Gate t12_go1, t12_go2;

static void* t12_child1(void*) { t12_go1.wait_open(); t12_var = 12; return nullptr; }
static void* t12_child2(void*) { t12_go2.wait_open(); t12_var = 99; return nullptr; }

static void test12_reclaim_then_reshare() {
    printf(SEP "TEST 12 OWNED→SHARED→OWNED(reclaim)→SHARED: two-phase lifecycle\n");

    /* Phase 1: shared + race */
    t12_var = 0;
    pthread_t t1;
    pthread_create(&t1, nullptr, t12_child1, nullptr);
    t12_go1.open();
    t12_var = 1;    /* W-W race */
    pthread_join(t1, nullptr);
    RACE_EXPECTED("phase 1 W-W: first concurrent write pair");

    /* Reclaim should have fired. Private phase. */
    for (int i = 0; i < 1000; i++) t12_var = i;
    RECLAIM("between phases: post-join private writes must be silent");

    /* Phase 2: re-share with a new child */
    pthread_t t2;
    pthread_create(&t2, nullptr, t12_child2, nullptr);
    t12_go2.open();
    t12_var = 2;    /* W-W race again */
    pthread_join(t2, nullptr);
    RACE_EXPECTED("phase 2 W-W: race in second shared phase after reclaim");
}


/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 13 — SHARED → OWNED reclaim triggered by mutex acquire (not join)
 *           Thread writes under lock. Main acquires same lock → VC merge.
 *           Main's next access should reclaim ownership.
 *
 * SA correctness check:
 *   • Reclaim is not only triggered by join; it fires after any VC-advancing
 *     event. A lock-acquire that subsumes all prior writers' epochs is
 *     sufficient.
 *   • After reclaim, main's private accesses must be silent.
 *   Phase 1 (pre-lock): W-W race.
 *   Phase 2 (post-lock private): SAFE.
 * ═══════════════════════════════════════════════════════════════════════════ */
static int t13_var;
static pthread_mutex_t t13_mtx = PTHREAD_MUTEX_INITIALIZER;
static Gate t13_go;

static void* t13_child(void*) {
    t13_go.wait_open();
    pthread_mutex_lock(&t13_mtx);
    t13_var = 13;   /* write under lock */
    pthread_mutex_unlock(&t13_mtx);
    return nullptr;
}
static void test13_reclaim_after_lock_acquire() {
    printf(SEP "TEST 13 SHARED → OWNED reclaim via mutex acquire (not join)\n");

    /* Force SHARED state first: concurrent access without lock */
    t13_var = 0;
    pthread_t t;
    pthread_create(&t, nullptr, t13_child, nullptr);
    t13_go.open();
    spin_ms(2);
    t13_var = 99;   /* concurrent write without lock → W-W race */
    pthread_join(t, nullptr);
    RACE_EXPECTED("pre-lock phase W-W: establishing SHARED state");

    /* Now lock protocol: after main acquires the lock, its VC has absorbed
     * the child's VC (via unlock→lock HB). can_reclaim() must fire. */
    pthread_mutex_lock(&t13_mtx);
    /* At this point can_reclaim() should return true for t13_var */
    t13_var = 100;  /* should be reclaimed — first access under lock */
    pthread_mutex_unlock(&t13_mtx);

    /* Post-lock private phase — must be completely silent */
    for (int i = 0; i < 5000; i++) t13_var = i;
    RECLAIM("post-lock private phase: reclaim via lock acquire must be silent");
}


/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 14 — Reclaim must NOT fire while a concurrent thread is still live
 *           Two children share var. Main joins only the first.
 *           After first join, second child is still alive → no reclaim yet.
 *           After second join, reclaim is allowed.
 *
 * SA correctness check:
 *   • can_reclaim() must fail while the second child's epoch is not yet
 *     dominated by main's VC (the second child hasn't joined).
 *   • Premature reclaim would allow main to access without FT while
 *     the second child still runs → missed race.
 *   Phase between joins expected: W-W race still detected.
 *   Phase after both joins: SAFE (private).
 * ═══════════════════════════════════════════════════════════════════════════ */
static int t14_var;
static Gate t14_go1, t14_go2;
static std::atomic<int> t14_phase {0};

static void* t14_child1(void*) {
    t14_go1.wait_open();
    t14_var = 14;                   /* W-W race phase 1 */
    t14_phase.store(1, std::memory_order_release);
    return nullptr;
}
static void* t14_child2(void*) {
    /* Wait until phase 1 is done (child1 wrote), then write */
    while (t14_phase.load(std::memory_order_acquire) < 1);
    t14_go2.wait_open();
    t14_var = 141;                  /* still SHARED — no reclaim yet */
    return nullptr;
}
static void test14_no_premature_reclaim() {
    printf(SEP "TEST 14 No premature reclaim while second child still live\n");

    t14_var = 0;
    pthread_t c1, c2;
    pthread_create(&c1, nullptr, t14_child1, nullptr);
    pthread_create(&c2, nullptr, t14_child2, nullptr);

    t14_go1.open();
    spin_ms(2);
    t14_var = 1;        /* main writes while c1 is running → W-W */
    pthread_join(c1, nullptr);
    RACE_EXPECTED("W-W race with c1");

    /* c2 is still alive. Main's VC dominates c1 but NOT c2.
     * can_reclaim() must return false here.
     * Main's next write while c2 still runs must still go through FT. */
    t14_go2.open();
    t14_var = 2;        /* main writes while c2 still running → W-W race */
    RACE_EXPECTED("W-W race with c2 after c1 joined (no premature reclaim)");
    pthread_join(c2, nullptr);

    /* Now both joined. can_reclaim() must fire. */
    for (int i = 0; i < 5000; i++) t14_var = i;
    RECLAIM("post both-joins private phase: reclaim now allowed");
}


/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 15 — Four threads, all write same variable (W-W races)
 *           Tests SHARED state with more than 2 threads.
 *
 * SA correctness check:
 *   • FT must handle Rvc / W with 4 threads correctly in SHARED state.
 *   • SA must not exit SHARED while any of the 4 threads is still writing.
 *   Expected: multiple W-W races.
 * ═══════════════════════════════════════════════════════════════════════════ */
static int t15_var;

static void* t15_worker(void* arg) {
    int id = *(int*)arg;
    for (int i = 0; i < 5000; i++) t15_var = id * 1000 + i;   /* W-W races */
    return nullptr;
}
static void test15_four_thread_ww_race() {
    printf(SEP "TEST 15 Four threads all write same variable — W-W races\n");
    t15_var = 0;
    const int N = 4;
    pthread_t threads[N];
    int ids[N];
    for (int i = 0; i < N; i++) {
        ids[i] = i;
        pthread_create(&threads[i], nullptr, t15_worker, &ids[i]);
    }
    for (int i = 0; i < N; i++) pthread_join(threads[i], nullptr);
    RACE_EXPECTED("multiple W-W races across 4 threads on t15_var");
}


/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 16 — Four threads: one writer, three readers (W-R and R-W races)
 *           Tests READ_SHARED state in FT (≥2 concurrent readers + a write).
 *
 * SA correctness check:
 *   • FT transitions x->R to READ_SHARED when ≥2 concurrent readers exist.
 *   • A subsequent write must check Rvc (not just x->R) for R-W races.
 *   • SA must not interfere with FT's READ_SHARED state management.
 *   Expected: W-R and R-W races.
 * ═══════════════════════════════════════════════════════════════════════════ */
static int t16_var;
static Gate t16_readers_go, t16_writer_go;

static void* t16_reader(void*) {
    t16_readers_go.wait_open();
    (void)t16_var;   /* concurrent read */
    return nullptr;
}
static void* t16_writer_fn(void*) {
    t16_writer_go.wait_open();
    t16_var = 16;    /* concurrent write → R-W races against multiple readers */
    return nullptr;
}
static void test16_read_shared_state() {
    printf(SEP "TEST 16 READ_SHARED state: 3 concurrent readers then 1 writer\n");
    t16_var = 100;   /* main writes → OWNED_WRITE */

    /* Three readers race with main's write (W-R) and with each other's
     * subsequent state then a writer (R-W). */
    const int NR = 3;
    pthread_t readers[NR], writer;
    pthread_create(&writer, nullptr, t16_writer_fn, nullptr);
    for (int i = 0; i < NR; i++)
        pthread_create(&readers[i], nullptr, t16_reader, nullptr);

    t16_readers_go.open();
    spin_ms(1);
    t16_writer_go.open();

    for (int i = 0; i < NR; i++) pthread_join(readers[i], nullptr);
    pthread_join(writer, nullptr);
    RACE_EXPECTED("W-R and R-W races involving READ_SHARED FT state");
}


/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 17 — Correctly synchronised full producer-consumer (SAFE)
 *           Main produces, joins, consumer reads. Zero races.
 *           Tests that SA does not generate false positives on correct code.
 *
 * SA correctness check:
 *   • pthread_join establishes full HB. Consumer read is after producer write.
 *   • can_reclaim() fires on consumer's first access → OWNED.
 *   Expected: SAFE (completely silent).
 * ═══════════════════════════════════════════════════════════════════════════ */
static int t17_var;

static void* t17_producer(void*) {
    t17_var = 42;   /* private write in producer */
    return nullptr;
}
static void* t17_consumer(void*) {
    (void)t17_var;  /* read after producer joined — HB guarantees order */
    return nullptr;
}
static void test17_producer_consumer_safe() {
    printf(SEP "TEST 17 Producer → join → consumer: fully synchronised (SAFE)\n");
    t17_var = 0;
    pthread_t prod;
    pthread_create(&prod, nullptr, t17_producer, nullptr);
    pthread_join(prod, nullptr);   /* HB: all of prod's writes visible */

    pthread_t cons;
    pthread_create(&cons, nullptr, t17_consumer, nullptr);
    pthread_join(cons, nullptr);
    SAFE("producer-consumer with join: no race");
}


/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 18 — Mutex-protected shared variable: zero races (SAFE)
 *           All accesses in all threads are inside the same mutex.
 *           Tests SA + FT do not produce false positives under correct locking.
 *
 * Expected: SAFE (completely silent).
 * ═══════════════════════════════════════════════════════════════════════════ */
static int t18_var;
static pthread_mutex_t t18_mtx = PTHREAD_MUTEX_INITIALIZER;

static void* t18_worker(void*) {
    for (int i = 0; i < 10000; i++) {
        pthread_mutex_lock(&t18_mtx);
        t18_var++;
        pthread_mutex_unlock(&t18_mtx);
    }
    return nullptr;
}
static void test18_mutex_protected_safe() {
    printf(SEP "TEST 18 All accesses under mutex — no races (SAFE)\n");
    t18_var = 0;
    const int N = 4;
    pthread_t threads[N];
    for (int i = 0; i < N; i++)
        pthread_create(&threads[i], nullptr, t18_worker, nullptr);
    for (int i = 0; i < N; i++)
        pthread_join(threads[i], nullptr);
    SAFE("all increments under mutex: no race expected");
}


/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 19 — Private heap variable in thread: must not be treated as shared
 *           Each thread allocates, uses, and frees its own int[].
 *           SA must keep these in OWNED state throughout.
 *           Expected: completely SAFE (no race reports, no FT calls).
 * ═══════════════════════════════════════════════════════════════════════════ */
static void* t19_worker(void*) {
    int* priv = (int*)malloc(1024 * sizeof(int));
    for (int i = 0; i < 1024; i++) priv[i] = i;
    long sum = 0;
    for (int i = 0; i < 1024; i++) sum += priv[i];
    (void)sum;
    free(priv);
    return nullptr;
}
static void test19_private_heap_safe() {
    printf(SEP "TEST 19 Thread-private heap: must stay OWNED, no FT calls (SAFE)\n");
    const int N = 4;
    pthread_t threads[N];
    for (int i = 0; i < N; i++)
        pthread_create(&threads[i], nullptr, t19_worker, nullptr);
    for (int i = 0; i < N; i++)
        pthread_join(threads[i], nullptr);
    SAFE("each thread owns its own allocation — no race, no FT overhead");
}


/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 20 — Two variables: one shared (racy), one private (silent)
 *           Tests that SA correctly scopes instrumentation per-variable.
 *           The racy variable must produce races; the private one must not.
 *
 * SA correctness check:
 *   • SA must maintain independent state per address.
 *   • Racing on var_A must not corrupt the OWNED state of var_B.
 *   Expected: races on var_A only.
 * ═══════════════════════════════════════════════════════════════════════════ */
static int t20_shared;
static int t20_private_main;

static void* t20_worker(void*) {
    t20_shared++;               /* racy access to shared var */
    /* t20_private_main is never accessed here — stays OWNED by main */
    return nullptr;
}
static void test20_per_variable_independence() {
    printf(SEP "TEST 20 Per-variable SA state independence\n");
    t20_shared      = 0;
    t20_private_main = 0;

    /* main's private var: many accesses before threads start */
    for (int i = 0; i < 10000; i++) t20_private_main = i;

    const int N = 4;
    pthread_t threads[N];
    for (int i = 0; i < N; i++)
        pthread_create(&threads[i], nullptr, t20_worker, nullptr);

    t20_shared++;   /* racy: concurrent with workers */

    for (int i = 0; i < N; i++)
        pthread_join(threads[i], nullptr);

    /* More private accesses after join — must be silent */
    for (int i = 0; i < 10000; i++) t20_private_main = i;

    RACE_EXPECTED("races on t20_shared only");
    SAFE("t20_private_main: never accessed by children — must be silent");
}


/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 21 — Staged release-acquire chain (3 threads, chained HB)
 *           T1 writes, signals T2. T2 writes, signals T3. T3 reads.
 *           All properly synchronised → no race.
 *
 * SA correctness check:
 *   • can_reclaim() must work through a chain of VC merges, not just
 *     a direct parent→child join.
 *   Expected: SAFE.
 * ═══════════════════════════════════════════════════════════════════════════ */
static int t21_var;
static Gate t21_g1, t21_g2;

static void* t21_t1(void*) {
    t21_var = 1;       /* write, then signal T2 */
    t21_g1.open();
    return nullptr;
}
static void* t21_t2(void*) {
    t21_g1.wait_open();  /* wait for T1's write */
    t21_var = 2;         /* write, then signal T3 */
    t21_g2.open();
    return nullptr;
}
static void* t21_t3(void*) {
    t21_g2.wait_open();  /* wait for T2's write */
    (void)t21_var;       /* read — must be after all writes */
    return nullptr;
}
static void test21_chained_hb_safe() {
    printf(SEP "TEST 21 Chained HB via gates: T1→T2→T3 write-chain (SAFE)\n");
    t21_var = 0;
    pthread_t a, b, c;
    pthread_create(&a, nullptr, t21_t1, nullptr);
    pthread_create(&b, nullptr, t21_t2, nullptr);
    pthread_create(&c, nullptr, t21_t3, nullptr);
    pthread_join(a, nullptr);
    pthread_join(b, nullptr);
    pthread_join(c, nullptr);
    SAFE("chained HB via atomic flags: ordered writes, then read — no race");
}


/* ═══════════════════════════════════════════════════════════════════════════
 * TEST 22 — Write-write race with many iterations (stress)
 *           Two threads increment the same counter without synchronisation.
 *           Tests that the detector fires consistently, not just on first access.
 *
 * SA correctness check:
 *   • After initial transition to SHARED, the variable stays SHARED.
 *   • Every iteration is a potential W-W. At minimum one must be reported.
 *   Expected: W-W race(s).
 * ═══════════════════════════════════════════════════════════════════════════ */
static long t22_counter = 0;

static void* t22_inc(void*) {
    for (int i = 0; i < 100000; i++) t22_counter++;
    return nullptr;
}
static void test22_stress_ww_race() {
    printf(SEP "TEST 22 Stress W-W: two threads increment same counter 100k times\n");
    t22_counter = 0;
    pthread_t a, b;
    pthread_create(&a, nullptr, t22_inc, nullptr);
    pthread_create(&b, nullptr, t22_inc, nullptr);
    pthread_join(a, nullptr);
    pthread_join(b, nullptr);
    RACE_EXPECTED("W-W races on t22_counter (many iterations)");
}


/* ═══════════════════════════════════════════════════════════════════════════
 * MAIN
 * ═══════════════════════════════════════════════════════════════════════════ */
typedef void(*TestFn)(void);
static TestFn TESTS[] = {
    test1_unaccessed_to_owned_read,
    test2_unaccessed_to_owned_write,
    test3_owned_read_many_then_rw_race,
    test4_owned_write_many_then_ww_race,
    test5_owned_read_upgrade_to_write,
    test6_owned_write_then_read_then_wr_race,
    test7_owned_read_to_shared_safe,
    test8_owned_write_to_shared_ww_race,
    test9_owned_write_to_shared_wr_race,
    test10_owned_read_to_shared_rw_race,
    test11_reclaim_after_join,
    test12_reclaim_then_reshare,
    test13_reclaim_after_lock_acquire,
    test14_no_premature_reclaim,
    test15_four_thread_ww_race,
    test16_read_shared_state,
    test17_producer_consumer_safe,
    test18_mutex_protected_safe,
    test19_private_heap_safe,
    test20_per_variable_independence,
    test21_chained_hb_safe,
    test22_stress_ww_race,
};

int main(int argc, char** argv) {
    printf("\n");
    printf("════════════════════════════════════════════════════════\n");
    printf("  sa_correctness_test — SA state-machine coverage\n");
    printf("════════════════════════════════════════════════════════\n\n");

    int which = -1;
    if (argc == 2) which = atoi(argv[1]) - 1;

    int n = (int)(sizeof(TESTS)/sizeof(TESTS[0]));
    for (int i = 0; i < n; i++) {
        if (which >= 0 && i != which) continue;
        TESTS[i]();
        printf("\n");
    }

    printf("════════════════════════════════════════════════════════\n");
    printf("  Legend:\n");
    printf("  [RACE EXPECTED]  detector MUST fire at least once here\n");
    printf("  [SAFE]           detector must be completely SILENT here\n");
    printf("  [RECLAIM PROBE]  SA must have reclaimed ownership here;\n");
    printf("                   post-reclaim accesses must be silent\n");
    printf("════════════════════════════════════════════════════════\n\n");
    return 0;
}