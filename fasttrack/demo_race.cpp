#include <pthread.h>
#include <stdio.h>
#include <unistd.h>

// The unprotected shared variable
int shared_var = 0;

// Spin-wait gate to ensure both threads start at the exact same time
volatile int gate_open = 0;

void* worker(void* arg) {
    int id = *(int*)arg;
    
    // Asymmetric workload: Thread 0 does 2 iterations, Thread 1 does 3
    int iters = (id == 0) ? 2 : 3;

    // Wait at the starting line
    while (gate_open == 0) { 
        /* spin */ 
    }

    // The microscopic race loop
    for (int i = 0; i < iters; i++) {
        // --- FASTTRACK INTERCEPTS READ HERE ---
        int temp = shared_var; 
        
        temp = temp + 1;
        
        // --- FASTTRACK INTERCEPTS WRITE HERE ---
        shared_var = temp;     
    }

    return NULL;
}

int main() {
    pthread_t threads[2];
    int ids[2] = {0, 1};

    // Create 2 threads
    for (int i = 0; i < 2; i++) {
        pthread_create(&threads[i], NULL, worker, &ids[i]);
    }

    usleep(1000);

    // Fire the starting gun!
    gate_open = 1;

    // Wait for finish
    for (int i = 0; i < 2; i++) {
        pthread_join(threads[i], NULL);
    }

    printf("Done. Final shared_var value = %d\n", shared_var);
    return 0;
}