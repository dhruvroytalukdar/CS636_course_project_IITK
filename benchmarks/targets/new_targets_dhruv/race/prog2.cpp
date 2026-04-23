// cbench2_racy_flag.cpp
// A producer thread writes a large private buffer (OWNED) then sets
// a flag without synchronisation. Consumer threads spin on the flag
// then read the buffer — racy because no HB edge exists between
// producer's write and consumers' reads.
// Expected: W-R races on both the flag and the buffer elements.

#include <pthread.h>
#include <cstdio>
#include <time.h>

static const int N = 512;

static int  shared_buf[N];  // written by producer, read by consumers — racy
static int  ready_flag = 0; // set by producer, read by consumers — racy

static inline uint64_t now_ns() {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000000000ULL + (uint64_t)ts.tv_nsec;
}

void* producer(void*) {
    // OWNED: only producer writes shared_buf initially.
    // SA skips FT on all of these.
    for (int i = 0; i < N; i++)
        shared_buf[i] = i * 2;

    // Racy: no synchronisation before setting flag.
    ready_flag = 1;  // race with consumers reading flag
    return nullptr;
}

void* consumer(void* arg) {
    int id = *(int*)arg;

    // Spin on flag without any lock — racy read of ready_flag.
    while (ready_flag == 0) {}

    // Racy reads of shared_buf — no HB edge from producer's writes.
    long sum = 0;
    for (int i = 0; i < N; i++)
        sum += shared_buf[i];  // race with producer's writes

    printf("consumer %d sum = %ld\n", id, sum);
    return nullptr;
}

int main() {
    const int C = 3; // 3 consumers + 1 producer = 4 threads
    pthread_t prod_thread;
    pthread_t cons_threads[C];
    int ids[C];

    uint64_t launch_ns = now_ns();

    // Launch consumers first so they are spinning when producer fires.
    for (int i = 0; i < C; i++) {
        ids[i] = i;
        pthread_create(&cons_threads[i], nullptr, consumer, &ids[i]);
    }
    pthread_create(&prod_thread, nullptr, producer, nullptr);

    pthread_join(prod_thread, nullptr);
    for (int i = 0; i < C; i++)
        pthread_join(cons_threads[i], nullptr);

    uint64_t finish_ns = now_ns();
    printf("Launch to finish        : %llu ms\n",
           (unsigned long long)((finish_ns - launch_ns) / 1000000ULL));
    return 0;
}