/*
 * O1_BENCH_1: VOLATILE SHARED STATE — FORCES 100s OF LOADS/STORES AT -O1
 * ========================================================================
 * Problem addressed: at -O1, clang's mem2reg + scalar promotion eliminates
 * most loads/stores on local variables, leaving your pass with very little
 * to analyse.
 *
 * Solution: volatile keyword forces the compiler to materialise every single
 * read and write as an actual load/store instruction — the optimizer is
 * PROHIBITED from eliminating or combining volatile accesses.
 *
 * Expected IR load/store count at -O1: 400-600 per thread invocation
 *   - 16 counters × 2 (read+write) × UNROLL factor
 *   - 32-element status array × 2 per iter
 *   - 8 shared scalars × 2 per access
 *
 * Escape analysis note: all these are globals — they trivially escape.
 * Your pass should see ALL of them as candidates and be able to skip
 * only the genuinely private ones (none here — everything is shared).
 */

#define _GNU_SOURCE
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM_THREADS    8
#define ITERATIONS  2000

/* ---- volatile globals: every access becomes a load or store in IR ------- */

/* 16 independent counters — each read+write = 2 load/stores per counter    */
static volatile long   cnt[16];

/* 32-element status array — index computed at runtime, no promotion         */
static volatile int    status[32];

/* 8 shared scalars of mixed types */
static volatile int    g_int_a,  g_int_b,  g_int_c,  g_int_d;
static volatile long   g_long_a, g_long_b;
static volatile float  g_float_a;
static volatile double g_double_a;

/* a 2D volatile matrix — row × col both runtime-computed */
#define ROWS 8
#define COLS 16
static volatile int    matrix[ROWS][COLS];

/* ---- noinline helper: forces reload of all globals around call site ------ */
__attribute__((noinline))
static void touch_globals(int tid, int iter)
{
    /* Each line below is 1 load + 1 store = 2 load/store instructions      */
    cnt[0]  = cnt[0]  + tid;
    cnt[1]  = cnt[1]  + iter;
    cnt[2]  = cnt[2]  ^ tid;
    cnt[3]  = cnt[3]  + (tid * iter);
    cnt[4]  = cnt[4]  - tid;
    cnt[5]  = cnt[5]  | (long)iter;
    cnt[6]  = cnt[6]  + tid + iter;
    cnt[7]  = cnt[7]  & ~(long)tid;
    cnt[8]  = cnt[8]  + 1;
    cnt[9]  = cnt[9]  + tid;
    cnt[10] = cnt[10] - iter;
    cnt[11] = cnt[11] + (tid ^ iter);
    cnt[12] = cnt[12] * (tid | 1);
    cnt[13] = cnt[13] + iter + 1;
    cnt[14] = cnt[14] ^ (long)(tid + iter);
    cnt[15] = cnt[15] + tid * 3;
    /* subtotal: 32 loads + 16 stores = 48 load/store instructions           */

    g_int_a   = g_int_a   + tid;        /* load + store = 2                 */
    g_int_b   = g_int_b   ^ iter;
    g_int_c   = g_int_c   + (tid & iter);
    g_int_d   = g_int_d   - tid;
    g_long_a  = g_long_a  + iter;
    g_long_b  = g_long_b  ^ (long)tid;
    g_float_a = g_float_a + (float)tid;
    g_double_a= g_double_a + (double)iter;
    /* subtotal: 16 loads + 8 stores = 24 load/store instructions            */
}

__attribute__((noinline))
static void touch_status(int tid, int iter)
{
    /* status array — 32 elements, index computed → no SROA                  */
    for (int i = 0; i < 32; ++i) {
        int v = status[i];                /* volatile load                   */
        status[i] = v + tid + (iter & i);/* volatile store                  */
    }
    /* 32 loads + 32 stores = 64 load/store instructions                     */
}

__attribute__((noinline))
static void touch_matrix(int tid, int iter)
{
    /* Both row and col are runtime expressions → compiler cannot collapse   */
    for (int r = 0; r < ROWS; ++r) {
        for (int c = 0; c < COLS; ++c) {
            int v = matrix[r][c];         /* volatile load                   */
            matrix[r][c] = v + tid * r + iter * c; /* volatile store        */
        }
    }
    /* 128 loads + 128 stores = 256 load/store instructions per call         */
}

/* ---- worker ---------------------------------------------------------------- */
typedef struct { int tid; } arg_t;

static void *worker(void *varg)
{
    arg_t *a  = (arg_t *)varg;
    int    id = a->tid;

    for (int iter = 0; iter < ITERATIONS; ++iter) {
        touch_globals(id, iter);   /* 72  load/stores per call              */
        touch_status (id, iter);   /* 64  load/stores per call              */
        touch_matrix (id, iter);   /* 256 load/stores per call              */
        /* Total per iteration: ~392 load/store instructions                 */
    }
    return NULL;
}

int main(void)
{
    pthread_t threads[NUM_THREADS];
    arg_t     args[NUM_THREADS];

    printf("[O1B1] volatile globals: %d threads x %d iters\n",
           NUM_THREADS, ITERATIONS);
    printf("       Expected IR loads+stores per thread: ~400\n");

    for (int t = 0; t < NUM_THREADS; ++t) {
        args[t].tid = t;
        pthread_create(&threads[t], NULL, worker, &args[t]);
    }
    for (int t = 0; t < NUM_THREADS; ++t)
        pthread_join(threads[t], NULL);

    printf("[O1B1] Done. cnt[0]=%ld\n", cnt[0]);
    return 0;
}

/*
 * BUILD & CHECK IR
 * ----------------
 * clang -O1 -pthread -S -emit-llvm o1_bench1_volatile.c -o o1b1.ll
 * grep -c "load\|store" o1b1.ll
 * # Expected: 300+ in touch_* functions combined
 *
 * Run with your pass:
 * clang -O1 -pthread -fpass-plugin=your_pass.so o1_bench1_volatile.c -o o1b1_det
 *
 * All accesses escape (globals) → your pass should skip 0 of them here.
 * Use this as the UPPER BOUND baseline: maximum instrumentation needed.
 */
