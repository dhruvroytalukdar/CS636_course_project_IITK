/*
 * BENCHMARK 6: HIGH SHARING — PROTECTED VS UNPROTECTED INTERLEAVED
 * ==================================================================
 * Sharing profile  : HIGH — all variables shared, but HALF are protected
 * Races present    : YES — only on the unprotected half
 * Instrumentation  : Sharing analysis should instrument ALL shared variables;
 *                    the race detector's lock-set / happens-before analysis
 *                    then determines which are actually racy
 *
 * This benchmark probes the interaction between sharing analysis (decides
 * WHAT to instrument) and race detection logic (decides WHICH accesses race).
 * Both protected and unprotected variables are "shared" in the sharing sense,
 * but only unprotected ones should produce race reports.
 *
 * Variable groups
 * ---------------
 *   Group P (protected)   — guarded by a per-group mutex → NO race
 *   Group U (unprotected) — same access pattern, no mutex → RACE
 *   Group B (barrier-sep) — written before join, read after → NO race
 *
 * What to measure
 * ---------------
 *   1. Races on Group U  → YES (detector must report)
 *   2. Races on Group P  → NO  (lock discipline satisfied)
 *   3. Races on Group B  → NO  (happens-before via pthread_join)
 *   4. Instrumentation   → HIGH for P and U (both are shared),
 *                          NONE for pure-private locals
 */

#define _GNU_SOURCE
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* ======================================================= configuration === */
#define NUM_THREADS       8
#define NUM_GROUPS       16    /* groups in both P and U categories          */
#define GROUP_SIZE       64    /* ints per group                             */
#define ITERATIONS      1000
#define BARRIER_ARRAY   256   /* post-barrier array (written pre-spawn)     */

/* ======================================================= shared state ==== */

/* Group P — protected by locks, NO races */
typedef struct {
    pthread_mutex_t lock;
    long            counter;
    int             data[GROUP_SIZE];
} prot_group_t;

static prot_group_t P[NUM_GROUPS];

/* Group U — unprotected, races expected on everything */
typedef struct {
    long            counter;
    int             data[GROUP_SIZE];
} unprot_group_t;

static unprot_group_t U[NUM_GROUPS];

/* Group B — written before threads spawn, read by all threads (safe read) */
static int B[BARRIER_ARRAY];

/* A shared log array — every thread appends (classic racy append) */
#define LOG_SIZE (NUM_THREADS * ITERATIONS)
static volatile int log_buf[LOG_SIZE];
static volatile int log_head;   /* racy: no atomic                         */

/* ======================================================= worker =========  */
typedef struct { int tid; } arg_t;

static void *worker(void *varg)
{
    arg_t *a  = (arg_t *)varg;
    int    id = a->tid;

    for (int iter = 0; iter < ITERATIONS; ++iter) {

        int g = (id + iter) % NUM_GROUPS;   /* rotate through groups       */

        /* ============================================================
         * GROUP P — protected, no race
         * ============================================================ */
        {
            prot_group_t *pg = &P[g];
            pthread_mutex_lock(&pg->lock);
            pg->counter++;
            for (int i = 0; i < GROUP_SIZE; ++i)
                pg->data[i] += id;
            pthread_mutex_unlock(&pg->lock);
        }

        /* ============================================================
         * GROUP U — unprotected, races on counter and data[]
         * ============================================================ */
        {
            unprot_group_t *ug = &U[g];
            ug->counter++;                       /* racy RMW               */
            for (int i = 0; i < GROUP_SIZE; ++i)
                ug->data[i] += id;               /* racy RMW               */
        }

        /* ============================================================
         * GROUP B — read-only, safe (written before spawn)
         * ============================================================ */
        volatile long b_sum = 0;
        for (int i = 0; i < BARRIER_ARRAY; ++i)
            b_sum += B[i];                       /* safe read-only          */
        (void)b_sum;

        /* ============================================================
         * Racy log append — classic race on log_head
         * ============================================================ */
        int pos = log_head;                      /* racy read               */
        if (pos < LOG_SIZE) {
            log_buf[pos] = id * 10000 + iter;   /* racy write to slot      */
            log_head = pos + 1;                  /* racy write (lost update)*/
        }
    }

    return NULL;
}

/* ================================================================ main === */
int main(void)
{
    pthread_t threads[NUM_THREADS];
    arg_t     args[NUM_THREADS];

    /* initialise Group P */
    for (int g = 0; g < NUM_GROUPS; ++g) {
        pthread_mutex_init(&P[g].lock, NULL);
        P[g].counter = 0;
        memset(P[g].data, 0, sizeof(P[g].data));
    }

    /* initialise Group U */
    for (int g = 0; g < NUM_GROUPS; ++g) {
        U[g].counter = 0;
        memset(U[g].data, 0, sizeof(U[g].data));
    }

    /* initialise Group B — write before spawn (happens-before) */
    for (int i = 0; i < BARRIER_ARRAY; ++i)
        B[i] = i * 7 + 3;

    memset((void*)log_buf, 0, sizeof(log_buf));
    log_head = 0;

    printf("[B6] Protected-vs-unprotected benchmark: %d threads, %d iters\n",
           NUM_THREADS, ITERATIONS);
    printf("     Groups P[%d] (mutex-protected, safe)\n", NUM_GROUPS);
    printf("     Groups U[%d] (unprotected, racy)\n", NUM_GROUPS);
    printf("     B[%d] (pre-spawn write, read-only in threads, safe)\n",
           BARRIER_ARRAY);

    for (int t = 0; t < NUM_THREADS; ++t) {
        args[t].tid = t;
        pthread_create(&threads[t], NULL, worker, &args[t]);
    }
    for (int t = 0; t < NUM_THREADS; ++t)
        pthread_join(threads[t], NULL);

    long p_total = 0, u_total = 0;
    for (int g = 0; g < NUM_GROUPS; ++g) {
        p_total += P[g].counter;
        u_total += U[g].counter;
    }
    printf("[B6] Done. P.counter_sum=%ld (det: %d), U.counter_sum=%ld (non-det)\n",
           p_total, NUM_THREADS * ITERATIONS, u_total);

    for (int g = 0; g < NUM_GROUPS; ++g)
        pthread_mutex_destroy(&P[g].lock);
    return 0;
}

/*
 * BUILD
 * -----
 * gcc -O1 -pthread bench6_protected_vs_unprotected.c -o b6 && ./b6
 * gcc -O1 -pthread -fsanitize=thread bench6_protected_vs_unprotected.c -o b6_tsan
 *
 * EXPECTED RACE REPORT SITES
 * ---------------------------
 *   U[*].counter     — RMW race (all groups, every iter)
 *   U[*].data[*]     — RMW race (all groups, all indices)
 *   log_head         — lost-update race
 *   log_buf[pos]     — race between write and concurrent overlapping write
 *
 * EXPECTED RACE-FREE SITES
 * ------------------------
 *   P[*].counter     — protected by mutex
 *   P[*].data[*]     — protected by mutex
 *   B[*]             — written before any thread spawned (happens-before)
 */
