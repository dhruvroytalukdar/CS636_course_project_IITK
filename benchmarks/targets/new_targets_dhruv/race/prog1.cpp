// cbench1_racy_counter.cpp
// Threads do private work (OWNED, SA skips FT) then increment a
// shared counter WITHOUT a lock (intentional race).
// Expected: races on shared_counter.
// SA should report same races as plain FT, but be faster overall
// because the large private array phase is skipped by SA.

#include <pthread.h>
#include <cstdio>
#include <time.h>
#include <c

static const int T            = 4;
static const int PRIVATE_SIZE = 1024;
static const int INCREMENTS   = 16;

// Unprotected shared variable — intentional races here.
static long shared_counter = 0;

static inline uint64_t now_ns() {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000000000ULL + (uint64_t)ts.tv_nsec;
}

void* worker(void* arg) {
    int* local = new int[PRIVATE_SIZE];

    for (int batch = 0; batch < INCREMENTS; batch++) {
        // OWNED: large private work — SA skips FT entirely here.
        for (int i = 0; i < PRIVATE_SIZE; i++)
            local[i] = i ^ batch;

        // SHARED: racy increment — no lock, intentional race.
        // Both detectors must fire here.
        long v = shared_counter;   // racy read
        v = v + 1;
        shared_counter = v;        // racy write
    }

    delete[] local;
    return nullptr;
}

int main() {
    pthread_t threads[T];

    uint64_t launch_ns = now_ns();

    for (int t = 0; t < T; t++)
        pthread_create(&threads[t], nullptr, worker, nullptr);
    for (int t = 0; t < T; t++)
        pthread_join(threads[t], nullptr);

    uint64_t finish_ns = now_ns();
    printf("Launch to finish        : %llu ms\n",
           (unsigned long long)((finish_ns - launch_ns) / 1000000ULL));
    printf("counter = %ld (expected < %d due to races)\n",
           shared_counter, T * INCREMENTS);
    return 0;
}