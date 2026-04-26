/*
 * O1_BENCH_5: ESCAPE ANALYSIS STRESS TEST — MANY ESCAPE PATTERNS
 * ================================================================
 * This benchmark is specifically designed to exercise every common escape
 * pattern that an LLVM escape analysis pass must handle correctly.
 * It generates hundreds of loads/stores at -O1 by combining:
 *   (a) noinline function boundaries
 *   (b) structs with pointer fields
 *   (c) global pointer stores
 *   (d) return-by-pointer patterns
 *
 * Escape categories tested
 * ------------------------
 *   ESCAPES via global store     : ptr stored into a global variable
 *   ESCAPES via return value     : pointer returned from function
 *   ESCAPES via struct field     : pointer stored into a struct field
 *   DOES NOT ESCAPE (local only) : pointer used only within current function
 *   DOES NOT ESCAPE (noinline)   : passed to noinline but callee is "pure"
 *
 * Your pass should instrument accesses through escaping pointers,
 * and skip accesses through non-escaping ones.
 *
 * Expected IR load/store count at -O1: 250-450 across all functions
 * Expected skippable by escape analysis: 30-40% (the non-escaping ones)
 */

#define _GNU_SOURCE
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM_THREADS  8
#define BUF_SIZE    64
#define ITERATIONS  500

/* ======================================================= shared globals === */

/* Global pointer that gets set to an escaping allocation */
static int *g_escaped_ptr;       /* ESCAPE VIA GLOBAL STORE                 */

/* Global struct that holds a pointer field */
typedef struct { int *data; int len; } handle_t;
static handle_t g_handle;        /* ESCAPE VIA STRUCT FIELD IN GLOBAL       */

static volatile long g_result;

/* ======================================================= escape patterns == */

/*
 * PATTERN 1: Escape via global pointer store.
 * Any alloca/malloc whose address flows into a global is shared.
 * Load/stores through g_escaped_ptr must be instrumented.
 */
__attribute__((noinline))
static void publish_ptr(int *p)
{
    g_escaped_ptr = p;           /* p escapes here — stored in global       */
}

/*
 * PATTERN 2: Escape via return value.
 * The returned pointer may be stored anywhere by the caller.
 * Loads/stores through the returned pointer must be instrumented.
 */
__attribute__((noinline))
static int *alloc_and_return(int size)
{
    int *p = (int *)calloc(size, sizeof(int));
    return p;                    /* p escapes via return                     */
}

/*
 * PATTERN 3: NON-ESCAPE — noinline function that is "write-only local".
 * The callee reads and writes through the pointer but does NOT store it
 * anywhere persistent.  A precise analysis should mark this as non-escaping.
 */
__attribute__((noinline))
static long pure_local_reduce(const int *buf, int len)
{
    long s = 0;
    for (int i = 0; i < len; ++i)
        s += buf[i];             /* loads through buf — but buf doesn't escape */
    return s;
    /* pointer is not stored, not returned → does NOT escape               */
}

/*
 * PATTERN 4: Escape via struct field store.
 * p stored into a struct field that is then assigned to a global.
 */
__attribute__((noinline))
static void register_handle(int *p, int len)
{
    g_handle.data = p;           /* p escapes into g_handle                 */
    g_handle.len  = len;
}

/*
 * PATTERN 5: NON-ESCAPE — pointer passed through two noinline functions
 * but never stored globally.  Tests depth of interprocedural analysis.
 */
__attribute__((noinline))
static void inner_transform(int *buf, int len, int val)
{
    for (int i = 0; i < len; ++i)
        buf[i] = buf[i] * val + i;  /* RMW — buf doesn't escape here       */
}

__attribute__((noinline))
static void outer_transform(int *buf, int len, int tid, int iter)
{
    inner_transform(buf, len, tid + 1);        /* buf passed down           */
    inner_transform(buf, len / 2, iter + 1);   /* buf passed down again     */
    /* buf is never stored globally anywhere in this call chain             */
}

/*
 * PATTERN 6: Conditional escape — pointer escapes only on some code paths.
 * Conservative analysis must treat it as escaped; precise flow-sensitive
 * analysis may determine the escaping branch is never taken for local allocs.
 */
__attribute__((noinline))
static void conditional_publish(int *p, int condition)
{
    if (condition) {
        g_escaped_ptr = p;       /* escapes only if condition is true       */
    }
    /* If caller always passes condition=0, does p escape? */
    /* Conservative: YES.  Flow-sensitive: maybe NO.       */
    for (int i = 0; i < BUF_SIZE; ++i)
        p[i] += 1;               /* RMW through p                           */
}

/* ======================================================= worker =========== */
typedef struct { int tid; } arg_t;

