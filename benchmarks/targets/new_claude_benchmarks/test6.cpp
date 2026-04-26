/*
 * BENCHMARK 3: MIXED SHARING — PARTIAL RACES, SOME PRIVATE SOME SHARED
 * ======================================================================
 * Sharing profile  : MIXED — some variables shared (racy), most private (safe)
 * Races present    : YES — only on the explicitly shared subset
 * Instrumentation  : Sharing analysis must instrument ONLY the shared subset;
 *                    private variables must be left uninstrumented
 *
 * This is the PRECISION benchmark.  A coarse detector that instruments
 * everything will pass B1 and B2 trivially; this benchmark exposes whether
 * the sharing analysis can correctly partition a mixed workload.
 *
 * Layout
 * ------
 *   shared_globals[]   — 4 truly shared ints → races expected
 *   sync_flags[]       — shared flags (WW race)
 *   shared_counters[]  — NUM_SHARED_CTR counters shared among all threads
 *   private_partition  — each thread owns its exclusive stripe → no race
 *   local stack work   — purely local → no race
 *
 * A correct sharing analysis will instrument only the shared_* variables
 * and leave the private_partition and stack work untouched.
 *
 * What to measure
 * ---------------
 *   1. Instrumentation coverage on shared vars  → HIGH (≈ 100 %)
 *   2. Instrumentation coverage on private vars → LOW  (≈ 0 %)
 *   3. Races detected                           → exactly on shared vars
 *   4. False positives on private vars          → ZERO
 *   5. False negatives on shared vars           → ZERO
 */

#define _GNU_SOURCE
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* ======================================================= configuration === */
#define NUM_THREADS         8
#define NUM_SHARED_GLOBALS  4     /* explicitly shared scalars               */
#define NUM_SHARED_CTR     16     /* shared counters (all threads write all) */
#define NUM_SHARED_FLAGS    8     /* flag array — WW races                   */
#define PRIVATE_STRIPE    512     /* ints per thread in private partition    */
#define STACK_DEPTH       128
#define ITERATIONS        2000

/* ======================================================= shared globals === */

/* SHARED — races expected here */
static volatile int  shared_globals[NUM_SHARED_GLOBALS];
static volatile long shared_counters[NUM_SHARED_CTR];
static volatile int  shared_flags[NUM_SHARED_FLAGS];
static long          shared_hot;      /* single hot scalar, max contention   */

/* PRIVATE — no races, should NOT be instrumented */
static int private_partition[NUM_THREADS * PRIVATE_STRIPE];
static long results[NUM_THREADS];     /* written post-join only              */

/* ======================================================= worker thread === */
typedef struct { int tid; } arg_t;

/*
 * Each iteration of the worker:
 *   1. Touches shared_globals, shared_counters, shared_flags, shared_hot
 *      → all racy, all should be instrumented
 *   2. Touches its own private stripe and local stack buffers
 *      → not racy, should NOT be instrumented
 */
static void *worker(void *varg)
{
    arg_t *a  = (arg_t *)varg;
    int    id = a->tid;

    /* private stripe */
    int *stripe = private_partition + id * PRIVATE_STRIPE;

    for (int iter = 0; iter < ITERATIONS; ++iter) {

        /* ============================================================
         * SHARED REGION (racy) — detector must instrument ALL of these
         * ============================================================ */

        /* shared_globals: every thread reads and writes every index */
        for (int g = 0; g < NUM_SHARED_GLOBALS; ++g) {
            int v = shared_globals[g];          /* racy read              */
            shared_globals[g] = v + id;         /* racy write             */
        }

        /* shared_counters: lost-update races on each */
        for (int c = 0; c < NUM_SHARED_CTR; ++c) {
            shared_counters[c]++;               /* racy RMW               */
        }

        /* shared_flags: WW race — all threads overwrite */
        for (int f = 0; f < NUM_SHARED_FLAGS; ++f) {
            shared_flags[f] = (id + iter) & 0xFF;  /* racy write          */
        }

        /* single hot scalar */
        shared_hot += id;                       /* racy RMW               */

        /* ============================================================
         * PRIVATE REGION (race-free) — detector must NOT instrument these
         * ============================================================ */

        /* private stripe — exclusive to this thread */
        for (int i = 0; i < PRIVATE_STRIPE; ++i)
            stripe[i] = stripe[i] * (id + 1) + iter;

        /* stack-local computation */
        int  local_buf[STACK_DEPTH];
        long local_sum = 0;
        for (int i = 0; i < STACK_DEPTH; ++i) {
            local_buf[i] = id * STACK_DEPTH + i + iter;
            local_sum   += local_buf[i];
        }
        /* prevent dead-code elimination */
        if (local_sum == 0) stripe[0] = 1;
    }

    results[id] = shared_counters[id % NUM_SHARED_CTR]; /* post-join write */
    return NULL;
}

/* ================================================================ main === */
int main(void)
{
    pthread_t threads[NUM_THREADS];
    arg_t     args[NUM_THREADS];

    memset((void*)shared_globals,  0, sizeof(shared_globals));
    memset((void*)shared_counters, 0, sizeof(shared_counters));
    memset((void*)shared_flags,    0, sizeof(shared_flags));
    memset(private_partition,      0, sizeof(private_partition));
    shared_hot = 0;

    printf("[B3] Mixed-sharing benchmark: %d threads, %d iters\n",
           NUM_THREADS, ITERATIONS);
    printf("     Shared  (racy): globals[%d], counters[%d], flags[%d], hot\n",
           NUM_SHARED_GLOBALS, NUM_SHARED_CTR, NUM_SHARED_FLAGS);
    printf("     Private (safe): stripe[%d], stack[%d]\n",
           PRIVATE_STRIPE, STACK_DEPTH);

    for (int t = 0; t < NUM_THREADS; ++t) {
        args[t].tid = t;
        pthread_create(&threads[t], NULL, worker, &args[t]);
    }
    for (int t = 0; t < NUM_THREADS; ++t)
        pthread_join(threads[t], NULL);

    printf("[B3] Done. shared_hot=%ld (non-deterministic)\n", shared_hot);
    return 0;
}

/*
 * BUILD
 * -----
 * gcc -O1 -pthread bench3_mixed_sharing.c -o b3 && ./b3
 * gcc -O1 -pthread -fsanitize=thread bench3_mixed_sharing.c -o b3_tsan
 *
 * PRECISION EVALUATION
 * --------------------
 * For each variable, record:
 *   (a) Was it instrumented?
 *   (b) Was a race reported on it?
 *
 *   Variable          Expected instrumented?  Expected race?
 *   ─────────────────────────────────────────────────────────
 *   shared_globals[]  YES                     YES
 *   shared_counters[] YES                     YES
 *   shared_flags[]    YES                     YES
 *   shared_hot        YES                     YES
 *   private_partition NO                      NO
 *   local stack       NO                      NO
 *   results[]         NO (written post-join)  NO
 *
 * Any deviation from this table indicates a precision or soundness bug.
 */
