/**
 * benchmark_workload.cpp
 * ─────────────────────────────────────────────────────────────────────────────
 * PURPOSE
 *   Heavy multi-phase benchmark designed to answer three quantitative questions:
 *
 *   Q1. What percentage of total loads/stores are on shared memory?
 *       → Run uninstrumented, compare per-thread private work vs shared-data
 *         coordination work.  The ratio tells you the theoretical upper bound
 *         on how much instrumentation your sharing analysis can eliminate.
 *
 *   Q2. What is the actual performance overhead of the instrumented build
 *       vs the uninstrumented build?
 *       → Measure wall-clock time with and without the LLVM pass.
 *
 *   Q3. Does the analysis agree with ground truth?  (Runs a self-check that
 *       counts expected shared vs private accesses, printed at end.)
 *
 * BUILD
 *   # Uninstrumented (baseline):
 *   g++ -O1 -g -pthread -DINST=0 benchmark_workload.cpp -o bench_base
 *
 *   # With your pass (instrumented):
 *   clang++ -O1 -g -pthread -DINST=1 -fpass-plugin=./RaceDetector.so \
 *           benchmark_workload.cpp -o bench_inst
 *
 *   # Quick sanity build (no pass):
 *   g++ -O2 -pthread benchmark_workload.cpp -o bench_base
 *
 * RUN
 *   ./bench_base [nthreads] [scale]
 *       nthreads  default 4
 *       scale     default 1  (multiply inner loop counts by scale)
 *
 * PHASES
 *   Phase A — Private matrix multiply
 *       Each thread allocates its own NxN matrix, does a full multiply into a
 *       private result matrix.  The result is accumulated into ONE shared
 *       checksum at the end under a mutex.
 *       Shared accesses  : 1 mutex lock/unlock + 1 atomic add per thread
 *       Private accesses : N^3 multiply-accumulate per thread  (HUGE)
 *       → Analysis MUST classify the N×N matrices as private.
 *
 *   Phase B — Producer-consumer queue (single shared queue, many producers)
 *       P producer threads enqueue 'work items' into a shared circular ring
 *       buffer under a spinlock; C consumer threads dequeue and process them.
 *       Processing is done on a private scratch buffer.
 *       Shared accesses  : queue head/tail pointers + item slots
 *       Private accesses : scratch buffer processing (HUGE per item)
 *       → Queue internals must be shared; scratch buffers must be private.
 *
 *   Phase C — Red-black tree concurrent insert/lookup
 *       A shared balanced BST protected by a single reader-writer lock.
 *       Inserts are rare; lookups are frequent.
 *       All tree node pointers and fields are shared.
 *       Each thread has a private result array for lookup results.
 *       → Tree nodes: shared.  Result arrays: private.
 *
 *   Phase D — False-sharing stress test
 *       N threads each write to a separate int in a cache-line-sized array
 *       (all ints in one cache line) vs a padded array (one int per cache line).
 *       Both are SHARED by address but only the padded version avoids false
 *       sharing.  This tests whether instrumentation overhead is proportional
 *       to shared-memory access volume.
 *
 * OUTPUT FORMAT (machine-parseable lines prefixed with "METRIC"):
 *   METRIC phase  threads  scale  wall_ms  expected_shared_accesses  expected_private_accesses
 *
 * ─────────────────────────────────────────────────────────────────────────────
 */

#include <pthread.h>
#include <semaphore.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>
#include <time.h>
#include <assert.h>
#include <atomic>
#include <chrono>
#include <algorithm>

/* ─── Timing ─────────────────────────────────────────────────────────────── */
static double now_ms() {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return ts.tv_sec * 1000.0 + ts.tv_nsec / 1e6;
}

/* ─── CLI ────────────────────────────────────────────────────────────────── */
static int  G_NTHREADS = 4;
static int  G_SCALE    = 1;

/* ─── Shared counter (used to verify correctness) ───────────────────────── */
static std::atomic<long> g_checksum{0};

/* ═══════════════════════════════════════════════════════════════════════════
 * PHASE A  —  Private matrix multiply + shared checksum
 * ═══════════════════════════════════════════════════════════════════════════ */

