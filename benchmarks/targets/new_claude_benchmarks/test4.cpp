/*
 * BENCHMARK 5: SPARSE RACES — FEW RACY NEEDLES IN A PRIVATE HAYSTACK
 * ====================================================================
 * Sharing profile  : MOSTLY PRIVATE — large private working set with a small
 *                    number of racy variables deliberately hidden among safe code
 * Races present    : YES — but only on a handful of variables (needles)
 * Instrumentation  : Sharing analysis must find only the racy variables;
 *                    the vast private haystack must not inflate overhead
 *
 * This is the SENSITIVITY benchmark: the detector must find races that are
 * rare (small window), sparse (few variables), and buried in a lot of
 * innocent, race-free work.  Missing even one is a false negative.
 *
 * Structure
 * ---------
 *   haystack_A : per-thread private arrays (safe, large, must not instrument)
 *   haystack_B : per-thread heap struct arrays (safe, must not instrument)
 *   needle_1   : single shared int, written by all threads once per 100 iters
 *   needle_2   : shared pointer (re-assigned by all threads)
 *   needle_3   : shared bitfield-style flag byte
 *   needle_4   : shared double (torn write on 32-bit platforms)
 *   needle_5   : shared array of 4 ints (only index [tid%4] written, still racy)
 *
 * What to measure
 * ---------------
 *   1. All 5 needles detected          → must be YES (no false negatives)
 *   2. Haystack not instrumented        → overhead should be LOW
 *   3. False positives on haystack      → ZERO
 *   4. Race window narrowness           → detector must work even at low freq
 */

#define _GNU_SOURCE
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* ======================================================= configuration === */
#define NUM_THREADS      8
#define HAYSTACK_INTS 2048    /* large private buffer per thread            */
#define HAYSTACK_RECS   64    /* private struct records per thread           */
#define ITERATIONS    5000
#define RACE_PERIOD    100    /* threads touch needle only every N iters     */

/* ======================================================= needles (racy) == */
static volatile int     needle_1;           /* simple racy int              */
static volatile int    *needle_2_ptr;       /* racy pointer                 */
static volatile uint8_t needle_3_flag;      /* racy byte / bitfield         */
static volatile double  needle_4_dbl;       /* racy double (torn write)     */
static volatile int     needle_5[4];        /* racy array, index = tid % 4  */

/* a heap object needle_2_ptr can point to */
static int needle_2_target[NUM_THREADS];

/* ======================================================= haystack ======== */
/* private partition (haystack A) — per-thread exclusive stripes */
static int haystack_A[NUM_THREADS * HAYSTACK_INTS];

/* private struct (haystack B) — allocated per-thread in main */
typedef struct {
    int   vals[16];
    long  checksum;
    float scale;
} record_t;

/* per-thread pointer to private record array */
static record_t *haystack_B[NUM_THREADS];

/* ======================================================= worker =========  */
typedef struct { int tid; } arg_t;

