/*
 * BENCHMARK: SHARED -> OWNED collapse
 *
 * Pattern exercised:
 *   Phase 0  (init)   : main writes buffer[] exclusively
 *                        SA: OWNED(main)
 *                        FT: VarState touched, W = main epoch
 *
 *   Phase 1  (share)  : all NUM_WORKERS threads read buffer[]
 *                        SA: OWNED(main) -> SHARED (first worker, no HB)
 *                            access_vc records all workers
 *                        FT: R transitions to READ_SHARED, Rvc grows
 *
 *   Phase 2  (sync)   : workers finish, main joins all of them
 *                        main.C now dominates every worker epoch
 *                        SA: can_reclaim_ownership() == true for every
 *                            buffer[i] address -> collapses SHARED->OWNED
 *                        FT: stays READ_SHARED, Rvc never cleared
 *
 *   Phase 3  (rewrite): main writes buffer[] exclusively again
 *                        SA: already OWNED(main) -> same-thread fast path
 *                            ZERO FT calls, ZERO VarState lookups
 *                        FT: must check full Rvc for every element
 *                            (READ_SHARED write path: O(n) Rvc scan per write)
 *
 *   Repeat phases 1-3 for NUM_ROUNDS rounds.
 *
 * What this measures:
 *   - Each round forces a SHARED->OWNED collapse (SA) or Rvc scan (FT)
 *   - After collapse, the rewrite phase is O(1) per element in SA
 *     and O(workers) per element in FT (Rvc scan)
 *   - With BUFFER_SIZE=100000 and NUM_ROUNDS=20, the difference is
 *     100000 * 20 * NUM_WORKERS Rvc entries scanned by FT vs
 *     100000 * 20 atomic loads by SA
 *
 * Correctness check:
 *   - buffer[] is always correctly updated: final value must equal
 *     NUM_ROUNDS * (NUM_ROUNDS+1) / 2 for each element
 *   - No races should be reported (all accesses are properly ordered
 *     via pthread_join and pthread_cond)
 *   - If FT reports any race, it is a false positive from stale Rvc state
 */

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <time.h>

#define NUM_WORKERS   4
#define BUFFER_SIZE   100000
#define NUM_ROUNDS    20

/* The shared buffer — main owns it exclusively between rounds */
static long buffer[BUFFER_SIZE];

/*
 * Gate: main signals workers to start reading.
 * Done: workers signal main they finished reading.
 *
 * Using mutex+cond so the LLVM pass instruments lock/unlock
 * and the HB edges are visible to both FT and SA.
 */
static int             round_number  = 0;   /* current round (1-based) */
static int             workers_ready = 0;   /* workers waiting at gate  */
static int             workers_done  = 0;   /* workers finished reading */
static int             gate_open     = 0;   /* main signals start       */
static int             all_done      = 0;   /* main signals shutdown     */
static pthread_mutex_t coord_mtx     = PTHREAD_MUTEX_INITIALIZER;
static pthread_cond_t  gate_cond     = PTHREAD_COND_INITIALIZER;
static pthread_cond_t  done_cond     = PTHREAD_COND_INITIALIZER;

/* Timing */
static uint64_t launch_ns;

static inline uint64_t now_ns() {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000000000ULL + (uint64_t)ts.tv_nsec;
}

/* ── Worker ─────────────────────────────────────────────────────── */
void* worker(void* arg) {
    int id = *(int*)arg;
    long local_sum = 0;   /* private — OWNED(id) throughout, FT never called */
    int  i, r;

    for (r = 0; r < NUM_ROUNDS; r++) {

        /*
         * Wait for main to open the gate for this round.
         * lock acquire gives HB from main's broadcast unlock.
         *
         * After this point:
         *   worker.C[main] >= main's clock at broadcast time
         *   buffer[] was written by main BEFORE locking coord_mtx
         *   so buffer[].owner_epoch > main.C at lock time
         *   => is_ordered(worker, main, buffer_epoch) == FALSE
         *   => buffer[] transitions OWNED(main) -> SHARED
         *      (on first worker that arrives, first access per round)
         */
        pthread_mutex_lock(&coord_mtx);
        while (gate_open != r + 1 && !all_done)
            pthread_cond_wait(&gate_cond, &coord_mtx);
        pthread_mutex_unlock(&coord_mtx);

        if (all_done) break;

        /*
         * READ buffer[] — no lock, intentionally concurrent with other workers.
         *
         * SA path (round 1):
         *   First worker: buffer[i] OWNED(main) -> check is_ordered -> false
         *                 -> promote to SHARED, init access_vc
         *                 -> call FT client (R check passes, no race)
         *   Other workers: buffer[i] already SHARED -> update access_vc
         *                  -> call FT client (concurrent reads, ok)
         *
         * SA path (rounds 2+):
         *   After collapse in previous round, buffer[i] is OWNED(main).
         *   Same story: first worker promotes to SHARED again.
         *   The collapse fires every round after the join.
         *
         * FT path (all rounds):
         *   Round 1: R transitions to READ_SHARED, Rvc accumulates
         *            one entry per worker
         *   Round 2+: R is still READ_SHARED from last round.
         *             Each read must update Rvc[worker_tid] = worker.epoch
         *             The write in phase 3 must scan entire Rvc before writing.
         */
        for (i = 0; i < BUFFER_SIZE; i++) {
            local_sum += buffer[i];   /* concurrent read */
        }

        /* Signal main that this worker finished this round */
        pthread_mutex_lock(&coord_mtx);
        workers_done++;
        pthread_cond_signal(&done_cond);
        pthread_mutex_unlock(&coord_mtx);
    }

    /* Prevent compiler from optimising away local_sum */
    if (local_sum == -1) printf("never\n");
    return NULL;
}

