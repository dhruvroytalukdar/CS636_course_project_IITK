#include <pthread.h>
#include <cstring>
#include <cstdio>

static const int N = 4096; // 1M elements per buffer

struct Work { int* buf; int tid; };

void* producer(void* arg) {
    Work* w = (Work*)arg;
    // OWNED phase: only this thread touches buf
    for (int i = 0; i < N; i++)
        w->buf[i] = i * w->tid;
    return nullptr;
}

int main() {
    const int T = 4;
    int* bufs[T];
    pthread_t threads[T];
    Work works[T];

    for (int t = 0; t < T; t++) {
        bufs[t] = new int[N];
        works[t] = {bufs[t], t + 1};
        pthread_create(&threads[t], nullptr, producer, &works[t]);
    }

    long long sum = 0;
    for (int t = 0; t < T; t++) {
        pthread_join(threads[t], nullptr);
        // After join: parent has observed all child accesses.
        // SA-FT reclaims ownership here; subsequent reads are OWNED.
        for (int i = 0; i < N; i++)
            sum += bufs[t][i];
    }
    printf("sum = %lld\n", sum);

    for (int t = 0; t < T; t++) delete[] bufs[t];
}