static void *worker(void *varg)
{
    arg_t *a  = (arg_t *)varg;
    int    id = a->tid;

    int      *my_A   = haystack_A + id * HAYSTACK_INTS;  /* private stripe */
    record_t *my_B   = haystack_B[id];                   /* private recs   */

    for (int iter = 0; iter < ITERATIONS; ++iter) {

        /* ============================================================
         * HAYSTACK — large, safe, must not be instrumented
         * ============================================================ */

        /* Haystack A: private array work */
        for (int i = 0; i < HAYSTACK_INTS; ++i)
            my_A[i] = my_A[i] * (id + 1) + iter;

        volatile long s = 0;
        for (int i = 0; i < HAYSTACK_INTS; ++i) s += my_A[i];
        (void)s;

        /* Haystack B: private struct records */
        for (int r = 0; r < HAYSTACK_RECS; ++r) {
            record_t *rec = &my_B[r];
            long cs = 0;
            for (int f = 0; f < 16; ++f) {
                rec->vals[f] = id * 16 + f + iter;
                cs += rec->vals[f];
            }
            rec->checksum = cs;
            rec->scale    = (float)cs / 16.0f;
        }

        /* ============================================================
         * NEEDLES — infrequent, racy touches
         * ============================================================ */

        if (iter % RACE_PERIOD == 0) {

            /* Needle 1: plain int RMW */
            needle_1 += id;                      /* racy RMW               */

            /* Needle 2: pointer race — all threads point it at their slot */
            needle_2_ptr = &needle_2_target[id]; /* racy write of pointer  */
            (void)*needle_2_ptr;                 /* racy dereference        */

            /* Needle 3: byte flag — WW race */
            needle_3_flag = (uint8_t)(id & 0xFF);/* racy write             */

            /* Needle 4: double — racy write (may tear on 32-bit arch) */
            needle_4_dbl  = (double)id * 3.14159;/* racy write             */
            volatile double tmp = needle_4_dbl;  /* racy read              */
            (void)tmp;

            /* Needle 5: per-index races — thread id writes index id%4 */
            needle_5[id % 4] += id;              /* racy RMW               */
        }
    }

    return NULL;
}

/* ================================================================ main === */
int main(void)
{
    pthread_t threads[NUM_THREADS];
    arg_t     args[NUM_THREADS];

    /* initialise needles */
    needle_1      = 0;
    needle_2_ptr  = &needle_2_target[0];
    needle_3_flag = 0;
    needle_4_dbl  = 0.0;
    memset((void*)needle_5, 0, sizeof(needle_5));
    memset(needle_2_target, 0, sizeof(needle_2_target));

    /* initialise haystack */
    memset(haystack_A, 0, sizeof(haystack_A));
    for (int t = 0; t < NUM_THREADS; ++t) {
        haystack_B[t] = (record_t *)calloc(HAYSTACK_RECS, sizeof(record_t));
        if (!haystack_B[t]) { perror("calloc"); return 1; }
    }

    printf("[B5] Sparse-races benchmark: %d threads, %d iters, race every %d iters\n",
           NUM_THREADS, ITERATIONS, RACE_PERIOD);
    printf("     Haystack: A[%d ints/thread], B[%d recs/thread]\n",
           HAYSTACK_INTS, HAYSTACK_RECS);
    printf("     Needles: needle_1(int), needle_2(ptr), needle_3(byte), "
           "needle_4(dbl), needle_5[4]\n");

    for (int t = 0; t < NUM_THREADS; ++t) {
        args[t].tid = t;
        pthread_create(&threads[t], NULL, worker, &args[t]);
    }
    for (int t = 0; t < NUM_THREADS; ++t)
        pthread_join(threads[t], NULL);

    printf("[B5] Done. needle_1=%d (non-deterministic)\n", needle_1);

    for (int t = 0; t < NUM_THREADS; ++t) free(haystack_B[t]);
    return 0;
}

/*
 * BUILD
 * -----
 * gcc -O1 -pthread bench5_sparse_races.c -o b5 && ./b5
 * gcc -O1 -pthread -fsanitize=thread bench5_sparse_races.c -o b5_tsan
 *
 * NEEDLE DETECTION CHECKLIST
 * --------------------------
 *   [ ] needle_1  — int RMW race detected?
 *   [ ] needle_2  — pointer write + dereference race detected?
 *   [ ] needle_3  — byte WW race detected?
 *   [ ] needle_4  — double RW race detected?
 *   [ ] needle_5  — per-index array race detected?
 *
 * OVERHEAD MEASUREMENT
 * --------------------
 * Compare runtime of b5 vs b5_tsan vs b5_det (your tool).
 * Overhead should track roughly with instrumentation count, not workload size.
 * If overhead is proportional to HAYSTACK_INTS (not RACE_PERIOD),
 * the sharing analysis is over-approximating private variables as shared.
 */
