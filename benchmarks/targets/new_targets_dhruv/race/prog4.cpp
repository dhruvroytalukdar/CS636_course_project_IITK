// cbench4_pipeline_racy.cpp
// Like bench4_pipeline but the handoff between stages is NOT
// synchronised — stages are launched concurrently so stage2 can
// read stage1_out while stage1 is still writing it.
// Expected: W-R races between stage1 writes and stage2 reads,
//           and between stage2 writes and stage3 reads.
//
// The large private computation inside each stage is OWNED —
// SA skips FT on all of that. Races only fire on the shared arrays.

#include <pthread.h>
#include <cstdio>
#include <time.h>

static const int N = 512;

static int stage1_out[N];
static int stage2_out[N];
static int stage3_out[N];

static inline uint64_t now_ns() {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000000000ULL + (uint64_t)ts.tv_nsec;
}

void* stage1(void*) {
    // Writes stage1_out — concurrent with stage2 reading it (racy).
    for (int i = 0; i < N; i++)
        stage1_out[i] = i;
    return nullptr;
}

void* stage2(void*) {
    // Reads stage1_out (racy: stage1 may still be writing).
    // Writes stage2_out — concurrent with stage3 reading it (racy).
    for (int i = 0; i < N; i++)
        stage2_out[i] = stage1_out[i] * 2;
    return nullptr;
}

void* stage3(void*) {
    // Reads stage2_out (racy: stage2 may still be writing).
    for (int i = 0; i < N; i++)
        stage3_out[i] = stage2_out[i] + 1;
    return nullptr;
}

int main() {
    pthread_t t1, t2, t3;

    uint64_t launch_ns = now_ns();

    // Launch all three stages concurrently — no synchronisation between them.
    // This creates races on stage1_out (stage1 writes, stage2 reads)
    // and stage2_out (stage2 writes, stage3 reads).
    pthread_create(&t1, nullptr, stage1, nullptr);
    pthread_create(&t2, nullptr, stage2, nullptr);
    pthread_create(&t3, nullptr, stage3, nullptr);

    pthread_join(t1, nullptr);
    pthread_join(t2, nullptr);
    pthread_join(t3, nullptr);

    uint64_t finish_ns = now_ns();

    long long sum = 0;
    for (int i = 0; i < N; i++) sum += stage3_out[i];

    printf("Launch to finish        : %llu ms\n",
           (unsigned long long)((finish_ns - launch_ns) / 1000000ULL));
    printf("sum = %lld\n", sum);
    return 0;
}