#define MAT_N 128    /* 128×128 float matrix per thread */

struct PhaseA_Args {
    int thread_id;
    long private_accesses;   /* filled by thread */
    long shared_accesses;
};

static void matmul(const float *A, const float *B, float *C, int n) {
    /* C = A*B  (n×n dense, row-major) */
    for (int i = 0; i < n; i++) {
        for (int k = 0; k < n; k++) {
            float aik = A[i*n+k];
            for (int j = 0; j < n; j++) {
                C[i*n+j] += aik * B[k*n+j];
            }
        }
    }
}

static void *phaseA_worker(void *arg) {
    PhaseA_Args *a = (PhaseA_Args *)arg;
    const int n = MAT_N * G_SCALE;

    /* All these allocations are THREAD-PRIVATE – analysis must classify as such */
    float *A = (float *)calloc(n*n, sizeof(float));
    float *B = (float *)calloc(n*n, sizeof(float));
    float *C = (float *)calloc(n*n, sizeof(float));

    /* Initialise with deterministic data */
    for (int i = 0; i < n*n; i++) {
        A[i] = (float)(i % 17) * 0.01f;
        B[i] = (float)(i % 13) * 0.01f;
    }

    /* Private: n^3 multiply-accumulate operations */
    matmul(A, B, C, n);

    /* One shared access: accumulate sum into global checksum */
    float local_sum = 0.0f;
    for (int i = 0; i < n*n; i++) local_sum += C[i];   /* private reduction */
    g_checksum.fetch_add((long)(local_sum * 1000), std::memory_order_relaxed);  /* shared */

    a->private_accesses = (long)n*n*n * 3 + (long)n*n*2;   /* approx reads+writes */
    a->shared_accesses  = 1;                                /* the atomic add */

    free(A); free(B); free(C);
    return nullptr;
}

static void run_phase_A() {
    printf("\n── PHASE A  Private matrix multiply  (N=%d, threads=%d) ──\n",
           MAT_N*G_SCALE, G_NTHREADS);

    PhaseA_Args *args = (PhaseA_Args *)calloc(G_NTHREADS, sizeof(PhaseA_Args));
    pthread_t *threads = (pthread_t *)malloc(G_NTHREADS * sizeof(pthread_t));
    g_checksum = 0;

    double t0 = now_ms();
    for (int i = 0; i < G_NTHREADS; i++) {
        args[i].thread_id = i;
        pthread_create(&threads[i], nullptr, phaseA_worker, &args[i]);
    }
    for (int i = 0; i < G_NTHREADS; i++) pthread_join(threads[i], nullptr);
    double elapsed = now_ms() - t0;

    long total_private = 0, total_shared = 0;
    for (int i = 0; i < G_NTHREADS; i++) {
        total_private += args[i].private_accesses;
        total_shared  += args[i].shared_accesses;
    }
    long total = total_private + total_shared;
    printf("  wall_ms          : %.1f\n",  elapsed);
    printf("  private_accesses : %ld  (%.2f%%)\n", total_private, 100.0*total_private/total);
    printf("  shared_accesses  : %ld  (%.2f%%)\n", total_shared,  100.0*total_shared/total);
    printf("  checksum         : %ld\n", g_checksum.load());
    printf("METRIC A %d %d %.1f %ld %ld\n",
           G_NTHREADS, G_SCALE, elapsed, total_shared, total_private);

    free(args); free(threads);
}

/* ═══════════════════════════════════════════════════════════════════════════
 * PHASE B  —  Producer-consumer queue
 * ═══════════════════════════════════════════════════════════════════════════ */

#define QUEUE_CAP   (1 << 14)    /* 16384 slots */
#define ITEM_SIZE   64           /* bytes per work item payload */
#define SCRATCH_N   4096         /* private scratch buffer size */

struct WorkItem {
    int  producer_id;
    int  seq;
    char payload[ITEM_SIZE - 8];
};

struct RingQueue {
    WorkItem   slots[QUEUE_CAP];   /* shared */
    volatile int head;             /* shared */
    volatile int tail;             /* shared */
    pthread_mutex_t lock;       /* shared */
    std::atomic<int> done_producing{0};   /* shared */
};

