#include <pthread.h>
#include <cstdio>

static const int N = 1 << 10;
static int stage1_out[N];
static int stage2_out[N];
static int stage3_out[N];

void* stage1(void* ) {
    for (int i = 0; i < N; i++) stage1_out[i] = i;
    return nullptr;
}
void* stage2(void* ) {
    for (int i = 0; i < N; i++) stage2_out[i] = stage1_out[i] * 2;
    return nullptr;
}
void* stage3(void* ) {
    for (int i = 0; i < N; i++) stage3_out[i] = stage2_out[i] + 1;
    return nullptr;
}

int main() {
    pthread_t t1, t2, t3;

    pthread_create(&t1, nullptr, stage1, nullptr);
    pthread_join(t1, nullptr);
    // After join: main has observed stage1_out. SA-FT reclaims it.

    pthread_create(&t2, nullptr, stage2, nullptr);
    pthread_join(t2, nullptr);
    // After join: stage2_out reclaimed.

    pthread_create(&t3, nullptr, stage3, nullptr);
    pthread_join(t3, nullptr);
    // After join: stage3_out reclaimed.

    long long sum = 0;
    for (int i = 0; i < N; i++) sum += stage3_out[i];
    printf("sum = %lld\n", sum);
}