/* ── Main ───────────────────────────────────────────────────────── */
int main() {
    int i, r, w;

    /* Initialise buffer — OWNED(main), no other thread exists */
    for (i = 0; i < BUFFER_SIZE; i++)
        buffer[i] = 0;

    pthread_t threads[NUM_WORKERS];
    int       ids[NUM_WORKERS];

    launch_ns = now_ns();

    for (w = 0; w < NUM_WORKERS; w++) {
        ids[w] = w;
        pthread_create(&threads[w], NULL, worker, &ids[w]);
    }

    for (r = 0; r < NUM_ROUNDS; r++) {

        /*
         * PHASE 2 / PHASE 3 combined (except round 0):
         *
         * Wait for all workers to finish reading from previous round.
         * After all workers signal done, main holds coord_mtx and has
         * HB from every worker's signal unlock.
         *
         * THEN main writes buffer[] — this is the critical moment:
         *
         * SA: can_reclaim_ownership() checks access_vc.
         *     access_vc[w] = worker_w.C[w] for each w that read this round.
         *     main.C[w] >= access_vc[w] for all w (from done signals + joins).
         *     => can_reclaim_ownership() == TRUE
         *     => buffer[i] collapses SHARED -> OWNED(main)
         *     => access_vc cleared, FT state reset
         *     => next write is OWNED same-thread fast path: O(1), no FT call
         *
         * FT: buffer[i].R == READ_SHARED, Rvc has one entry per worker.
         *     Write must scan entire Rvc: O(NUM_WORKERS) per element.
         *     Total: BUFFER_SIZE * NUM_WORKERS Rvc entries checked per round.
         *     With NUM_WORKERS=4, BUFFER_SIZE=100000, NUM_ROUNDS=20:
         *     = 100000 * 4 * 20 = 8,000,000 Rvc entry checks
         *     SA does: 0 (collapsed to OWNED, fast path from round 2+)
         */
        if (r > 0) {
            pthread_mutex_lock(&coord_mtx);
            while (workers_done < NUM_WORKERS)
                pthread_cond_wait(&done_cond, &coord_mtx);
            workers_done = 0;
            pthread_mutex_unlock(&coord_mtx);
        }

        /*
         * Write buffer[] — main exclusively owns it here (after HB from workers).
         *
         * This write happens BEFORE locking coord_mtx for the gate,
         * which is essential: it ensures buffer's write epoch is GREATER
         * than main's clock at broadcast time, making is_ordered() return
         * false when workers arrive — forcing the SHARED promotion each round.
         */
        for (i = 0; i < BUFFER_SIZE; i++) {
            buffer[i] += (r + 1);   /* write — OWNED(main) in SA, Rvc scan in FT */
        }

        /* Open gate for workers to read this round */
        pthread_mutex_lock(&coord_mtx);
        gate_open = r + 1;
        pthread_cond_broadcast(&gate_cond);
        pthread_mutex_unlock(&coord_mtx);
    }

    /* Wait for last round's workers to finish */
    pthread_mutex_lock(&coord_mtx);
    while (workers_done < NUM_WORKERS)
        pthread_cond_wait(&done_cond, &coord_mtx);
    pthread_mutex_unlock(&coord_mtx);

    /* Shutdown workers */
    pthread_mutex_lock(&coord_mtx);
    all_done = 1;
    pthread_cond_broadcast(&gate_cond);
    pthread_mutex_unlock(&coord_mtx);

    for (w = 0; w < NUM_WORKERS; w++)
        pthread_join(threads[w], NULL);

    uint64_t finish_ns = now_ns();

    /* Correctness check */
    long expected = 0;
    for (r = 0; r < NUM_ROUNDS; r++) expected += (r + 1);

    int correct = 1;
    for (i = 0; i < BUFFER_SIZE; i++) {
        if (buffer[i] != expected) {
            printf("CORRECTNESS FAIL: buffer[%d] = %ld, expected %ld\n",
                   i, buffer[i], expected);
            correct = 0;
            break;
        }
    }

    printf("Launch to finish        : %llu ms\n",
           (unsigned long long)((finish_ns - launch_ns) / 1000000ULL));
    printf("Correctness             : %s\n", correct ? "PASS" : "FAIL");
    printf("Expected buffer value   : %ld (each element)\n", expected);
    printf("NUM_ROUNDS              : %d\n", NUM_ROUNDS);
    printf("BUFFER_SIZE             : %d\n", BUFFER_SIZE);
    printf("NUM_WORKERS             : %d\n", NUM_WORKERS);
    printf("\n--- What each tool does per round ---\n");
    printf("SA rewrite phase : OWNED fast path after collapse"
           " -> 0 FT calls per element\n");
    printf("FT rewrite phase : READ_SHARED write -> scan Rvc"
           " (%d entries) per element\n", NUM_WORKERS);
    printf("FT total Rvc scans : %d\n",
           BUFFER_SIZE * NUM_WORKERS * (NUM_ROUNDS - 1));

    return 0;
}