static RingQueue *g_queue;

static int q_push(RingQueue *q, const WorkItem *item) {
    pthread_mutex_lock(&q->lock);
    int next = (q->tail + 1) & (QUEUE_CAP - 1);
    if (next == q->head) { pthread_mutex_unlock(&q->lock); return 0; /* full */ }
    q->slots[q->tail] = *item;
    q->tail = next;
    pthread_mutex_unlock(&q->lock);
    return 1;
}

static int q_pop(RingQueue *q, WorkItem *out) {
    pthread_mutex_lock(&q->lock);
    if (q->head == q->tail) { pthread_mutex_unlock(&q->lock); return 0; }
    *out = q->slots[q->head];
    q->head = (q->head + 1) & (QUEUE_CAP - 1);
    pthread_mutex_unlock(&q->lock);
    return 1;
}

struct PhaseB_ProducerArgs { int id; int items_to_produce; long shared_acc; };
struct PhaseB_ConsumerArgs { int id; long items_consumed; long private_acc; long shared_acc; };

static void *phaseB_producer(void *arg) {
    PhaseB_ProducerArgs *a = (PhaseB_ProducerArgs *)arg;
    WorkItem item;
    item.producer_id = a->id;
    long shared = 0;
    for (int i = 0; i < a->items_to_produce; i++) {
        item.seq = i;
        memset(item.payload, (char)(i & 0xFF), sizeof(item.payload));
        while (!q_push(g_queue, &item)) sched_yield();
        shared += 4;   /* head, tail, slots[tail], lock: ~4 shared accesses per push */
    }
    a->shared_acc = shared;
    return nullptr;
}

static void *phaseB_consumer(void *arg) {
    PhaseB_ConsumerArgs *a = (PhaseB_ConsumerArgs *)arg;
    /* Private scratch buffer – must NOT be instrumented */
    int *scratch = (int *)malloc(SCRATCH_N * sizeof(int));
    WorkItem item;
    long items = 0, private_acc = 0, shared_acc = 0;
    while (true) {
        if (q_pop(g_queue, &item)) {
            /* Private processing of the item on scratch buffer */
            for (int i = 0; i < SCRATCH_N; i++)
                scratch[i] = (int)(item.payload[i & (ITEM_SIZE-9)] ^ (i & 0xFF));
            /* Private: compute checksum of scratch */
            long s = 0;
            for (int i = 0; i < SCRATCH_N; i++) s += scratch[i];
            g_checksum.fetch_add(s, std::memory_order_relaxed);
            items++;
            private_acc += SCRATCH_N * 2;   /* scratch reads + writes */
            shared_acc  += 5;               /* queue pop + global checksum */
        } else {
            if (g_queue->done_producing.load(std::memory_order_acquire)) {
                /* Drain remaining items */
                while (q_pop(g_queue, &item)) {
                    items++;
                    shared_acc += 5;
                }
                break;
            }
            sched_yield();
        }
    }
    a->items_consumed = items;
    a->private_acc    = private_acc;
    a->shared_acc     = shared_acc;
    free(scratch);
    return nullptr;
}

