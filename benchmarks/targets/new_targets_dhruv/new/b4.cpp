/*
 * O1_BENCH_4: HEAP + COMPUTED INDICES — DEFEATS SROA AND SCALAR PROMOTION
 * =========================================================================
 * Problem: SROA (Scalar Replacement of Aggregates) at -O1 can break up
 * stack arrays with static indices into individual scalars, then mem2reg
 * promotes those scalars to registers → loads/stores disappear.
 *
 * Solution: Use heap-allocated buffers accessed with runtime-computed
 * indices. The compiler cannot statically enumerate which elements are
 * accessed, so it cannot apply SROA or scalar promotion. Every access
 * remains a real load/store instruction in the IR.
 *
 * Techniques used:
 *   1. malloc() buffers — heap, no SROA possible
 *   2. Indices computed from thread-id, iteration, and runtime hash
 *   3. Indirect function calls (function pointer) — compiler can't inline
 *   4. "Index poisoning" — each index depends on previous memory read
 *      (data-dependent chain forces all loads to be kept)
 *
 * Expected IR load/store count at -O1:
 *   process_row():    N loads + N stores per call
 *   scatter_update(): M loads + M stores (random-access pattern)
 *   chain_reads():    depth loads (pointer chasing)
 *   Total:           400-600 per thread per iteration
 *
 * Escape analysis opportunity:
 *   priv_buf: allocated per-thread in worker(), pointer never stored in
 *             a global or passed to another thread → PROVABLY LOCAL.
 *             Your pass should skip all loads/stores to priv_buf.
 *   shared_heap[]: global pointer → shared → must instrument.
 */

#define _GNU_SOURCE
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM_THREADS   8
#define SHARED_SIZE 512   /* elements in shared heap buffer                  */
#define PRIV_SIZE   256   /* elements in per-thread private heap buffer      */
#define ROW_LEN      64   /* elements per processing row                     */
#define ITERATIONS  300

/* ---- shared heap --------------------------------------------------------- */
static int  *shared_heap;          /* [SHARED_SIZE] — all threads touch this */
static long *shared_longs;         /* [SHARED_SIZE] — for wide-load pattern  */
static volatile long global_acc;

/* ---- simple runtime hash to prevent constant-index optimisation ---------- */
static inline int rhash(int a, int b) { return (a * 2654435761u) ^ (b * 40503u); }

/* ---- noinline processing functions --------------------------------------- */

/*
 * Reads len elements starting at buf[start], writes results to buf[start+half].
 * Both start and len are runtime values → no index folding possible.
 * Generates: len loads + len/2 stores (minimum) = 96 + 32 = 128 load/stores
 */
__attribute__((noinline))
static void process_row(int *buf, int start, int len, int tid)
{
    int half = len / 2;
    for (int i = 0; i < half; ++i) {
        int a = buf[start + i];           /* load                           */
        int b = buf[start + half + i];    /* load                           */
        buf[start + i]        = a + b + tid;   /* store                    */
        buf[start + half + i] = a - b + tid;   /* store                    */
    }
}

/*
 * Scatter-update: indices computed from a hash → runtime indices → no SROA.
 * Generates: count × 2 loads + count stores = 3×count load/stores
 */
__attribute__((noinline))
static void scatter_update(int *buf, int buf_size, int count, int seed)
{
    for (int i = 0; i < count; ++i) {
        int idx_a = abs(rhash(seed, i))     % buf_size;
        int idx_b = abs(rhash(seed, i + 1)) % buf_size;
        int va = buf[idx_a];               /* load                          */
        int vb = buf[idx_b];               /* load                          */
        buf[idx_a] = va + vb;             /* store                          */
    }
}

/*
 * Chain of data-dependent loads: each index computed from the previous value.
 * The compiler CANNOT reorder or hoist these — each load depends on the last.
 * Generates: depth loads + 1 store
 */
__attribute__((noinline))
static long chain_reads(const int *buf, int buf_size, int start, int depth)
{
    int idx = start % buf_size;
    long acc = 0;
    for (int d = 0; d < depth; ++d) {
        int v = buf[idx];                  /* data-dependent load            */
        acc  += v;
        idx   = (idx + v + d) % buf_size; /* next index depends on loaded v */
    }
    return acc;
}

/*
 * Wide-stride reads on long[] — each read is 8 bytes, different cache line.
 * Generates: count loads + count stores (no vectorisation without hints)
 */
__attribute__((noinline))
static void wide_stride_rw(long *buf, int buf_size, int stride, int tid)
{
    for (int i = 0; i + stride < buf_size; i += stride) {
        long v   = buf[i];                 /* load                          */
        buf[i]   = v ^ (long)tid;         /* store                         */
    }
}

