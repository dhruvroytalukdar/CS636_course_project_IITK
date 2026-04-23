#include <pthread.h>
#include <cstdio>

static const int PRIVATE_SIZE = 512;
static const int INCREMENTS   = 8;

static long long shared_counter = 0;
static pthread_mutex_t counter_mutex = PTHREAD_MUTEX_INITIALIZER;

void* worker(void* arg) {
    int* local = new int[PRIVATE_SIZE];

    for (int batch = 0; batch < INCREMENTS; batch++) {
        // OWNED phase: large private work between each lock
        for (int i = 0; i < PRIVATE_SIZE; i++)
            local[i] = i ^ batch;

        // Brief SHARED phase: increment the counter
        pthread_mutex_lock(&counter_mutex);
        shared_counter++;
        pthread_mutex_unlock(&counter_mutex);
    }

    delete[] local;
    return nullptr;
}

int main() {
    const int T = 4;
    pthread_t threads[T];
    for (int t = 0; t < T; t++)
        pthread_create(&threads[t], nullptr, worker, nullptr);
    for (int t = 0; t < T; t++)
        pthread_join(threads[t], nullptr);
    printf("counter = %lld\n", shared_counter);
}