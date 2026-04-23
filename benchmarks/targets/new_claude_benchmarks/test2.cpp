#include <pthread.h>
#include <stdio.h>

#define CHUNK_SIZE 1024
#define ITERATIONS 10000000
#define NUM_THREADS 4

int private_chunks[NUM_THREADS * CHUNK_SIZE];

void* worker_fast_path(void* arg) {
    long tid = (long)arg;
    long start = tid * CHUNK_SIZE;
    
    // Massive number of iterations on owned variables
    for (int iter = 0; iter < ITERATIONS; ++iter) {
        for (long i = 0; i < 10; ++i) { 
            private_chunks[start + i]++;
        }
    }
    return NULL;
}

int main() {
    pthread_t threads[NUM_THREADS];
    for (long i = 0; i < NUM_THREADS; ++i) {
        pthread_create(&threads[i], NULL, worker_fast_path, (void*)i);
    }
    for (int i = 0; i < NUM_THREADS; ++i) {
        pthread_join(threads[i], NULL);
    }
    printf("Fast path test complete.\n");
    return 0;
}