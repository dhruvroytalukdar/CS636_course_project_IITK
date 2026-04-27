/*
 * O1_BENCH_3: STRUCT FIELDS VIA POINTER INDIRECTION
 * ===================================================
 * Problem: mem2reg only promotes scalar alloca instructions. A struct
 * allocated on the stack with its address taken is NOT promoted — every
 * field access remains as an explicit load/store in the IR even at -O1.
 *
 * Solution: Use structs with many fields, accessed through a noinline
 * function that receives the struct pointer. This reliably produces
 * hundreds of loads/stores even at -O1.
 *
 * Additional technique: field-by-field copies between two struct pointers
 * produce 2N loads + N stores (N = field count) per call.
 *
 * Expected IR load/store count at -O1:
 *   update_record():  28 loads + 14 stores = 42 per call
 *   merge_records():  14 loads + 14 stores = 28 per copy call
 *   scan_table():     NFIELDS × NRECS loads per call
 *   Total per iter:  ~200-300 load/store instructions
 *
 * Escape analysis opportunity:
 *   thread_local_rec: stack struct, address passed to noinline functions
 *     → conservative analysis marks as escaped (but it IS thread-local)
 *     → this is an interesting FP opportunity for a precise analysis
 *   shared_table[]:  global struct array → definitely shared
 */

#define _GNU_SOURCE
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM_THREADS  8
#define NRECS       32     /* records in shared table                        */
#define NFIELDS     14     /* fields per record                              */
#define ITERATIONS  500

/* ---- data types ---------------------------------------------------------- */
/*
 * A struct with 14 fields of mixed types.
 * Even at -O1, taking &rec and passing it across noinline boundaries forces
 * every field access to remain as a load or store in the LLVM IR.
 */
typedef struct {
    int    f0, f1, f2, f3;      /* 4 ints   = 4 fields                     */
    long   f4, f5, f6;          /* 3 longs  = 3 fields                     */
    float  f7, f8;              /* 2 floats = 2 fields                      */
    double f9;                  /* 1 double = 1 field                       */
    int    f10, f11, f12;       /* 3 ints   = 3 fields                     */
    /* total: 14 fields                                                      */
} record_t;                     /* sizeof ~ 72 bytes                        */

/* ---- shared state -------------------------------------------------------- */
static record_t shared_table[NRECS];   /* global struct array — shared      */
static volatile long global_checksum;  /* shared scalar — racy              */

/* ---- noinline functions that keep all field loads/stores visible --------- */

/*
 * Reads and writes every field of *r.
 * 14 fields × (1 load + 1 store) = 28 loads + 14 stores = 42 load/stores
 */
__attribute__((noinline))
static void update_record(record_t *r, int tid, int iter)
{
    r->f0  = r->f0  + tid;
    r->f1  = r->f1  ^ iter;
    r->f2  = r->f2  * (tid + 1);
    r->f3  = r->f3  - iter;
    r->f4  = r->f4  + (long)tid * iter;
    r->f5  = r->f5  ^ (long)tid;
    r->f6  = r->f6  + iter;
    r->f7  = r->f7  + (float)tid;
    r->f8  = r->f8  * (float)(iter + 1);
    r->f9  = r->f9  + (double)(tid ^ iter);
    r->f10 = r->f10 + tid + iter;
    r->f11 = r->f11 | tid;
    r->f12 = r->f12 & ~iter;
}

/*
 * Copies every field from src to dst.
 * 14 loads (from src) + 14 stores (to dst) = 28 load/stores
 */
__attribute__((noinline))
static void copy_record(record_t *dst, const record_t *src)
{
    dst->f0  = src->f0;
    dst->f1  = src->f1;
    dst->f2  = src->f2;
    dst->f3  = src->f3;
    dst->f4  = src->f4;
    dst->f5  = src->f5;
    dst->f6  = src->f6;
    dst->f7  = src->f7;
    dst->f8  = src->f8;
    dst->f9  = src->f9;
    dst->f10 = src->f10;
    dst->f11 = src->f11;
    dst->f12 = src->f12;
}

/*
 * Accumulates a checksum from every field of every record in the table.
 * NRECS × 13 fields = 13×32 = 416 loads in a single call.
 */
__attribute__((noinline))
static long scan_table(const record_t *table, int n)
{
    long sum = 0;
    for (int i = 0; i < n; ++i) {
        sum += table[i].f0  + table[i].f1  + table[i].f2  + table[i].f3;
        sum += table[i].f4  + table[i].f5  + table[i].f6;
        sum += (long)table[i].f7 + (long)table[i].f8;
        sum += (long)table[i].f9;
        sum += table[i].f10 + table[i].f11 + table[i].f12;
    }
    return sum;  /* 13 loads × NRECS = 416 loads */
}

