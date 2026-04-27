/*
 * TESTBENCH 1: HIGH MEMORY SHARING
 * =================================
 * Purpose : Stress-test the race detector with maximum cross-thread sharing.
 *           Sharing analysis should flag MOST loads/stores for instrumentation.
 *
 * Pattern : A single shared array is read and written by every thread with no
 *           synchronisation, producing true data races on every element.
 *
 * Expected detector behaviour:
 *   - Sharing analysis marks the entire `shared[]` array as "shared"
 *   - Nearly every load/store is instrumented
 *   - Multiple data-race reports are emitted (one per racy access pair)
 */

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

/* ------------------------------------------------------------------ config */
#define NUM_THREADS   8
#define ARRAY_SIZE  256      /* all threads touch the same 256 elements      */
#define ITERATIONS  1000     /* repeat to amplify the race window            */

/* ------------------------------------------------------------------ shared */
/* This is the "hot" region — every thread reads AND writes every element.   */
static int shared[ARRAY_SIZE];   /* <-- sharing analysis must mark this hot  */

/* ----------------------------------------------------------------- helpers */
typedef struct { int tid; } thread_arg_t;

/* Each thread performs:
 *   read  shared[i]          (racy load  — no lock)
 *   write shared[i] = ...    (racy store — no lock)
 *
 * Because there is no synchronisation the detector should report races on
 * every element for every pair of threads.
 */
static void *worker(void *arg)
{
    thread_arg_t *a = (thread_arg_t *)arg;
    int tid = a->tid;

    for (int iter = 0; iter < ITERATIONS; ++iter) {
        for (int i = 0; i < ARRAY_SIZE; ++i) {
            /* intentional racy read ↓ */
            int v = shared[i];

            /* intentional racy write ↓  (depends on all other threads' writes) */
            shared[i] = v + tid;
        }
    }
    return NULL;
}

/* ------------------------------------------------------------------- main */
int main(void)
{
    pthread_t threads[NUM_THREADS];
    thread_arg_t args[NUM_THREADS];

    printf("[TB1] High-sharing testbench starting (%d threads, %d-element array)\n",
           NUM_THREADS, ARRAY_SIZE);

    /* No barrier / no initialisation lock — races start immediately */
    for (int i = 0; i < ARRAY_SIZE; ++i)
        shared[i] = 0;

    for (int t = 0; t < NUM_THREADS; ++t) {
        args[t].tid = t;
        pthread_create(&threads[t], NULL, worker, &args[t]);
    }

    for (int t = 0; t < NUM_THREADS; ++t)
        pthread_join(threads[t], NULL);

    printf("[TB1] Done. Final shared[0] = %d (value is non-deterministic)\n",
           shared[0]);
    return 0;
}

/*
 * HOW TO BUILD & RUN
 * ------------------
 * Without detector (baseline):
 *   gcc -O1 -pthread high_sharing.c -o high_sharing && ./high_sharing
 *
 * With ThreadSanitizer (reference):
 *   gcc -O1 -pthread -fsanitize=thread high_sharing.c -o high_sharing_tsan
 *   ./high_sharing_tsan
 *
 * With your custom detector (substitute your own flags):
 *   gcc -O1 -pthread -finstrument-your-detector high_sharing.c -o high_sharing_det
 *   ./high_sharing_det
 *
 * WHAT TO MEASURE
 * ---------------
 * 1. Fraction of loads/stores instrumented  → should be HIGH (≈ 100 %)
 * 2. Number of race reports                 → should be MANY
 * 3. False-negative rate                    → should be ZERO
 * 4. Runtime overhead vs baseline           → expected HIGH (everything is shared)
 */
