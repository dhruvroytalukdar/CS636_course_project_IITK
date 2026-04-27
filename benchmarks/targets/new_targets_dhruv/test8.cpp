/*
 * BENCHMARK 1: HIGH SHARING — MANY RACY VARIABLES, MANY SIMULTANEOUS RACES
 * ==========================================================================
 * Sharing profile  : MAXIMUM — every global/heap variable is touched by all threads
 * Races present    : YES — intentional, on scalars, arrays, structs, and pointers
 * Instrumentation  : Sharing analysis must instrument ≈ 100 % of loads/stores
 *
 * This benchmark deliberately creates the worst-case scenario for a detector:
 *   • Many independent racy variables (counters, flags, arrays, struct fields)
 *   • Multiple race categories simultaneously (RW, WW, RW on distinct offsets)
 *   • No synchronisation whatsoever
 *   • Access patterns designed to defeat simple "first-touch" heuristics
 *
 * What to measure
 * ---------------
 *   1. Instrumentation coverage  → should be HIGH (≈ 100 %)
 *   2. Races detected            → should be MANY (hundreds of unique pairs)
 *   3. False-negative rate       → should be ZERO
 *   4. Overhead vs baseline      → expected VERY HIGH (everything is shared)
 */

#define _GNU_SOURCE
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* ======================================================= configuration === */
#define NUM_THREADS      8
#define ARRAY_LEN      512
#define ITERATIONS    2000
#define NUM_COUNTERS    32   /* independent global counters, all racy        */
#define NUM_FLAGS       16   /* boolean flag array, all racy                 */

/* ======================================================= shared globals === */

/* Category A: independent scalar counters (RW races on each) */
static volatile long counters[NUM_COUNTERS];

/* Category B: flag array (WW + RW races) */
static volatile int  flags[NUM_FLAGS];

/* Category C: flat integer array (RW races on every index) */
static int arr[ARRAY_LEN];

/* Category D: linked-list style struct — field-level races */
typedef struct node {
    int   value;
    int   version;
    long  checksum;
    struct node *next;          /* pointer races too                        */
} node_t;

#define NUM_NODES 64
static node_t nodes[NUM_NODES];

/* Category E: a shared heap buffer allocated once in main */
static int *heap_buf;           /* races on heap — tests heap shadow maps   */
#define HEAP_SIZE 256

/* Category F: single shared scalar (extreme contention) */
static long hot_counter;        /* every thread hammers this one variable   */

/* Category G: two-dimensional array, races along both dimensions */
static int matrix[NUM_THREADS][ARRAY_LEN / NUM_THREADS];

/* ======================================================= worker thread === */
typedef struct { int tid; } arg_t;

static void *worker(void *varg)
{
    arg_t *a  = (arg_t *)varg;
    int    id = a->tid;

    for (int iter = 0; iter < ITERATIONS; ++iter) {

        /* --- A: counters ------------------------------------------------ */
        for (int c = 0; c < NUM_COUNTERS; ++c) {
            long v = counters[c];          /* racy read  */
            counters[c] = v + id + iter;  /* racy write */
        }

        /* --- B: flags --------------------------------------------------- */
        for (int f = 0; f < NUM_FLAGS; ++f) {
            flags[f] = (iter + id) & 1;   /* racy write */
            (void)flags[f];               /* racy read  */
        }

        /* --- C: flat array (all threads, all indices) ------------------- */
        for (int i = 0; i < ARRAY_LEN; ++i) {
            arr[i] += id;                 /* racy read-modify-write         */
        }

        /* --- D: struct field races --------------------------------------- */
        for (int n = 0; n < NUM_NODES; ++n) {
            nodes[n].value    = id * iter;          /* racy write           */
            nodes[n].version += 1;                  /* racy RMW             */
            nodes[n].checksum = nodes[n].value      /* racy read + write    */
                              + nodes[n].version;
            /* pointer race: all threads update next */
            if (n + 1 < NUM_NODES)
                nodes[n].next = &nodes[(n + id) % NUM_NODES];
        }

        /* --- E: heap buffer --------------------------------------------- */
        for (int i = 0; i < HEAP_SIZE; ++i) {
            heap_buf[i] = heap_buf[i] * id + iter;  /* racy RMW on heap    */
        }

        /* --- F: hot scalar ---------------------------------------------- */
        hot_counter++;                    /* classic lost-update race        */

        /* --- G: matrix — thread writes own row but reads all rows -------- */
        /* Write own row */
        for (int j = 0; j < ARRAY_LEN / NUM_THREADS; ++j)
            matrix[id][j] = iter + j;    /* private write (may not be racy) */

        /* Read a neighbour's row — creates cross-thread RW race */
        int neighbour = (id + 1) % NUM_THREADS;
        volatile long acc = 0;
        for (int j = 0; j < ARRAY_LEN / NUM_THREADS; ++j)
            acc += matrix[neighbour][j]; /* racy read of neighbour's row    */
        (void)acc;
    }

    return NULL;
}

/* ================================================================ main === */
int main(void)
{
    pthread_t threads[NUM_THREADS];
    arg_t     args[NUM_THREADS];

    /* initialise shared state */
    memset((void*)counters, 0, sizeof(counters));
    memset((void*)flags,    0, sizeof(flags));
    memset(arr,             0, sizeof(arr));
    memset(nodes,           0, sizeof(nodes));
    memset(matrix,          0, sizeof(matrix));
    hot_counter = 0;

    heap_buf = (int *)calloc(HEAP_SIZE, sizeof(int));
    if (!heap_buf) { perror("calloc"); return 1; }

    printf("[B1] High-sharing / many-races benchmark: %d threads, %d iters\n",
           NUM_THREADS, ITERATIONS);
    printf("     Shared variables: %d counters, %d flags, arr[%d], "
           "%d nodes, heap[%d], matrix[%d][%d], hot_counter\n",
           NUM_COUNTERS, NUM_FLAGS, ARRAY_LEN, NUM_NODES, HEAP_SIZE,
           NUM_THREADS, ARRAY_LEN / NUM_THREADS);

    for (int t = 0; t < NUM_THREADS; ++t) {
        args[t].tid = t;
        pthread_create(&threads[t], NULL, worker, &args[t]);
    }
    for (int t = 0; t < NUM_THREADS; ++t)
        pthread_join(threads[t], NULL);

    printf("[B1] Done. hot_counter=%ld (non-deterministic)\n", hot_counter);
    free(heap_buf);
    return 0;
}

/*
 * BUILD
 * -----
 * gcc -O1 -pthread bench1_high_sharing_many_races.c -o b1 && ./b1
 * gcc -O1 -pthread -fsanitize=thread bench1_high_sharing_many_races.c -o b1_tsan
 *
 * RACE CATEGORIES PRESENT
 * -----------------------
 *  RW  — read in one thread, concurrent write in another
 *  WW  — two threads write the same location
 *  RMW — non-atomic read-modify-write (lost update)
 *  PTR — pointer field written by multiple threads
 *
 * DETECTOR CHECKLIST
 * ------------------
 *  [ ] All counter[], flags[], arr[], heap_buf[] accesses instrumented?
 *  [ ] Struct field races (value, version, checksum, next) reported?
 *  [ ] hot_counter reports a race every iteration?
 *  [ ] matrix row-neighbour races detected?
 *  [ ] Zero false negatives across all 7 variable categories?
 */
