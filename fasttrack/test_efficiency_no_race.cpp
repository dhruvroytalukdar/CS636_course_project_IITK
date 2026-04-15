#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <time.h>

#define NUM_THREADS     4
#define WORK_ITERS      5000000   // 5M solo accesses per thread


struct PaddedBuffer {
    long local_sum;
    long array[100]; // Local state to modify repeatedly
    char pad[64];    // Prevent false sharing
};

static struct PaddedBuffer thread_buffers[NUM_THREADS];
static long global_total = 0;
static pthread_mutex_t total_mtx = PTHREAD_MUTEX_INITIALIZER;

// ── Timing ────────────────────────────────────────────────────────
static inline uint64_t now_ns() {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000000000ULL + (uint64_t)ts.tv_nsec;
}

// ── Worker ────────────────────────────────────────────────────────
void* worker(void* arg) {
    int id = *(int*)arg;

    // ── SOLO PHASE ────────────────────
    long temp_sum = 0;
    for (int i = 0; i < WORK_ITERS; i++) {
        thread_buffers[id].array[i % 100] += (i % 5);
        temp_sum += thread_buffers[id].array[i % 100];
    }
    thread_buffers[id].local_sum = temp_sum;

    // ── SHARED PHASE ─────────────────────
    pthread_mutex_lock(&total_mtx);
    global_total += thread_buffers[id].local_sum;
    pthread_mutex_unlock(&total_mtx);

    return NULL;
}

int main() {
    pthread_t threads[NUM_THREADS];
    int ids[NUM_THREADS];
    uint64_t start_ns = now_ns();

    // ── INITIALIZATION ────────────────────────────────────────────
    for (int i = 0; i < NUM_THREADS; i++) {
        thread_buffers[i].local_sum = 0;
        for (int j = 0; j < 100; j++) {
            thread_buffers[i].array[j] = 0;
        }
    }

    // ── SPAWN ─────────────────────────────────────────────────────
    for (int i = 0; i < NUM_THREADS; i++) {
        ids[i] = i;
        pthread_create(&threads[i], NULL, worker, &ids[i]);
    }

    // ── JOIN ──────────────────────────────────────────────────────
    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
    }

    uint64_t end_ns = now_ns();
    
    printf("Launch to finish   : %llu ms\n", 
           (unsigned long long)((end_ns - start_ns) / 1000000ULL));
    printf("Global Total            : %ld\n", global_total);

    return 0;
}