static void run_phase_B() {
    const int n_prod = G_NTHREADS / 2 > 0 ? G_NTHREADS / 2 : 1;
    const int n_cons = G_NTHREADS - n_prod;
    const int items_per_producer = 2000 * G_SCALE;

    printf("\n── PHASE B  Producer-consumer queue  (prod=%d, cons=%d, items=%d each) ──\n",
           n_prod, n_cons, items_per_producer);

    g_queue = (RingQueue *)calloc(1, sizeof(RingQueue));
    pthread_mutex_init(&g_queue->lock,nullptr);
    g_checksum = 0;

    PhaseB_ProducerArgs *pargs = (PhaseB_ProducerArgs *)calloc(n_prod, sizeof(*pargs));
    PhaseB_ConsumerArgs *cargs = (PhaseB_ConsumerArgs *)calloc(n_cons, sizeof(*cargs));
    pthread_t *prod_t = (pthread_t *)malloc(n_prod * sizeof(pthread_t));
    pthread_t *cons_t = (pthread_t *)malloc(n_cons * sizeof(pthread_t));

    double t0 = now_ms();
    for (int i = 0; i < n_cons; i++) {
        cargs[i].id = i;
        pthread_create(&cons_t[i], nullptr, phaseB_consumer, &cargs[i]);
    }
    for (int i = 0; i < n_prod; i++) {
        pargs[i].id = i;
        pargs[i].items_to_produce = items_per_producer;
        pthread_create(&prod_t[i], nullptr, phaseB_producer, &pargs[i]);
    }
    for (int i = 0; i < n_prod; i++) pthread_join(prod_t[i], nullptr);
    g_queue->done_producing.store(1, std::memory_order_release);
    for (int i = 0; i < n_cons; i++) pthread_join(cons_t[i], nullptr);
    double elapsed = now_ms() - t0;

    long total_private = 0, total_shared = 0;
    for (int i = 0; i < n_prod; i++) total_shared  += pargs[i].shared_acc;
    for (int i = 0; i < n_cons; i++) {
        total_private += cargs[i].private_acc;
        total_shared  += cargs[i].shared_acc;
    }
    long total = total_private + total_shared;
    printf("  wall_ms          : %.1f\n",  elapsed);
    printf("  private_accesses : %ld  (%.2f%%)\n", total_private, 100.0*total_private/total);
    printf("  shared_accesses  : %ld  (%.2f%%)\n", total_shared,  100.0*total_shared/total);
    printf("METRIC B %d %d %.1f %ld %ld\n",
           G_NTHREADS, G_SCALE, elapsed, total_shared, total_private);

    pthread_mutex_destroy(&g_queue->lock);
    free(g_queue); free(pargs); free(cargs); free(prod_t); free(cons_t);
}

/* ═══════════════════════════════════════════════════════════════════════════
 * PHASE C  —  Shared sorted linked list (RW-locked)
 * Using a simple sorted singly-linked list instead of an RB-tree
 * to keep the code focused on the sharing pattern, not data structure impl.
 * ═══════════════════════════════════════════════════════════════════════════ */

struct ListNode {
    int key;
    int value;
    ListNode *next;
};

struct SharedList {
    ListNode *head;          /* shared */
    pthread_rwlock_t rw;     /* shared */
};

static SharedList g_list;

static void list_insert(SharedList *L, int key, int val) {
    ListNode *node = (ListNode *)malloc(sizeof(ListNode));
    node->key = key; node->value = val;
    pthread_rwlock_wrlock(&L->rw);
    /* Insert sorted */
    ListNode **pp = &L->head;
    while (*pp && (*pp)->key < key) pp = &(*pp)->next;
    node->next = *pp;
    *pp = node;
    pthread_rwlock_unlock(&L->rw);
}

static int list_lookup(SharedList *L, int key) {
    pthread_rwlock_rdlock(&L->rw);
    ListNode *cur = L->head;
    while (cur && cur->key < key) cur = cur->next;
    int found = (cur && cur->key == key) ? cur->value : -1;
    pthread_rwlock_unlock(&L->rw);
    return found;
}

static void list_destroy(SharedList *L) {
    ListNode *cur = L->head;
    while (cur) { ListNode *next = cur->next; free(cur); cur = next; }
    L->head = nullptr;
}

struct PhaseC_Args {
    int id;
    int n_inserts;
    int n_lookups;
    long shared_acc;
    long private_acc;
};

static void *phaseC_worker(void *arg) {
    PhaseC_Args *a = (PhaseC_Args *)arg;
    /* Private result buffer */
    int *results = (int *)malloc(a->n_lookups * sizeof(int));
    long shared = 0, priv = 0;

    /* Inserts (write lock) */
    for (int i = 0; i < a->n_inserts; i++) {
        int key = (a->id * 10000 + i) & 0x7FFFFFFF;
        list_insert(&g_list, key, a->id);
        shared += 4;   /* head ptr, node fields, rw-lock: ~4 shared per insert */
    }

    /* Lookups (read lock) */
    for (int i = 0; i < a->n_lookups; i++) {
        int key = (a->id * 10000 + (i % a->n_inserts)) & 0x7FFFFFFF;
        results[i] = list_lookup(&g_list, key);
        shared += 3;   /* traverse shared node chain */
        priv   += 1;   /* store result in private array */
    }

    /* Private sum of results */
    long sum = 0;
    for (int i = 0; i < a->n_lookups; i++) sum += results[i];
    g_checksum.fetch_add(sum, std::memory_order_relaxed);
    priv += a->n_lookups;

    a->shared_acc  = shared;
    a->private_acc = priv;
    free(results);
    return nullptr;
}

