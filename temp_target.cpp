#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

#define NUM_THREADS 4
#define ARRAY_SIZE 1000

// 1. GLOBAL ROOT: This must be caught by your M.globals() loop.
int global_sum = 0;
pthread_mutex_t lock;

// Structure to test GetElementPtr (GEP) dependency tracking
typedef struct {
    int thread_id;
    int *shared_array; // Pointer to shared heap memory
} ThreadData;

void* worker_function(void* arg) {
    // 'arg' is a root in your worker function.
    // Cast tests BitCastInst tracking.
    ThreadData* data = (ThreadData*)arg;

    // 2. THREAD-LOCAL: This is allocated on this thread's stack.
    // It never escapes. Your pass should PROVE it is safe and skip instrumentation.
    int local_sum = 0; 

    // GEP tests: accessing fields of the escaped 'data' struct
    int start = data->thread_id * (ARRAY_SIZE / NUM_THREADS);
    int end = start + (ARRAY_SIZE / NUM_THREADS);

    for (int i = start; i < end; i++) {
        // LOAD from escaped heap memory (instrumented)
        // STORE to thread-local memory (skipped)
        local_sum += data->shared_array[i];
    }

    pthread_mutex_lock(&lock);
    // LOAD from local (skipped), LOAD from global (instrumented)
    // STORE to global (instrumented)
    global_sum += local_sum; 
    pthread_mutex_unlock(&lock);

    return NULL;
}

int main() {
    pthread_t threads[NUM_THREADS];
    ThreadData t_data[NUM_THREADS];

    // 3. HEAP ALLOCATION: Starts local to main, but escapes later.
    int *shared_array = (int*)malloc(ARRAY_SIZE * sizeof(int));
    pthread_mutex_init(&lock, NULL);

    for (int i = 0; i < ARRAY_SIZE; i++) {
        shared_array[i] = 1; // Initialization
    }

    for (int i = 0; i < NUM_THREADS; i++) {
        t_data[i].thread_id = i;
        t_data[i].shared_array = shared_array; // shared_array escapes into t_data

        // t_data[i] escapes into pthread_create
        pthread_create(&threads[i], NULL, worker_function, &t_data[i]);
    }

    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
    }

    printf("Final sum: %d\n", global_sum);

    free(shared_array);
    pthread_mutex_destroy(&lock);
    return 0;
}
