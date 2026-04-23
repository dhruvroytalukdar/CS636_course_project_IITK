#include <pthread.h>
#include <cstdio>

static const int ROWS = 128, COLS = 128;
static float matrix[ROWS][COLS];

struct Stripe { int start, end; };

void* init_stripe(void* arg) {
    Stripe* s = (Stripe*)arg;
    // OWNED: only this thread writes its stripe
    for (int r = s->start; r < s->end; r++)
        for (int c = 0; c < COLS; c++)
            matrix[r][c] = (float)(r * COLS + c);
    return nullptr;
}

int main() {
    const int T = 8;
    pthread_t threads[T];
    Stripe stripes[T];
    int chunk = ROWS / T;

    for (int t = 0; t < T; t++) {
        stripes[t] = {t * chunk, (t + 1) * chunk};
        pthread_create(&threads[t], nullptr, init_stripe, &stripes[t]);
    }
    for (int t = 0; t < T; t++)
        pthread_join(threads[t], nullptr);

    // SA-FT: after all joins, main reclaims ownership of the entire matrix.
    // All subsequent accesses are OWNED — zero FT cost.
    float sum = 0;
    for (int r = 0; r < ROWS; r++)
        for (int c = 0; c < COLS; c++)
            sum += matrix[r][c];

    printf("sum = %f\n", sum);
}