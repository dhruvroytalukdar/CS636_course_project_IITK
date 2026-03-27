#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <time.h>

// ── Tuning: make solo phase MUCH larger than shared phase ─────────
// This is the critical ratio for measuring sharing analysis benefit.
//
// Solo phase  = SOLO_ITERS accesses by ONE thread (OWNED fast path)
//   SA: 0 FT calls  (OWNED fast path skips everything)
//   FT: SOLO_ITERS FT calls (full VarState every time)
//
// Shared phase = just enough accesses to produce a detectable race
//   Both tools call FT here — this part is equal overhead
//
// If solo >> shared, the SA speedup becomes visible.
// If shared >> solo, the shared phase dominates and hides the benefit.
#define NUM_THREADS     4
#define SOLO_ITERS      2000000   // 2M solo accesses per variable per thread
#define SHARED_ITERS    100       // minimal: just enough to guarantee a race

// ── Variables ─────────────────────────────────────────────────────
//
// solo_vars[i]: thread i is the ONLY thread that ever touches solo_vars[i]
//   SA: stays OWNED(i) forever — FT never called
//       total FT calls saved = NUM_THREADS * SOLO_ITERS * 2 (read+write)
//   FT: full VarState on every access
//       total FT calls = NUM_THREADS * SOLO_ITERS * 2
//
// race_var: touched by all threads without a lock after the gate opens
//   Both tools call FT here and detect the race
//   SA must have promoted race_var from OWNED to SHARED at gate time
//
// Each field is 64-byte padded to prevent false sharing from affecting
// the instrumentation call count (we don't want cache-miss noise)
struct PaddedLong {
    long value;
    char pad[56];
};

static struct PaddedLong solo_vars[NUM_THREADS];   // one per thread
static struct PaddedLong race_var;                 // shared, unprotected

// ── Phase gate ────────────────────────────────────────────────────
static int             gate_open    = 0;
static pthread_mutex_t gate_mtx     = PTHREAD_MUTEX_INITIALIZER;
static pthread_cond_t  gate_cond    = PTHREAD_COND_INITIALIZER;
static int             threads_done = 0;
static pthread_mutex_t done_mtx     = PTHREAD_MUTEX_INITIALIZER;
static pthread_cond_t  done_cond    = PTHREAD_COND_INITIALIZER;

// ── Timing ────────────────────────────────────────────────────────
static uint64_t launch_ns;
static uint64_t gate_open_ns;
static uint64_t first_race_ns = 0;

static inline uint64_t now_ns() {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000000000ULL + (uint64_t)ts.tv_nsec;
}

// ── Worker ────────────────────────────────────────────────────────
void* worker(void* arg) {
    int id = *(int*)arg;

    // ── SOLO PHASE ────────────────────────────────────────────────
    // Thread `id` exclusively reads and writes solo_vars[id].
    // No other thread touches it — ever.
    //
    // SA: solo_vars[id].value goes UNACCESSED -> OWNED(id)
    //     Every subsequent access hits the lock-free fast path:
    //       share_state == OWNED && owner_tid == id -> return immediately
    //     FT is never called. Zero VarState lookups.
    //
    // FT: full __ft_read + __ft_write on every iteration.
    //     SOLO_ITERS * 2 calls per thread = 4M total FT calls wasted.
    int i;
    for (i = 0; i < SOLO_ITERS; i++) {
        // Explicit load into local, compute, store back.
        // This guarantees separate load IR and store IR instructions
        // so the pass inserts both __ft_read and __ft_write.
        long v = solo_vars[id].value;   // __ft_read instrumented here
        v = v + 1;
        solo_vars[id].value = v;        // __ft_write instrumented here
    }

    // ── Wait for gate ─────────────────────────────────────────────
    // The cond_wait gives HB from main's broadcast.
    // After this point: thread has seen main's clock.
    // race_var was OWNED(main) during init.
    // SA: is_ordered(thread, main, main_epoch)?
    //     main wrote race_var BEFORE locking gate_mtx.
    //     So main's race_var epoch > main's clock at lock time.
    //     Therefore thread.C[main] < race_var.owner_epoch -> NOT ordered
    //     -> race_var promotes to SHARED when second thread touches it
    pthread_mutex_lock(&gate_mtx);
    while (!gate_open)
        pthread_cond_wait(&gate_cond, &gate_mtx);
    pthread_mutex_unlock(&gate_mtx);

    // ── SHARED PHASE ──────────────────────────────────────────────
    // All threads hammer race_var without a lock.
    // SHARED_ITERS is intentionally tiny — we only need a few races.
    // The report COUNT here is the same for both tools.
    // The OVERHEAD difference comes entirely from the solo phase above.
    for (i = 0; i < SHARED_ITERS; i++) {
        long v = race_var.value;        // RACE READ  — __ft_read
        v = v + 1;
        race_var.value = v;             // RACE WRITE — __ft_write
    }

    // ── Signal done ───────────────────────────────────────────────
    pthread_mutex_lock(&done_mtx);
    threads_done++;
    pthread_cond_signal(&done_cond);
    pthread_mutex_unlock(&done_mtx);

    return NULL;
}

int main() {
    int i;
    memset(solo_vars, 0, sizeof(solo_vars));
    memset(&race_var, 0, sizeof(race_var));

    // Write race_var here — OWNED(main)
    // Crucially this happens BEFORE pthread_mutex_lock(&gate_mtx) below,
    // so threads cannot be ordered with this write via the gate mutex.
    race_var.value = 0;

    pthread_t threads[NUM_THREADS];
    int       ids[NUM_THREADS];

    launch_ns = now_ns();

    for (i = 0; i < NUM_THREADS; i++) {
        ids[i] = i;
        pthread_create(&threads[i], NULL, worker, &ids[i]);
    }

    // Let threads run their solo phases fully before opening the gate.
    // This maximises the solo-phase work that separates SA from FT.
    // We wait for all threads to reach the gate themselves.
    // (They block on cond_wait so CPU is free — no busy spin needed.)

    // Small delay to ensure all threads are in the cond_wait
    struct timespec delay = {0, 50000000}; // 50ms
    nanosleep(&delay, NULL);

    // Open gate — all threads get HB from this broadcast
    pthread_mutex_lock(&gate_mtx);
    gate_open    = 1;
    gate_open_ns = now_ns();
    pthread_cond_broadcast(&gate_cond);
    pthread_mutex_unlock(&gate_mtx);

    // Wait for all threads to finish
    pthread_mutex_lock(&done_mtx);
    while (threads_done < NUM_THREADS)
        pthread_cond_wait(&done_cond, &done_mtx);
    pthread_mutex_unlock(&done_mtx);

    for (i = 0; i < NUM_THREADS; i++)
        pthread_join(threads[i], NULL);

    uint64_t finish_ns = now_ns();

    printf("Launch to finish        : %llu ms\n",
           (unsigned long long)((finish_ns - launch_ns) / 1000000ULL));
    printf("Solo phase duration     : ~50ms (gate delay)\n");
    printf("Gate open at            : %llu ms from launch\n",
           (unsigned long long)((gate_open_ns - launch_ns) / 1000000ULL));
    printf("race_var final          : %ld\n", race_var.value);
    printf("solo_vars totals        : ");
    for (i = 0; i < NUM_THREADS; i++)
        printf("[%d]=%ld ", i, solo_vars[i].value);
    printf("\n");

    printf("\n--- Expected solo_vars[i] = %d (each thread ran solo) ---\n",
           SOLO_ITERS);
    printf("--- Expected race_var ~ %d (racy, probably less) ---\n",
           NUM_THREADS * SHARED_ITERS);

    return 0;
}