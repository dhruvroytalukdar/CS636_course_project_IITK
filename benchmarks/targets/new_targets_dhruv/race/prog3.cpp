// cbench3_two_phase.cpp
// Mirrors the structure of test_efficiency.cpp but with a larger
// OWNED phase so SA's advantage is measurable.
//
// Phase 1 (OWNED): each thread works on its own private array exclusively.
//   SA skips all FT calls. Plain FT runs VC checks on every access.
// Phase 2 (SHARED+RACY): all threads access a shared variable without locks.
//   Both detectors run full FT. Races expected here.
//
// The performance gap between SA and plain FT comes entirely from Phase 1.

#include <pthread.h>
#include <cstdio>
#include <cstring>
#include <time.h>

static const int T           = 4;
static const int SOLO_ITERS  = 4096;  // large OWNED phase
static const int SHARED_ITERS = 256;  // small SHARED/racy phase

struct PaddedLong {
    long value;
    char pad[56]; // cache line padding
};

static PaddedLong solo_vars[T]; // each thread owns solo_vars[id] exclusively
static PaddedLong race_var;     // all threads access this without locks

static inline uint64_t now_ns() {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000000000ULL + (uint64_t)ts.tv_nsec;
}

void* solo_worker(void* arg) {
    int id = *(int*)arg;
    // OWNED: only thread[id] touches solo_vars[id].
    // SA: zero FT calls. Plain FT: SOLO_ITERS * 2 VC checks (read + write).
    for (int i = 0; i < SOLO_ITERS; i++) {
        long v = solo_vars[id].value;
        solo_vars[id].value = v + 1;
    }
    return nullptr;
}

void* shared_worker(void*) {
    // SHARED + RACY: all threads access race_var without synchronisation.
    // Both SA and plain FT run full FT checks here.
    for (int i = 0; i < SHARED_ITERS; i++) {
        long v = race_var.value;   // racy read
        race_var.value = v + 1;   // racy write
    }
    return nullptr;
}

int main() {
    int ids[T];
    pthread_t threads[T];

    memset(solo_vars, 0, sizeof(solo_vars));
    memset(&race_var, 0, sizeof(race_var));

    uint64_t launch_ns = now_ns();

    // Phase 1: all threads work on their own variable (no sharing).
    for (int t = 0; t < T; t++) {
        ids[t] = t;
        pthread_create(&threads[t], nullptr, solo_worker, &ids[t]);
    }
    for (int t = 0; t < T; t++)
        pthread_join(threads[t], nullptr);

    uint64_t phase2_ns = now_ns();

    // Phase 2: all threads race on the shared variable.
    for (int t = 0; t < T; t++)
        pthread_create(&threads[t], nullptr, shared_worker, nullptr);
    for (int t = 0; t < T; t++)
        pthread_join(threads[t], nullptr);

    uint64_t finish_ns = now_ns();

    printf("Launch to finish        : %llu ms\n",
           (unsigned long long)((finish_ns - launch_ns) / 1000000ULL));
    printf("Phase 1 (owned)         : %llu ms\n",
           (unsigned long long)((phase2_ns - launch_ns) / 1000000ULL));
    printf("Phase 2 (shared+racy)   : %llu ms\n",
           (unsigned long long)((finish_ns - phase2_ns) / 1000000ULL));

    printf("solo_vars (each should = %d):\n", SOLO_ITERS);
    for (int t = 0; t < T; t++)
        printf("  [%d] = %ld\n", t, solo_vars[t].value);

    printf("race_var (should be < %d due to races): %ld\n",
           T * SHARED_ITERS, race_var.value);
    return 0;
}