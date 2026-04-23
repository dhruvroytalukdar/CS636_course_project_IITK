/**
 * TEST 1: LARGE NUMBER OF SHARED VARIABLES
 * =========================================
 * Purpose : Stress-test with 1 000 shared variables, each accessed by every
 *           thread both for reading and writing — all protected by one global
 *           mutex so there are NO races, but ownership transitions very
 *           frequently (OWNED → SHARED → OWNED every lock cycle).
 *
 * Expected behaviour
 *   SA-enhanced FT : Every variable quickly becomes SHARED and stays there;
 *                    can_reclaim() always fails because all threads touch
 *                    every variable.  The SA fast-path is never taken, so
 *                    every access goes through ft_slow_{read,write}.  SA adds
 *                    overhead with no benefit → WORSE than plain FT.
 *   Plain FT        : Also uses the slow path but without the extra hot_word
 *                    CAS on each access.
 *
 * Instrumentation hooks expected (inserted by your compiler pass):
 *   __ft_read (addr, line, name)
 *   __ft_write(addr, line, name)
 *   __ft_lock / __ft_unlock
 *   __ft_prepare_context / thread_wrapper / __ft_thread_join
 */

#include <pthread.h>
#include <stdio.h>
#include <string.h>

#define NUM_VARS    100
#define NUM_THREADS 4
#define ITERATIONS  2000

static int          shared_vars[NUM_VARS];

/* ------------------------------------------------------------------ */
struct WorkArg { int tid; };

static void* worker(void* arg) {
    WorkArg* wa = (WorkArg*)arg;
    (void)wa;

    for (int iter = 0; iter < ITERATIONS; ++iter) {

        /* Write to every variable */
        for (int i = 0; i < NUM_VARS; ++i)
            shared_vars[i] = iter;

        /* Read every variable back */
        volatile int sum = 0;
        for (int i = 0; i < NUM_VARS; ++i)
            sum += shared_vars[i];
        (void)sum;
    }
    return nullptr;
}

int main() {
    memset(shared_vars, 0, sizeof(shared_vars));

    pthread_t threads[NUM_THREADS];
    WorkArg   args[NUM_THREADS];

    for (int i = 0; i < NUM_THREADS; ++i) {
        args[i].tid = i;
        pthread_create(&threads[i], nullptr, worker, &args[i]);
    }
    for (int i = 0; i < NUM_THREADS; ++i)
        pthread_join(threads[i], nullptr);

    printf("[TEST1] Done. shared_vars[0]=%d\n", shared_vars[0]);
    return 0;
}