/*
 * O1_BENCH_2: POINTER ALIASING — DEFEATS -O1 SCALAR PROMOTION
 * =============================================================
 * Problem: At -O1, clang promotes stack variables to SSA registers
 * (mem2reg pass) so loads/stores to them disappear from the IR.
 *
 * Solution: Take the address of stack variables and pass them through
 * pointer parameters across noinline function boundaries. The compiler
 * CANNOT prove no aliasing across an opaque call site, so it must keep
 * every load and store materialised in the IR.
 *
 * This also gives your escape analysis real work:
 *   - Pointers passed to noinline functions → escape (must instrument)
 *   - Pointers that stay purely local       → do NOT escape (skip them)
 *
 * Expected IR load/store count at -O1: 200-350 in the aliased functions
 *
 * Escape analysis opportunity:
 *   LOCAL (should be skipped by your pass):
 *     scratch[], local_acc  — never passed out of worker()
 *   ESCAPED (must be instrumented):
 *     shared_data[] passed into process_chunk()
 *     out_sum passed by pointer into reduce_into()
 */

#define _GNU_SOURCE
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM_THREADS   8
#define CHUNK_SIZE   64    /* elements per processing chunk                  */
#define NUM_CHUNKS    8    /* chunks in the shared buffer                    */
#define ITERATIONS  500

/* shared heap data — pointer passed across noinline boundaries             */
static int *shared_data;    /* [NUM_CHUNKS * CHUNK_SIZE]                    */
static long global_sum;     /* all threads write here (racy)                */

/* ---- functions that receive pointers: compiler can't eliminate loads ----- */

/*
 * Receives an int* it knows nothing about at compile time.
 * Every read and write through `buf` must be a real load/store.
 * Each call generates: CHUNK_SIZE loads + CHUNK_SIZE stores = 128 insns
 */
__attribute__((noinline))
static void process_chunk(int *buf, int len, int tid, int iter)
{
    for (int i = 0; i < len; ++i) {
        int v = buf[i];                   /* load — pointer may alias        */
        buf[i] = v * (tid + 1) + iter;   /* store — pointer may alias       */
    }
}

/*
 * Takes a pointer to a long accumulator and a const int*.
 * Compiler must keep all accesses because it can't rule out aliasing.
 * Generates: len loads from src + len loads + len stores to *acc
 */
__attribute__((noinline))
static void reduce_into(long *acc, const int *src, int len)
{
    for (int i = 0; i < len; ++i) {
        *acc = *acc + src[i];     /* load *acc, load src[i], store *acc     */
    }
}

/*
 * Receives two aliasing-candidate pointers.
 * Compiler must reload `a` after every store through `b`.
 * Generates approximately 3 × len loads + 2 × len stores
 */
__attribute__((noinline))
static void cross_update(int *a, int *b, int len, int tid)
{
    for (int i = 0; i < len; ++i) {
        int av = a[i];            /* load a[i]                              */
        int bv = b[i];            /* load b[i]  (may alias a)               */
        a[i]   = bv + tid;       /* store a[i]                             */
        b[i]   = av ^ tid;       /* store b[i] — compiler reloads a if alias*/
    }
}

/*
 * Writes through a pointer-to-pointer — forces two levels of indirection.
 * Generates: n loads of pp, n loads of *pp[i], n stores
 */
__attribute__((noinline))
static void scatter_write(int **pp, int count, int val)
{
    for (int i = 0; i < count; ++i) {
        *pp[i] = *pp[i] + val;   /* load ptr, load *ptr, store *ptr        */
    }
}

/* ---- worker ---------------------------------------------------------------- */
typedef struct { int tid; } arg_t;

