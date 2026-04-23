// ============================================================
// TARGET PROGRAM 1: HAS DATA RACE
// ============================================================

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>

#define NUM_WORKERS  4
#define BUF_SIZE     1024
#define CHUNK        (BUF_SIZE / NUM_WORKERS)

static int  shared_buf[BUF_SIZE];
static long accumulator = 0;        // ← RACE: no lock
static int  done_flag   = 0;        // ← RACE: no sync with monitor

static long             safe_counter = 0;
static pthread_mutex_t  safe_mtx     = PTHREAD_MUTEX_INITIALIZER;

// ── Manual phase gate (replaces barrier) ────────────────────────
// main uses this to release all workers at the same time.
static int             gate_open    = 0;
static pthread_mutex_t gate_mtx     = PTHREAD_MUTEX_INITIALIZER;
static pthread_cond_t  gate_cond    = PTHREAD_COND_INITIALIZER;

// workers signal back when they are done
static int             workers_done = 0;
static pthread_mutex_t done_mtx     = PTHREAD_MUTEX_INITIALIZER;
static pthread_cond_t  done_cond    = PTHREAD_COND_INITIALIZER;

struct WorkerArg { int id; int start; int end; };

// ── Timing ────────────────────────────────────────────────────────
static inline uint64_t now_ns() {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000000000ULL + (uint64_t)ts.tv_nsec;
}


void* worker(void* arg) {
    WorkerArg* wa = (WorkerArg*)arg;

    // Wait for gate — instrumented: lock/unlock give HB from main
    pthread_mutex_lock(&gate_mtx);
    while (!gate_open)
        pthread_cond_wait(&gate_cond, &gate_mtx);
    pthread_mutex_unlock(&gate_mtx);

    // Phase 1: sum local chunk from shared_buf
    long local_sum = 0;
    for (int i = wa->start; i < wa->end; i++)
        local_sum += shared_buf[i];

    // Phase 2: update accumulator WITHOUT lock  ← INTENTIONAL RACE
    // Four workers do this concurrently with no HB between them.
    // sharing analysis: OWNED(worker_0) → SHARED when worker_1 arrives
    // FastTrack: W-W or R-W between worker threads
    accumulator += local_sum;               // ← RACE

    // Phase 3: safe update
    pthread_mutex_lock(&safe_mtx);
    safe_counter += local_sum;
    pthread_mutex_unlock(&safe_mtx);

    // Signal completion
    pthread_mutex_lock(&done_mtx);
    workers_done++;
    pthread_cond_signal(&done_cond);
    pthread_mutex_unlock(&done_mtx);

    return NULL;
}

void* monitor(void* arg) {
    // Wait for gate — same gate as workers
    pthread_mutex_lock(&gate_mtx);
    while (!gate_open)
        pthread_cond_wait(&gate_cond, &gate_mtx);
    pthread_mutex_unlock(&gate_mtx);

    // Spin-read done_flag with no further sync  ← RACE
    // main writes done_flag AFTER opening gate but WITHOUT joining workers.
    // There is no HB between main's write and this read because the only
    // shared sync after gate_open is done_mtx which main does not acquire
    // before writing done_flag.
    volatile int spin = 0;
    while (!done_flag) {                    // ← RACE: W-R with main's write
        spin++;
        if (spin > 20000000) break;
    }

    // Read accumulator without sync — another race with workers
    long snap = accumulator;               // ← RACE: R-W with workers
    printf("[monitor] done_flag=%d accumulator_snap=%ld spin=%d\n",
           done_flag, snap, spin);
    return NULL;
}

int main() {
    for (int i = 0; i < BUF_SIZE; i++)
        shared_buf[i] = i % 7 + 1;

    WorkerArg  args[NUM_WORKERS];
    pthread_t  wthreads[NUM_WORKERS];
    pthread_t  mon;

    uint64_t start_ns = now_ns();

    for (int i = 0; i < NUM_WORKERS; i++) {
        args[i] = { i, i * CHUNK, (i + 1) * CHUNK };
        pthread_create(&wthreads[i], NULL, worker, &args[i]);
    }
    pthread_create(&mon, NULL, monitor, NULL);

    // Open gate — all threads get HB from this unlock
    pthread_mutex_lock(&gate_mtx);
    gate_open = 1;
    pthread_cond_broadcast(&gate_cond);
    pthread_mutex_unlock(&gate_mtx);

    // Burn some cycles so workers are mid-flight
    volatile long burn = 0;
    for (int i = 0; i < 1000000; i++) burn += i;

    // Write done_flag WITHOUT joining workers or acquiring done_mtx
    // → no HB with monitor's read of done_flag
    done_flag = 1;                          // ← RACE

    // Now join everyone
    for (int i = 0; i < NUM_WORKERS; i++)
        pthread_join(wthreads[i], NULL);
    pthread_join(mon, NULL);

    uint64_t end_ns = now_ns();
    
    printf("Launch to finish   : %llu ms\n", 
           (unsigned long long)((end_ns - start_ns) / 1000000ULL));
    
    printf("[main] accumulator=%ld  safe_counter=%ld\n",
           accumulator, safe_counter);
    printf("[main] accumulator should equal safe_counter if no torn writes.\n");

    pthread_mutex_destroy(&gate_mtx);
    pthread_cond_destroy(&gate_cond);
    pthread_mutex_destroy(&done_mtx);
    pthread_cond_destroy(&done_cond);
    pthread_mutex_destroy(&safe_mtx);
    return 0;
}