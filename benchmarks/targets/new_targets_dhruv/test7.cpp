/*
 * BENCHMARK 2: NO SHARING — MANY VARIABLES, ALL PRIVATE, ZERO RACES
 * ===================================================================
 * Sharing profile  : NONE — every variable is exclusively owned by one thread
 * Races present    : NONE
 * Instrumentation  : Sharing analysis should instrument ≈ 0 % of loads/stores
 *
 * This is the "efficiency" benchmark.  The detector must prove that despite
 * a large working set (scalars, arrays, structs, heap, TLS), no location is
 * ever accessed by more than one thread.  If sharing analysis works correctly,
 * runtime overhead should be indistinguishable from an uninstrumented binary.
 *
 * Variable categories tested
 * --------------------------
 *   A. Thread-local storage (__thread)  — trivially private
 *   B. Stack-allocated arrays           — trivially private
 *   C. Statically partitioned global    — requires index-range analysis
 *   D. Per-thread heap allocations      — requires allocation-site analysis
 *   E. Struct arrays, one per thread    — requires alias analysis on pointer
 *   F. Private accumulator / reduction  — local var, result written post-join
 *
 * What to measure
 * ---------------
 *   1. Instrumentation coverage  → should be LOW (≈ 0 %)
 *   2. Races detected            → ZERO (any report is a false positive)
 *   3. Runtime overhead          → should be NEAR ZERO
 */

#define _GNU_SOURCE
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* ======================================================= configuration === */
#define NUM_THREADS       8
#define STRIPE_INTS    1024   /* ints per thread in the global partition    */
#define HEAP_PER_THREAD  512
#define STACK_INTS       256
#define ITERATIONS      2000
#define NUM_STRUCTS       64   /* structs per thread                        */

/* ======================================================= shared globals === */

/* Category C: statically partitioned global — thread t owns [t*STRIPE, (t+1)*STRIPE) */
static int global_partition[NUM_THREADS * STRIPE_INTS];

/* Post-join result array: only written after all threads finish */
static long results[NUM_THREADS];

/* ======================================================= per-thread data = */

/* Category A: thread-local scalars */
static __thread long   tls_counter;
static __thread int    tls_flag;
static __thread double tls_accumulator;

/* Category E: struct with several fields */
typedef struct {
    int    data[16];
    long   sum;
    int    version;
    double avg;
} record_t;

/* each thread gets its own block of structs (via heap, see worker) */

/* ================================================================ worker == */
typedef struct {
    int   tid;
    int  *heap;          /* per-thread heap buffer (Category D)            */
    record_t *recs;      /* per-thread struct array (Category E)           */
} arg_t;

static void *worker(void *varg)
{
    arg_t *a  = (arg_t *)varg;
    int    id = a->tid;

    /* Category B: stack arrays — unambiguously private */
    int  stack_arr[STACK_INTS];
    long stack_sums[STACK_INTS / 8];
    memset(stack_arr,  0, sizeof(stack_arr));
    memset(stack_sums, 0, sizeof(stack_sums));

    /* Category A: TLS reset */
    tls_counter     = 0;
    tls_flag        = 0;
    tls_accumulator = 0.0;

    /* pointer to this thread's exclusive stripe */
    int *stripe = global_partition + id * STRIPE_INTS;   /* Category C     */

    for (int iter = 0; iter < ITERATIONS; ++iter) {

        /* --- A: TLS ------------------------------------------------------ */
        tls_counter++;
        tls_flag        = iter & 1;
        tls_accumulator += (double)iter * 0.001;

        /* --- B: stack array ---------------------------------------------- */
        for (int i = 0; i < STACK_INTS; ++i)
            stack_arr[i] = id * STACK_INTS + i + iter;

        for (int i = 0; i < STACK_INTS / 8; ++i) {
            long s = 0;
            for (int j = 0; j < 8; ++j)
                s += stack_arr[i * 8 + j];
            stack_sums[i] = s;
        }

        /* --- C: exclusive stripe of global array ------------------------- */
        for (int i = 0; i < STRIPE_INTS; ++i)
            stripe[i] = stripe[i] * (id + 1) + iter;

        /* reduce stripe into a local sum */
        long stripe_sum = 0;
        for (int i = 0; i < STRIPE_INTS; ++i)
            stripe_sum += stripe[i];

        /* --- D: per-thread heap ------------------------------------------ */
        for (int i = 0; i < HEAP_PER_THREAD; ++i)
            a->heap[i] += id + iter;

        long heap_sum = 0;
        for (int i = 0; i < HEAP_PER_THREAD; ++i)
            heap_sum += a->heap[i];

        /* --- E: per-thread struct array ---------------------------------- */
        for (int r = 0; r < NUM_STRUCTS; ++r) {
            record_t *rec = &a->recs[r];
            rec->version++;
            long s = 0;
            for (int f = 0; f < 16; ++f) {
                rec->data[f] = id * 16 + f + iter;
                s += rec->data[f];
            }
            rec->sum = s;
            rec->avg = (double)s / 16.0;
        }

        /* --- F: local accumulator (private reduction) ------------------- */
        (void)stack_sums[0];   /* use stack_sums to prevent dead-code elim */
        (void)stripe_sum;
        (void)heap_sum;
    }

    /* Write final result — only after all work done, array index is private */
    results[id] = tls_counter;   /* safe: each thread writes its own slot  */
    return NULL;
}