static void *worker(void *varg)
{
    arg_t *a  = (arg_t *)varg;
    int    id = a->tid;

    /* LOCAL: purely stack, never passed out — your pass should SKIP these   */
    long local_acc = 0;                         /* local scalar              */
    int  scratch[CHUNK_SIZE];                   /* local array               */
    memset(scratch, 0, sizeof(scratch));

    /* Pointer array for scatter_write — stack, but pointers point to shared */
    int *ptrs[4];

    for (int iter = 0; iter < ITERATIONS; ++iter) {

        /* Pick a chunk of shared_data for this thread × iteration           */
        int chunk_idx = (id + iter) % NUM_CHUNKS;
        int *chunk    = shared_data + chunk_idx * CHUNK_SIZE;

        /* --- ESCAPED: shared_data chunk passed into noinline function ----- */
        /* Generates CHUNK_SIZE loads + CHUNK_SIZE stores = 128 load/stores  */
        process_chunk(chunk, CHUNK_SIZE, id, iter);

        /* --- ESCAPED: shared pointer + local long passed by pointer -------- */
        /* Generates CHUNK_SIZE loads from chunk + 2×CHUNK_SIZE on acc       */
        reduce_into(&local_acc, chunk, CHUNK_SIZE);

        /* --- ESCAPED: two chunks passed into cross_update (may alias) ------ */
        int other_idx = (chunk_idx + 1) % NUM_CHUNKS;
        int *other    = shared_data + other_idx * CHUNK_SIZE;
        cross_write: ;
        cross_update(chunk, other, CHUNK_SIZE / 2, id);
        /* 3×32 loads + 2×32 stores = 160 load/stores                       */

        /* --- LOCAL scratch work (should be skippable by your pass) --------- */
        for (int i = 0; i < CHUNK_SIZE; ++i)
            scratch[i] = scratch[i] + id + iter;
        /* scratch never escapes — escape analysis should prove this          */

        /* --- ESCAPED: scatter write through pointer-to-pointer ------------- */
        ptrs[0] = &shared_data[0];
        ptrs[1] = &shared_data[CHUNK_SIZE];
        ptrs[2] = &shared_data[CHUNK_SIZE * 2];
        ptrs[3] = &shared_data[CHUNK_SIZE * 3];
        scatter_write(ptrs, 4, id + iter);

        /* Global sum — classic shared scalar race                           */
        global_sum += local_acc;
    }

    return NULL;
}

int main(void)
{
    pthread_t threads[NUM_THREADS];
    arg_t     args[NUM_THREADS];

    int total = NUM_CHUNKS * CHUNK_SIZE;
    shared_data = (int *)calloc(total, sizeof(int));
    if (!shared_data) { perror("calloc"); return 1; }
    global_sum = 0;

    printf("[O1B2] Pointer-alias benchmark: %d threads x %d iters\n",
           NUM_THREADS, ITERATIONS);
    printf("       Escaped: shared_data chunks, ptrs[], &local_acc, &global_sum\n");
    printf("       Local  : scratch[%d], local_acc (your pass can skip these)\n",
           CHUNK_SIZE);

    for (int t = 0; t < NUM_THREADS; ++t) {
        args[t].tid = t;
        pthread_create(&threads[t], NULL, worker, &args[t]);
    }
    for (int t = 0; t < NUM_THREADS; ++t)
        pthread_join(threads[t], NULL);

    printf("[O1B2] Done. global_sum=%ld\n", global_sum);
    free(shared_data);
    return 0;
}

/*
 * BUILD & CHECK IR
 * ----------------
 * clang -O1 -pthread -S -emit-llvm o1_bench2_aliasing.c -o o1b2.ll
 * grep -c "load\|store" o1b2.ll
 *
 * What to look for in the IR:
 *   - process_chunk:  load + store inside loop body (should NOT be hoisted)
 *   - cross_update:   3 loads + 2 stores per iteration (alias prevents merge)
 *   - scatter_write:  2 loads + 1 store per element (pointer chain)
 *   - worker/scratch: these MAY be optimised away — that's fine and expected
 *
 * Escape analysis opportunity:
 *   scratch[] is allocated on the stack, its address is never passed to
 *   any function or stored in a global — provably thread-local.
 *   Your pass should mark it NON-SHARED and skip instrumenting its accesses.
 *
 *   shared_data is a global pointer — any dereference is shared.
 *   local_acc address IS taken (&local_acc) and passed to reduce_into,
 *   but reduce_into only reads through it — still thread-local in practice,
 *   though a conservative escape analysis will mark it escaped.
 */
