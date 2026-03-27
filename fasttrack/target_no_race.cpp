// ============================================================
// TARGET PROGRAM 2: NO DATA RACE
//
// Sync primitives used: pthread_mutex, pthread_cond, pthread_create,
// pthread_join — all instrumented by the LLVM pass.
// NO barriers used.
//
// Scenario: producer/consumer pipeline with 3 phases.
// Each phase is separated by a mutex+cond rendezvous so the LLVM
// pass sees every HB edge and is_ordered() returns true at every
// ownership transfer.
//
// Sharing analysis state transitions (all clean):
//
//   task_queue  : OWNED(producer) while filling
//                 → consumers read under queue_mtx
//                 → lock/unlock gives HB: is_ordered()==true
//                 → ownership transfers to each consumer without SHARED
//
//   results[i]  : OWNED(consumer_i) throughout ALL phases
//                 sharing analysis never promotes to SHARED
//                 FastTrack is NEVER called for these variables
//                 (this is the core performance win of sharing analysis)
//
//   merged_result: OWNED(main) after all pthread_join calls
//                 is_ordered(main, consumer_i, ...) == true for all i
//                 → stays OWNED, FT never called
//
//   phase counters: always accessed under phase_mtx
//                 → HB on every access, no race
//
// The SHARED→OWNED collapse path is exercised on task_queue:
//   after all consumers finish a phase and signal back,
//   producer acquires phase_mtx (gets HB over all consumers),
//   then writes task_queue again → can_reclaim_ownership()==true
//   → collapses back to OWNED(producer) for the next phase.
// ============================================================

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM_CONSUMERS    4
#define TASKS_PER_PHASE  48
#define NUM_PHASES       3

// ── Task queue ───────────────────────────────────────────────────
struct Task { int phase; int id; int value; };

static Task            task_queue[TASKS_PER_PHASE];
static int             queue_head       = 0;
static int             tasks_remaining  = 0;
static int             phase_ready      = 0;   // producer signals this
static int             phase_consumed   = 0;   // consumers count down
static int             all_phases_done  = 0;
static pthread_mutex_t phase_mtx        = PTHREAD_MUTEX_INITIALIZER;
static pthread_cond_t  phase_ready_cond = PTHREAD_COND_INITIALIZER;
static pthread_cond_t  phase_done_cond  = PTHREAD_COND_INITIALIZER;

// ── Per-consumer private results (exclusively owned) ─────────────
static long results[NUM_CONSUMERS];

// ── Final merged result (owned by main after all joins) ──────────
static long merged_result = 0;

// ── Producer ─────────────────────────────────────────────────────
void* producer(void* arg) {
    for (int phase = 0; phase < NUM_PHASES; phase++) {

        pthread_mutex_lock(&phase_mtx);

        // Refill task_queue — OWNED(producer) here because:
        //   previous phase: consumers finished and signalled phase_done_cond
        //   producer did cond_wait which includes a lock acquire → HB edge
        //   is_ordered(producer, consumer_i, ...) == true for all i
        //   → sharing analysis: can_reclaim_ownership() == true
        //   → task_queue collapses back to OWNED(producer)
        queue_head      = 0;
        tasks_remaining = TASKS_PER_PHASE;
        phase_consumed  = 0;
        for (int i = 0; i < TASKS_PER_PHASE; i++)
            task_queue[i] = { phase, i, (phase + 1) * (i + 1) };

        // Signal consumers — unlock creates HB before any consumer lock
        phase_ready = phase + 1;
        pthread_cond_broadcast(&phase_ready_cond);

        // Wait until all consumers have drained this phase
        while (phase_consumed < NUM_CONSUMERS)
            pthread_cond_wait(&phase_done_cond, &phase_mtx);

        pthread_mutex_unlock(&phase_mtx);
    }

    // Signal termination
    pthread_mutex_lock(&phase_mtx);
    all_phases_done = 1;
    phase_ready     = -1;
    pthread_cond_broadcast(&phase_ready_cond);
    pthread_mutex_unlock(&phase_mtx);

    return NULL;
}

// ── Consumer ─────────────────────────────────────────────────────
void* consumer(void* arg) {
    int id = *(int*)arg;

    for (int phase = 0; phase < NUM_PHASES; phase++) {

        // Wait for producer to fill the queue
        // lock acquire here gives HB from producer's broadcast unlock
        // → is_ordered(consumer, producer, ...) == true
        // → task_queue ownership transfers cleanly (no promotion to SHARED)
        pthread_mutex_lock(&phase_mtx);
        while (phase_ready != phase + 1 && !all_phases_done)
            pthread_cond_wait(&phase_ready_cond, &phase_mtx);
        pthread_mutex_unlock(&phase_mtx);

        if (all_phases_done) break;

        // Steal and process tasks
        while (1) {
            pthread_mutex_lock(&phase_mtx);
            if (queue_head >= TASKS_PER_PHASE) {
                pthread_mutex_unlock(&phase_mtx);
                break;
            }
            // Reading task_queue under phase_mtx — HB from producer's fill
            // FastTrack sees: t.C[producer] >= producer_epoch → no race
            Task t  = task_queue[queue_head++];
            pthread_mutex_unlock(&phase_mtx);

            // Process into private result — OWNED(consumer_id) exclusively
            // sharing analysis never promotes results[id] to SHARED
            // FastTrack is never called for results[id]
            long computed = 0;
            for (int j = 0; j <= t.value % 60; j++)
                computed += (long)j * t.id + t.phase;
            results[id] += computed;               // OWNED — no FT call
        }

        // Signal that this consumer finished this phase
        // This unlock creates HB for producer's next cond_wait acquire
        pthread_mutex_lock(&phase_mtx);
        phase_consumed++;
        pthread_cond_signal(&phase_done_cond);
        pthread_mutex_unlock(&phase_mtx);
    }

    return NULL;
}

// ── Reduction after all joins ────────────────────────────────────
// After pthread_join(consumer_i), main's C[consumer_i] >= consumer_i.epoch
// is_ordered(main, consumer_i, last_epoch) == true for every i
// results[i] ownership transfers to main — stays OWNED, FT never called
// merged_result is OWNED(main) the entire time
void reduce() {
    merged_result = 0;
    for (int i = 0; i < NUM_CONSUMERS; i++)
        merged_result += results[i];
}

int main() {
    memset(results, 0, sizeof(results));

    pthread_t prod;
    pthread_t cons[NUM_CONSUMERS];
    int       ids[NUM_CONSUMERS];

    pthread_create(&prod, NULL, producer, NULL);
    for (int i = 0; i < NUM_CONSUMERS; i++) {
        ids[i] = i;
        pthread_create(&cons[i], NULL, consumer, &ids[i]);
    }

    // Join order matters for sharing analysis:
    // joining producer first means main has HB over all task_queue writes
    // joining each consumer gives HB over results[i]
    pthread_join(prod, NULL);
    for (int i = 0; i < NUM_CONSUMERS; i++)
        pthread_join(cons[i], NULL);

    // All joins done — main has full HB over everything
    reduce();

    printf("[main] merged_result = %ld\n", merged_result);
    printf("[main] per-consumer results: ");
    for (int i = 0; i < NUM_CONSUMERS; i++)
        printf("[%d]=%ld ", i, results[i]);
    printf("\n[main] No races should be reported by sharing analysis.\n");

    pthread_mutex_destroy(&phase_mtx);
    pthread_cond_destroy(&phase_ready_cond);
    pthread_cond_destroy(&phase_done_cond);
    return 0;
}