static void run_phase_C() {
    const int n_inserts = 200  * G_SCALE;
    const int n_lookups = 2000 * G_SCALE;

    printf("\n── PHASE C  RW-locked sorted list  (threads=%d, ins=%d, lkp=%d) ──\n",
           G_NTHREADS, n_inserts, n_lookups);

    g_list.head = nullptr;
    pthread_rwlock_init(&g_list.rw, nullptr);
    g_checksum = 0;

    PhaseC_Args *args = (PhaseC_Args *)calloc(G_NTHREADS, sizeof(*args));
    pthread_t *threads = (pthread_t *)malloc(G_NTHREADS * sizeof(pthread_t));

    double t0 = now_ms();
    for (int i = 0; i < G_NTHREADS; i++) {
        args[i].id = i;
        args[i].n_inserts = n_inserts;
        args[i].n_lookups = n_lookups;
        pthread_create(&threads[i], nullptr, phaseC_worker, &args[i]);
    }
    for (int i = 0; i < G_NTHREADS; i++) pthread_join(threads[i], nullptr);
    double elapsed = now_ms() - t0;

    long total_private = 0, total_shared = 0;
    for (int i = 0; i < G_NTHREADS; i++) {
        total_private += args[i].private_acc;
        total_shared  += args[i].shared_acc;
    }
    long total = total_private + total_shared;
    printf("  wall_ms          : %.1f\n",  elapsed);
    printf("  private_accesses : %ld  (%.2f%%)\n", total_private, 100.0*total_private/total);
    printf("  shared_accesses  : %ld  (%.2f%%)\n", total_shared,  100.0*total_shared/total);
    printf("METRIC C %d %d %.1f %ld %ld\n",
           G_NTHREADS, G_SCALE, elapsed, total_shared, total_private);

    list_destroy(&g_list);
    pthread_rwlock_destroy(&g_list.rw);
    free(args); free(threads);
}

/* ═══════════════════════════════════════════════════════════════════════════
 * PHASE D  —  False-sharing vs. padded array stress test
 * ═══════════════════════════════════════════════════════════════════════════ */

#define CACHE_LINE 64
#define ITERS_D    (10000000 * G_SCALE)  /* must use G_SCALE at runtime */

/* Packed: all thread counters in one cache line (false sharing) */
struct PackedCounters {
    int val[16];       /* 16 threads max, 4 bytes each = 64 bytes */
};

/* Padded: each thread counter on its own cache line */
struct alignas(CACHE_LINE) PaddedCounter {
    int val;
    char pad[CACHE_LINE - sizeof(int)];
};

static PackedCounters g_packed;
static PaddedCounter  g_padded[16];

struct PhaseD_Args {
    int id;
    int iters;
    double time_packed_ms;
    double time_padded_ms;
};

static void *phaseD_packed(void *arg) {
    PhaseD_Args *a = (PhaseD_Args *)arg;
    double t0 = now_ms();
    for (int i = 0; i < a->iters; i++) g_packed.val[a->id]++;   /* false sharing */
    a->time_packed_ms = now_ms() - t0;
    return nullptr;
}

static void *phaseD_padded(void *arg) {
    PhaseD_Args *a = (PhaseD_Args *)arg;
    double t0 = now_ms();
    for (int i = 0; i < a->iters; i++) g_padded[a->id].val++;   /* no false sharing */
    a->time_padded_ms = now_ms() - t0;
    return nullptr;
}