/*
 * Takes pointers to two records; swaps individual fields.
 * Compiler cannot alias-analyse across the opaque boundary → all kept.
 * 2 × 14 fields × 2 (read both before writing) = 56 loads + 28 stores
 */
__attribute__((noinline))
static void swap_fields(record_t *a, record_t *b)
{
    int   ti;  long tl;  float tf;  double td;
#define SWAPI(F) ti=a->F; a->F=b->F; b->F=ti;
#define SWAPL(F) tl=a->F; a->F=b->F; b->F=tl;
#define SWAPF(F) tf=a->F; a->F=b->F; b->F=tf;
#define SWAPD(F) td=a->F; a->F=b->F; b->F=td;
    SWAPI(f0) SWAPI(f1) SWAPI(f2) SWAPI(f3)
    SWAPL(f4) SWAPL(f5) SWAPL(f6)
    SWAPF(f7) SWAPF(f8)
    SWAPD(f9)
    SWAPI(f10) SWAPI(f11) SWAPI(f12)
#undef SWAPI
#undef SWAPL
#undef SWAPF
#undef SWAPD
}

/* ---- worker ---------------------------------------------------------------- */
typedef struct { int tid; } arg_t;

static void *worker(void *varg)
{
    arg_t *a  = (arg_t *)varg;
    int    id = a->tid;

    /*
     * Stack-allocated record — address taken and passed to noinline functions.
     * Conservative escape analysis will mark this as escaped (address taken).
     * A precise interprocedural analysis could determine it stays thread-local.
     * This is the key test case for your escape analysis pass.
     */
    record_t thread_local_rec;
    memset(&thread_local_rec, 0, sizeof(thread_local_rec));

    for (int iter = 0; iter < ITERATIONS; ++iter) {

        int idx   = (id + iter) % NRECS;
        int idx2  = (id + iter + 1) % NRECS;

        /* update_record on a SHARED record: 42 load/stores — must instrument */
        update_record(&shared_table[idx], id, iter);

        /* update_record on THREAD-LOCAL record: 42 load/stores              */
        /* → your pass should SKIP if it can prove thread_local_rec escapes  */
        /*   only to functions that don't share it between threads            */
        update_record(&thread_local_rec, id, iter);

        /* copy from shared to shared: 28 load/stores — must instrument both */
        copy_record(&shared_table[idx2], &shared_table[idx]);

        /* swap two shared records: 84 load/stores — must instrument          */
        swap_fields(&shared_table[idx], &shared_table[idx2]);

        /* scan whole table: 416 loads — must instrument all                  */
        long cs = scan_table(shared_table, NRECS);
        global_checksum += cs;          /* racy write                        */
    }

    return NULL;
}

int main(void)
{
    pthread_t threads[NUM_THREADS];
    arg_t     args[NUM_THREADS];

    memset(shared_table, 0, sizeof(shared_table));
    global_checksum = 0;

    printf("[O1B3] Struct-field benchmark: %d threads x %d iters\n",
           NUM_THREADS, ITERATIONS);
    printf("       Per-iter loads/stores: ~570 per thread (update+copy+swap+scan)\n");
    printf("       thread_local_rec: test case for your escape analysis\n");

    for (int t = 0; t < NUM_THREADS; ++t) {
        args[t].tid = t;
        pthread_create(&threads[t], NULL, worker, &args[t]);
    }
    for (int t = 0; t < NUM_THREADS; ++t)
        pthread_join(threads[t], NULL);

    printf("[O1B3] Done. global_checksum=%ld\n", global_checksum);
    return 0;
}

/*
 * BUILD & CHECK IR
 * ----------------
 * clang -O1 -pthread -S -emit-llvm o1_bench3_structs.c -o o1b3.ll
 * grep -c "load\|store" o1b3.ll
 * # Expected: 500+ total across all functions
 *
 * KEY QUESTION FOR YOUR PASS
 * --------------------------
 * In worker(), the variable `thread_local_rec` has its address taken:
 *   call update_record(&thread_local_rec, ...)
 *   call copy_record(&shared_table[idx2], &shared_table[idx])  ← NOT passed
 *
 * A conservative escape analysis says: address taken → escapes → instrument.
 * A precise analysis traces the callee and sees update_record only writes
 * through the pointer locally and doesn't store it anywhere → doesn't escape.
 *
 * Measure: how many of the 42 load/stores inside the
 * "update_record(&thread_local_rec,...)" call does your pass skip?
 */
