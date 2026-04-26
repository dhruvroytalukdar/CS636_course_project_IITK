/*
 * TESTBENCH 2: NO MEMORY SHARING
 * ================================
 * Purpose : Verify that the race detector's sharing analysis correctly proves
 *           the absence of sharing and skips instrumentation, keeping overhead
 *           near zero.
 *
 * Pattern : A large buffer is statically partitioned so that each thread owns
 *           an exclusive, non-overlapping stripe.  No thread ever reads or
 *           writes another thread's stripe.
 *
 * Expected detector behaviour:
 *   - Sharing analysis proves each stripe is thread-private
 *   - Zero (or near-zero) loads/stores are instrumented
 *   - Zero race reports are emitted
 *   - Runtime overhead ≈ 0 % (nothing to instrument)
 */

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* ------------------------------------------------------------------ config */
#define NUM_THREADS    8
#define STRIPE_SIZE  4096    /* elements owned exclusively by one thread     */
#define TOTAL_SIZE   (NUM_THREADS * STRIPE_SIZE)
#define ITERATIONS   1000

/* ------------------------------------------------------------------ shared */
/*
 * The array lives in shared address space, but sharing ANALYSIS should
 * determine that thread t only ever accesses indices [t*STRIPE_SIZE,
 * (t+1)*STRIPE_SIZE), so the stripes are effectively thread-private.
 */
static int buffer[TOTAL_SIZE];

/* ----------------------------------------------------------------- helpers */
typedef struct {
    int  tid;
    int *stripe;      /* points to buffer[tid * STRIPE_SIZE]                */
    int  len;
} thread_arg_t;

/*
 * Each thread works exclusively on its own stripe:
 *   write stripe[i] = ...   (private store — no race)
 *   read  stripe[i]         (private load  — no race)
 *
 * Pointer arithmetic stays within [stripe, stripe+len).
 * A sound sharing analysis can verify this statically or at first access.
 */
static void *worker(void *arg)
{
    thread_arg_t *a = (thread_arg_t *)arg;
    int *s   = a->stripe;
    int  len = a->len;
    int  tid = a->tid;

    for (int iter = 0; iter < ITERATIONS; ++iter) {
        /* Phase 1 – write-only pass (private stores) */
        for (int i = 0; i < len; ++i)
            s[i] = tid * len + i + iter;   /* no other thread touches s[i]  */

        /* Phase 2 – read-write pass (private loads + stores) */
        for (int i = 1; i < len; ++i)
            s[i] += s[i - 1];              /* still private                  */

        /* Phase 3 – read-only pass (private loads) */
        volatile long acc = 0;
        for (int i = 0; i < len; ++i)
            acc += s[i];
        (void)acc;
    }
    return NULL;
}

/* ------------------------------------------------------------------- main */
int main(void)
{
    pthread_t    threads[NUM_THREADS];
    thread_arg_t args[NUM_THREADS];

    printf("[TB2] No-sharing testbench starting (%d threads, stripe=%d elems)\n",
           NUM_THREADS, STRIPE_SIZE);

    memset(buffer, 0, sizeof(buffer));

    for (int t = 0; t < NUM_THREADS; ++t) {
        args[t].tid    = t;
        args[t].stripe = buffer + t * STRIPE_SIZE;  /* exclusive partition   */
        args[t].len    = STRIPE_SIZE;
        pthread_create(&threads[t], NULL, worker, &args[t]);
    }

    for (int t = 0; t < NUM_THREADS; ++t)
        pthread_join(threads[t], NULL);

    /* Verify determinism — each stripe's last element is predictable */
    int ok = 1;
    for (int t = 0; t < NUM_THREADS; ++t) {
        int *s = buffer + t * STRIPE_SIZE;
        if (s[0] == 0 && s[STRIPE_SIZE - 1] == 0) { ok = 0; break; }
    }
    printf("[TB2] Done. Sanity check: %s\n", ok ? "PASS" : "FAIL");
    return 0;
}

/*
 * HOW TO BUILD & RUN
 * ------------------
 * Without detector (baseline):
 *   gcc -O1 -pthread no_sharing.c -o no_sharing && ./no_sharing
 *
 * With ThreadSanitizer (reference — should report zero races):
 *   gcc -O1 -pthread -fsanitize=thread no_sharing.c -o no_sharing_tsan
 *   ./no_sharing_tsan
 *
 * With your custom detector:
 *   gcc -O1 -pthread -finstrument-your-detector no_sharing.c -o no_sharing_det
 *   ./no_sharing_det
 *
 * WHAT TO MEASURE
 * ---------------
 * 1. Fraction of loads/stores instrumented  → should be LOW (≈ 0 %)
 *                                             if sharing analysis works
 * 2. Number of race reports                 → ZERO
 * 3. False-positive rate                    → ZERO
 * 4. Runtime overhead vs baseline           → should be NEAR ZERO
 *                                             (the whole point of sharing analysis)
 *
 * OPTIONAL VARIANTS TO TEST SHARING ANALYSIS PRECISION
 * ------------------------------------------------------
 * A. Add a harmless read of a neighbour's stripe AFTER join() — not a race,
 *    but may confuse imprecise analyses into marking the whole buffer shared.
 *
 * B. Use malloc() instead of a static array — tests heap alias analysis.
 *
 * C. Pass pointers through a void* argument chain — tests pointer analysis
 *    depth (the analysis must see through the cast to recover the stripe).
 *
 * D. Add a single intentional race on one element outside the stripes —
 *    the detector must still catch that one while ignoring the private stripes.
 */