static void run_phase_D() {
    int iters_d = 10000000 * G_SCALE;
    printf("\n── PHASE D  False-sharing benchmark  (threads=%d, iters=%d) ──\n",
           G_NTHREADS, iters_d);

    PhaseD_Args *args = (PhaseD_Args *)calloc(G_NTHREADS, sizeof(*args));
    pthread_t *threads = (pthread_t *)malloc(G_NTHREADS * sizeof(pthread_t));

    memset(&g_packed, 0, sizeof(g_packed));
    memset(g_padded,  0, sizeof(g_padded));

    for (int i = 0; i < G_NTHREADS; i++) {
        args[i].id = i;
        args[i].iters = iters_d;
    }

    /* Run packed version */
    double t0 = now_ms();
    for (int i = 0; i < G_NTHREADS; i++)
        pthread_create(&threads[i], nullptr, phaseD_packed, &args[i]);
    for (int i = 0; i < G_NTHREADS; i++) pthread_join(threads[i], nullptr);
    double packed_wall = now_ms() - t0;

    /* Run padded version */
    t0 = now_ms();
    for (int i = 0; i < G_NTHREADS; i++)
        pthread_create(&threads[i], nullptr, phaseD_padded, &args[i]);
    for (int i = 0; i < G_NTHREADS; i++) pthread_join(threads[i], nullptr);
    double padded_wall = now_ms() - t0;

    /*
     * Both versions access SHARED memory (the arrays are global), so BOTH
     * should be instrumented by the race detector.
     * However, g_padded gives each thread its own cache line:
     *   - in the INSTRUMENTED build the overhead should be roughly equal
     *     (same number of shared accesses)
     *   - in the UNINSTRUMENTED build padded >> packed performance-wise
     * A big gap between packed_wall and padded_wall in the uninstrumented
     * build shows the false-sharing effect clearly.
     */
    printf("  packed_wall_ms   : %.1f\n",  packed_wall);
    printf("  padded_wall_ms   : %.1f\n",  padded_wall);
    printf("  speedup (padded) : %.2fx\n", packed_wall / padded_wall);
    printf("  NOTE: both arrays ARE shared → both should be instrumented\n");
    printf("  NOTE: speedup collapse under instrumentation = overhead dominates\n");

    /* Access counts: each thread does iters_d writes to one shared element */
    long shared = (long)G_NTHREADS * iters_d * 2;   /* packed + padded */
    long priv   = 0;
    printf("METRIC D %d %d %.1f+%.1f %ld %ld\n",
           G_NTHREADS, G_SCALE, packed_wall, padded_wall, shared, priv);

    free(args); free(threads);
}

/* ═══════════════════════════════════════════════════════════════════════════
 * SUMMARY  —  Print instrumentation ratio across all phases
 * ═══════════════════════════════════════════════════════════════════════════ */
static void print_summary(
    long A_sh, long A_pr,
    long B_sh, long B_pr,
    long C_sh, long C_pr,
    long D_sh, long D_pr)
{
    long total_sh = A_sh + B_sh + C_sh + D_sh;
    long total_pr = A_pr + B_pr + C_pr + D_pr;
    long total    = total_sh + total_pr;

    printf("\n╔══════════════════════════════════════════════════════════╗\n");
    printf("║              INSTRUMENTATION RATIO SUMMARY               ║\n");
    printf("╠══════════════════════════════════════════════════════════╣\n");
    printf("║  Phase  │ Shared accesses │ Private accesses │  Ratio    ║\n");
    printf("╠══════════════════════════════════════════════════════════╣\n");
    auto pct = [](long s, long p) -> double {
        return (s+p) > 0 ? 100.0*s/(s+p) : 0.0;
    };
    printf("║  A      │ %15ld │ %16ld │ %5.2f%%   ║\n", A_sh, A_pr, pct(A_sh,A_pr));
    printf("║  B      │ %15ld │ %16ld │ %5.2f%%   ║\n", B_sh, B_pr, pct(B_sh,B_pr));
    printf("║  C      │ %15ld │ %16ld │ %5.2f%%   ║\n", C_sh, C_pr, pct(C_sh,C_pr));
    printf("║  D      │ %15ld │ %16ld │ %5.2f%%   ║\n", D_sh, D_pr, pct(D_sh,D_pr));
    printf("╠══════════════════════════════════════════════════════════╣\n");
    printf("║  TOTAL  │ %15ld │ %16ld │ %5.2f%%   ║\n", total_sh, total_pr, pct(total_sh,total_pr));
    printf("╠══════════════════════════════════════════════════════════╣\n");
    printf("║  Max instrumentation reduction if sharing analysis        ║\n");
    printf("║  perfectly classifies private accesses:  %.1f%%           ║\n",
           100.0 * total_pr / (total > 0 ? total : 1));
    printf("╚══════════════════════════════════════════════════════════╝\n");
    printf("\n");
    printf("INTERPRETATION:\n");
    printf("  * 'Shared accesses' = accesses your detector MUST see.\n");
    printf("  * 'Private accesses' = accesses analysis CAN safely skip.\n");
    printf("  * Phase A has very low shared ratio → large speedup potential.\n");
    printf("  * Phase D is all shared → no speedup possible; tests overhead.\n");
    printf("  * Actual speedup = (1 - instrumented_frac) × overhead_per_access.\n");
}