/* ================================================================ main === */
int main(void)
{
    pthread_t threads[NUM_THREADS];
    arg_t     args[NUM_THREADS];

    /* initialise shared partition */
    memset(global_partition, 0, sizeof(global_partition));
    memset(results, 0, sizeof(results));

    /* allocate per-thread heap and struct arrays BEFORE spawning */
    for (int t = 0; t < NUM_THREADS; ++t) {
        args[t].tid  = t;
        args[t].heap = (int *)calloc(HEAP_PER_THREAD, sizeof(int));
        args[t].recs = (record_t *)calloc(NUM_STRUCTS, sizeof(record_t));
        if (!args[t].heap || !args[t].recs) { perror("calloc"); return 1; }
    }

    printf("[B2] No-sharing benchmark: %d threads, %d iters\n",
           NUM_THREADS, ITERATIONS);
    printf("     Private regions: TLS, stack[%d], stripe[%d], "
           "heap[%d], structs[%d]\n",
           STACK_INTS, STRIPE_INTS, HEAP_PER_THREAD, NUM_STRUCTS);

    for (int t = 0; t < NUM_THREADS; ++t)
        pthread_create(&threads[t], NULL, worker, &args[t]);

    for (int t = 0; t < NUM_THREADS; ++t)
        pthread_join(threads[t], NULL);

    /* Post-join: single-threaded read of results[] — no race */
    long total = 0;
    for (int t = 0; t < NUM_THREADS; ++t) total += results[t];
    printf("[B2] Done. sum of TLS counters = %ld (deterministic: %d)\n",
           total, NUM_THREADS * ITERATIONS);

    for (int t = 0; t < NUM_THREADS; ++t) {
        free(args[t].heap);
        free(args[t].recs);
    }
    return 0;
}

/*
 * BUILD
 * -----
 * gcc -O1 -pthread bench2_no_sharing.c -o b2 && ./b2
 * gcc -O1 -pthread -fsanitize=thread bench2_no_sharing.c -o b2_tsan
 *   (TSan should report zero races)
 *
 * SHARING-ANALYSIS DIFFICULTY LADDER
 * ------------------------------------
 *  EASY   : __thread TLS, local stack vars — trivially private
 *  MEDIUM : global_partition[id*N .. (id+1)*N) — needs range/offset analysis
 *  HARD   : per-thread heap (args[t].heap) — needs allocation-site analysis
 *  HARDER : struct pointer passed through void* — needs pointer alias analysis
 *
 * DETECTOR CHECKLIST
 * ------------------
 *  [ ] Zero race reports after run?
 *  [ ] Instrumentation rate ≈ 0% for stripe/heap/struct accesses?
 *  [ ] TLS accesses not instrumented?
 *  [ ] Stack arrays not instrumented?
 *  [ ] results[] only written post-join — no false positive?
 */