static void *worker(void *varg)
{
    arg_t *a  = (arg_t *)varg;
    int    id = a->tid;

    for (int iter = 0; iter < ITERATIONS; ++iter) {

        /* --- PATTERN 1: allocate, publish to global, use via global ------- */
        int *pub_buf = (int *)calloc(BUF_SIZE, sizeof(int));
        publish_ptr(pub_buf);    /* pub_buf NOW ESCAPES                      */
        for (int i = 0; i < BUF_SIZE; ++i)
            pub_buf[i] = id + i + iter;      /* must instrument: escaped     */
        /* loads/stores: BUF_SIZE stores = 64 stores                        */

        /* --- PATTERN 2: use returned (escaped) pointer ------------------- */
        int *ret_buf = alloc_and_return(BUF_SIZE);
        for (int i = 0; i < BUF_SIZE; ++i) {
            ret_buf[i] = ret_buf[i] + id;   /* must instrument: escaped     */
        }
        /* loads/stores: 64 loads + 64 stores = 128                         */

        /* --- PATTERN 3: local buffer, passed only to pure_local_reduce ---- */
        int local_buf[BUF_SIZE];
        for (int i = 0; i < BUF_SIZE; ++i)
            local_buf[i] = id * BUF_SIZE + i + iter;
        /* local_buf[] stores: 64 stores — CAN BE SKIPPED if analysis is   */
        /* precise enough to see pure_local_reduce doesn't store the ptr    */

        long red = pure_local_reduce(local_buf, BUF_SIZE);
        /* pure_local_reduce loads: 64 loads — CAN BE SKIPPED               */

        /* --- PATTERN 4: struct-field escape -------------------------------- */
        int *handle_buf = (int *)calloc(BUF_SIZE, sizeof(int));
        register_handle(handle_buf, BUF_SIZE);  /* NOW ESCAPED via g_handle */
        for (int i = 0; i < BUF_SIZE; ++i)
            handle_buf[i] = id ^ i;            /* must instrument            */
        /* 64 stores                                                         */

        /* --- PATTERN 5: two-level noinline, non-escaping ------------------- */
        int deep_buf[BUF_SIZE];
        memset(deep_buf, 0, sizeof(deep_buf));
        outer_transform(deep_buf, BUF_SIZE, id, iter);
        /* deep_buf never stored globally anywhere in the call chain         */
        /* ~128 loads + 128 stores inside inner_transform calls             */
        /* CAN BE SKIPPED by a precise interprocedural analysis             */

        /* Use deep_buf result so it isn't dead-code-eliminated             */
        long dsum = 0;
        for (int i = 0; i < BUF_SIZE; ++i) dsum += deep_buf[i];
        g_result += red + dsum;  /* racy write to global                    */

        /* --- PATTERN 6: conditional escape — condition always 0 here ------ */
        int cond_buf[BUF_SIZE];
        memset(cond_buf, 0, sizeof(cond_buf));
        conditional_publish(cond_buf, 0);       /* condition=0 always       */
        /* conservative: instrumented; precise flow-sensitive: skipped      */
        /* 64 loads + 64 stores inside conditional_publish                  */

        /* cleanup */
        free(pub_buf);
        free(ret_buf);
        free(handle_buf);
    }

    return NULL;
}

int main(void)
{
    pthread_t threads[NUM_THREADS];
    arg_t     args[NUM_THREADS];

    g_escaped_ptr = NULL;
    g_handle.data = NULL;
    g_handle.len  = 0;
    g_result      = 0;

    printf("[O1B5] Escape-pattern benchmark: %d threads x %d iters\n",
           NUM_THREADS, ITERATIONS);
    printf("       Escape patterns: global store, return, struct field,\n");
    printf("                        non-escape pure callee, 2-level noinline,\n");
    printf("                        conditional escape (always false)\n");

    for (int t = 0; t < NUM_THREADS; ++t) {
        args[t].tid = t;
        pthread_create(&threads[t], NULL, worker, &args[t]);
    }
    for (int t = 0; t < NUM_THREADS; ++t)
        pthread_join(threads[t], NULL);

    printf("[O1B5] Done. g_result=%ld\n", g_result);
    return 0;
}

/*
 * BUILD & CHECK IR
 * ----------------
 * clang -O1 -pthread -S -emit-llvm o1_bench5_escape_patterns.c -o o1b5.ll
 * grep -c "load\|store" o1b5.ll
 * # Expected: 400+ total across all functions
 *
 * ESCAPE ANALYSIS SCORECARD
 * -------------------------
 * For each pattern, what % of its load/stores does your pass skip?
 *
 *  Pattern 1 (global store pub_buf)   : 0% skip — correctly escaped
 *  Pattern 2 (returned ret_buf)       : 0% skip — correctly escaped
 *  Pattern 3 (pure_local_reduce)      : goal 100% skip — non-escaping
 *  Pattern 4 (struct field handle_buf): 0% skip — correctly escaped
 *  Pattern 5 (outer_transform 2-level): goal 100% skip — non-escaping
 *  Pattern 6 (conditional, always 0)  : 0% conservative / 100% precise
 *
 * Pattern 3 and 5 are the most important: they represent the common case
 * of "pass a local buffer to a helper function for processing" which is
 * extremely frequent in real code and should be optimisable.
 *
 * Your escape analysis should at minimum handle Pattern 3.
 * Pattern 5 requires interprocedural analysis across two function levels.
 * Pattern 6 requires flow-sensitive escape analysis.
 */