/* ─────────────────────────────────────────────────────────────────────────── */
int main(int argc, char **argv) {
    if (argc > 1) G_NTHREADS = std::max(1, atoi(argv[1]));
    if (argc > 2) G_SCALE    = std::max(1, atoi(argv[2]));
    if (G_NTHREADS > 16) { fprintf(stderr, "max 16 threads\n"); G_NTHREADS = 16; }

    printf("\n╔════════════════════════════════════════════╗\n");
    printf("║  benchmark_workload  —  sharing ratio test  ║\n");
    printf("║  threads=%-4d  scale=%-4d                   ║\n", G_NTHREADS, G_SCALE);
    printf("╚════════════════════════════════════════════╝\n");

    /* ── Phase A ── */
    long A_sh = 0, A_pr = 0;
    {
        PhaseA_Args *args = (PhaseA_Args *)calloc(G_NTHREADS, sizeof(PhaseA_Args));
        pthread_t *threads = (pthread_t *)malloc(G_NTHREADS * sizeof(pthread_t));
        g_checksum = 0;
        for (int i = 0; i < G_NTHREADS; i++) {
            args[i].thread_id = i;
            pthread_create(&threads[i], nullptr, phaseA_worker, &args[i]);
        }
        for (int i = 0; i < G_NTHREADS; i++) pthread_join(threads[i], nullptr);
        for (int i = 0; i < G_NTHREADS; i++) {
            A_sh += args[i].shared_accesses;
            A_pr += args[i].private_accesses;
        }
        printf("\n── PHASE A  Private matrix multiply  (N=%d, threads=%d) ──\n",
               MAT_N*G_SCALE, G_NTHREADS);
        printf("  private_accesses : %ld  (%.2f%%)\n", A_pr, 100.0*A_pr/(A_sh+A_pr));
        printf("  shared_accesses  : %ld  (%.2f%%)\n", A_sh, 100.0*A_sh/(A_sh+A_pr));
        free(args); free(threads);
    }

    /* ── Phase B ── */
    run_phase_B();
    /* Read METRIC from stdout is external; re-capture here approximately */
    long B_sh = 0, B_pr = 0;
    /* (Values printed inline by run_phase_B; reassemble conservatively) */
    {
        int n_prod = G_NTHREADS / 2 > 0 ? G_NTHREADS / 2 : 1;
        int n_cons = G_NTHREADS - n_prod;
        int ipp    = 2000 * G_SCALE;
        B_sh = (long)(n_prod * ipp * 4) + (long)(n_cons * ipp * 5);
        B_pr = (long)(n_cons * ipp * SCRATCH_N * 2);
    }

    /* ── Phase C ── */
    run_phase_C();
    long C_sh = 0, C_pr = 0;
    {
        int ins = 200 * G_SCALE, lkp = 2000 * G_SCALE;
        C_sh = (long)G_NTHREADS * (ins * 4 + lkp * 3);
        C_pr = (long)G_NTHREADS * lkp * 2;
    }

    /* ── Phase D ── */
    run_phase_D();
    long D_sh = (long)G_NTHREADS * 10000000LL * G_SCALE * 2;
    long D_pr = 0;

    print_summary(A_sh, A_pr, B_sh, B_pr, C_sh, C_pr, D_sh, D_pr);
    return 0;
}
