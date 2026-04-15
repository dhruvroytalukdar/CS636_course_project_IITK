#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <time.h>

#define NUM_THREADS     4
#define SOLO_ITERS      10000
#define SHARED_ITERS    10000

struct PaddedLong {
    long value;
    char pad[56];
};

static struct PaddedLong solo_vars[NUM_THREADS];
static struct PaddedLong race_var;

// ── Phase 1 Worker (No Races) ─────────────────────────────────────
void* solo_worker(void* arg) {
    int id = *(int*)arg;
    for (int i = 0; i < SOLO_ITERS; i++) {
        long v = solo_vars[id].value;
        v = v + 1;
        solo_vars[id].value = v;
    }
    return NULL;
}

// ── Phase 2 Worker (Intentional Races) ────────────────────────────
void* shared_worker(void* arg) {
    for (int i = 0; i < SHARED_ITERS; i++) {
        long v = race_var.value;
        v = v + 1;
        race_var.value = v;
    }
    return NULL;
}

static inline uint64_t now_ns() {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000000000ULL + (uint64_t)ts.tv_nsec;
}

int main() {
    int i;
    memset(solo_vars, 0, sizeof(solo_vars));
    memset(&race_var, 0, sizeof(race_var));
    race_var.value = 0;

    pthread_t threads[NUM_THREADS];
    int       ids[NUM_THREADS];

    uint64_t launch_ns = now_ns();

    // ── PHASE 1: Launch Solo Phase
    for (i = 0; i < NUM_THREADS; i++) {
        ids[i] = i;
        pthread_create(&threads[i], NULL, solo_worker, &ids[i]);
    }

    // ── BARRIER: Wait for Solo Phase to finish
    // pthread_join establishes a strict happens-before edge.
    for (i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
    }
    
    uint64_t gate_open_ns = now_ns();

    // ── PHASE 2: Launch Shared Phase
    // pthread_create establishes a new happens-before edge.
    for (i = 0; i < NUM_THREADS; i++) {
        pthread_create(&threads[i], NULL, shared_worker, &ids[i]);
    }

    // Wait for all to finish
    for (i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
    }

    uint64_t finish_ns = now_ns();

    printf("Launch to finish        : %llu ms\n",
           (unsigned long long)((finish_ns - launch_ns) / 1000000ULL));
    printf("Gate opened at          : %llu ms from launch\n",
           (unsigned long long)((gate_open_ns - launch_ns) / 1000000ULL));
    
    printf("\n--- Expected solo_vars[i] = %d (each thread ran solo) ---\n", SOLO_ITERS);
    for (i = 0; i < NUM_THREADS; i++) {
        printf("solo_vars[%d]=%ld ", i, solo_vars[i].value);
    }
    printf("\n");

    printf("\n--- Expected race_var < %d (racy, so updates were lost) ---\n", NUM_THREADS * SHARED_ITERS);
    printf("race_var final          : %ld\n", race_var.value);

    return 0;
}