/* ---- indirect call via function pointer — prevents inlining -------------- */
typedef void (*row_fn_t)(int *, int, int, int);

/* ---- worker --------------------------------------------------------------- */
typedef struct { int tid; } arg_t;

static void *worker(void *varg)
{
    arg_t *a  = (arg_t *)varg;
    int    id = a->tid;

    /*
     * PRIVATE heap buffer — allocated here, pointer never stored globally,
     * never passed to another thread.  Your escape analysis should prove
     * priv_buf does NOT escape the current thread.
     * All load/stores to priv_buf should be SKIPPED by your pass.
     */
    int  *priv_buf = (int *)calloc(PRIV_SIZE, sizeof(int));
    long *priv_lng = (long*)calloc(PRIV_SIZE, sizeof(long));

    /* Indirect call: can't be inlined → compiler must materialise args      */
    row_fn_t fn = process_row;

    for (int iter = 0; iter < ITERATIONS; ++iter) {

        int seed = rhash(id, iter);

        /* --- SHARED heap: must be instrumented ----------------------------- */

        /* process_row on shared_heap: 128 load/stores (via function pointer) */
        int row_start = (seed % (SHARED_SIZE - ROW_LEN));
        if (row_start < 0) row_start = 0;
        fn(shared_heap, row_start, ROW_LEN, id);

        /* scatter_update on shared_heap: 3×32=96 load/stores               */
        scatter_update(shared_heap, SHARED_SIZE, 32, seed);

        /* chain_reads on shared_heap: 64 data-dependent loads               */
        long cr = chain_reads(shared_heap, SHARED_SIZE, seed & 0xFF, 64);

        /* wide_stride_rw on shared_longs: SHARED_SIZE/4 loads+stores        */
        wide_stride_rw(shared_longs, SHARED_SIZE, 4, id);

        /* global scalar: racy                                               */
        global_acc += cr;

        /* --- PRIVATE heap: should be skipped by your pass ----------------- */

        /* Same operations on priv_buf — same instruction count, but         */
        /* priv_buf provably doesn't escape → skip instrumentation           */
        fn(priv_buf, 0, PRIV_SIZE / 2, id);
        scatter_update(priv_buf, PRIV_SIZE, 16, seed);
        long pr = chain_reads(priv_buf, PRIV_SIZE, seed & 0x7F, 32);
        wide_stride_rw(priv_lng, PRIV_SIZE, 2, id);
        (void)pr;
    }

    free(priv_buf);
    free(priv_lng);
    return NULL;
}

int main(void)
{
    pthread_t threads[NUM_THREADS];
    arg_t     args[NUM_THREADS];

    shared_heap  = (int  *)calloc(SHARED_SIZE, sizeof(int));
    shared_longs = (long *)calloc(SHARED_SIZE, sizeof(long));
    if (!shared_heap || !shared_longs) { perror("calloc"); return 1; }
    global_acc = 0;

    printf("[O1B4] Heap+computed-index benchmark: %d threads x %d iters\n",
           NUM_THREADS, ITERATIONS);
    printf("       Per-iter shared load/stores: ~400 (must instrument)\n");
    printf("       Per-iter private load/stores: ~200 (your pass can skip)\n");

    for (int t = 0; t < NUM_THREADS; ++t) {
        args[t].tid = t;
        pthread_create(&threads[t], NULL, worker, &args[t]);
    }
    for (int t = 0; t < NUM_THREADS; ++t)
        pthread_join(threads[t], NULL);

    printf("[O1B4] Done. global_acc=%ld\n", global_acc);
    free(shared_heap);
    free(shared_longs);
    return 0;
}

/*
 * BUILD & CHECK IR
 * ----------------
 * clang -O1 -pthread -S -emit-llvm o1_bench4_heap_indices.c -o o1b4.ll
 * grep -c "load\|store" o1b4.ll
 * # Expected: 300+ in process_row, scatter_update, chain_reads, wide_stride_rw
 *
 * KEY ESCAPE ANALYSIS TEST
 * ------------------------
 * In worker():
 *   priv_buf = calloc(...)   ← allocation site A
 *   fn(priv_buf, ...)        ← passed to process_row via function pointer
 *   scatter_update(priv_buf, ...) ← passed to noinline function
 *
 * Does priv_buf escape?
 *   - Conservative answer: YES (address passed to function calls)
 *   - Precise answer:      NO  (callees don't store ptr in globals/other threads)
 *
 * Track what fraction of the ~200 private load/stores your pass skips.
 * Target: >80% skip rate on priv_buf accesses.
 *
 * The chain_reads() function creates data-dependent load chains that are
 * particularly good for measuring instrumentation overhead: each load
 * has a true dependency on the previous, so the overhead of instrumentation
 * directly adds to the critical path latency.
 */
