/*
 * BENCHMARK 4: PRODUCER-CONSUMER — RACES ON METADATA, SAFE DATA PAYLOAD
 * ========================================================================
 * Sharing profile  : SELECTIVE — queue control fields shared (racy),
 *                    payload buffers exclusive after handoff (safe)
 * Races present    : YES — on head, tail, count, and the slot-in-transit
 * Instrumentation  : Only queue metadata fields should be instrumented;
 *                    payload data (once owned by consumer) should not be
 *
 * This benchmark models a realistic pattern: a lock-free ring buffer where
 * the synchronisation metadata is deliberately unprotected (to create races
 * the detector must catch) while the data payload follows an ownership
 * discipline that a precise analysis could recognise.
 *
 * Sharing categories
 * ------------------
 *   RACY:   ring.head, ring.tail, ring.count    (all threads read/write)
 *           ring.slots[i].ready                  (producer writes, consumer reads)
 * BORDERLINE: ring.slots[i].data                (racy during hand-off window)
 * SAFE:   private producer/consumer local vars  (stack)
 *
 * What to measure
 * ---------------
 *   1. Races on metadata fields detected  → YES
 *   2. Races on slot data during handoff  → YES (hand-off is not atomic)
 *   3. Overhead on consumer's private     → LOW
 *   4. False positives post-handoff       → ZERO (if analysis tracks ownership)
 */

#define _GNU_SOURCE
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* ======================================================= configuration === */
#define NUM_PRODUCERS    4
#define NUM_CONSUMERS    4
#define RING_SIZE       64      /* must be power of two                     */
#define PAYLOAD_INTS    32      /* ints per slot                            */
#define TOTAL_ITEMS   8000      /* total items produced                     */

/* ======================================================= ring buffer ===== */
typedef struct {
    volatile int ready;          /* 0=empty, 1=data ready   — RACY          */
    int          data[PAYLOAD_INTS];  /* payload             — RACY at handoff */
    int          producer_id;    /* for verification        — RACY at handoff */
    long         sequence;       /* monotone seq number     — RACY           */
} slot_t;

typedef struct {
    volatile int head;           /* consumer reads here     — RACY          */
    volatile int tail;           /* producer writes here    — RACY          */
    volatile int count;          /* approximate occupancy   — RACY RMW      */
    slot_t       slots[RING_SIZE];
} ring_t;

static ring_t ring;

/* shared item counters (racy) */
static volatile long items_produced;
static volatile long items_consumed;

/* ======================================================= producer ======== */
typedef struct { int pid; } prod_arg_t;

static void *producer(void *varg)
{
    prod_arg_t *a = (prod_arg_t *)varg;
    int pid = a->pid;

    for (;;) {
        /* racy check-and-increment (no CAS) */
        long seq = items_produced;              /* racy read               */
        if (seq >= TOTAL_ITEMS) break;
        items_produced = seq + 1;               /* racy write (lost update)*/

        int idx = (int)(seq % RING_SIZE);
        slot_t *s = &ring.slots[idx];

        /* write payload — racy with concurrent consumer touching same slot */
        s->producer_id = pid;
        s->sequence    = seq;
        for (int i = 0; i < PAYLOAD_INTS; ++i)
            s->data[i] = pid * 1000 + i + (int)seq;

        /* signal ready — racy WW with another producer hitting same slot  */
        s->ready = 1;                           /* racy write              */

        /* update ring metadata */
        ring.tail  = (ring.tail + 1) % RING_SIZE;   /* racy write          */
        ring.count++;                               /* racy RMW             */
    }
    return NULL;
}

/* ======================================================= consumer ======== */
typedef struct { int cid; } cons_arg_t;

static void *consumer(void *varg)
{
    cons_arg_t *a = (cons_arg_t *)varg;
    int cid = a->cid;

    long local_sum = 0;     /* private, no race */
    int  spins     = 0;

    for (;;) {
        long consumed = items_consumed;          /* racy read              */
        if (consumed >= TOTAL_ITEMS) break;

        int idx = (int)(consumed % RING_SIZE);
        slot_t *s = &ring.slots[idx];

        if (!s->ready) {                         /* racy read of flag      */
            spins++;
            if (spins > 1000000) break;
            continue;
        }
        spins = 0;

        /* consume payload — racy with producer still writing              */
        long slot_sum = 0;
        for (int i = 0; i < PAYLOAD_INTS; ++i)
            slot_sum += s->data[i];              /* racy read during handoff*/

        local_sum += slot_sum;

        s->ready = 0;                            /* racy write             */
        ring.head  = (ring.head + 1) % RING_SIZE;   /* racy write          */
        ring.count--;                               /* racy RMW             */
        items_consumed = consumed + 1;           /* racy write             */

        (void)cid;
    }

    /* private result — safe post-join */
    (void)local_sum;
    return NULL;
}

/* ================================================================ main === */
int main(void)
{
    pthread_t   prod_threads[NUM_PRODUCERS];
    pthread_t   cons_threads[NUM_CONSUMERS];
    prod_arg_t  prod_args[NUM_PRODUCERS];
    cons_arg_t  cons_args[NUM_CONSUMERS];

    memset(&ring, 0, sizeof(ring));
    items_produced = 0;
    items_consumed = 0;

    printf("[B4] Producer-consumer benchmark: %d producers, %d consumers\n",
           NUM_PRODUCERS, NUM_CONSUMERS);
    printf("     Ring size=%d, payload=%d ints, total items=%d\n",
           RING_SIZE, PAYLOAD_INTS, TOTAL_ITEMS);

    for (int i = 0; i < NUM_CONSUMERS; ++i) {
        cons_args[i].cid = i;
        pthread_create(&cons_threads[i], NULL, consumer, &cons_args[i]);
    }
    for (int i = 0; i < NUM_PRODUCERS; ++i) {
        prod_args[i].pid = i;
        pthread_create(&prod_threads[i], NULL, producer, &prod_args[i]);
    }

    for (int i = 0; i < NUM_PRODUCERS; ++i) pthread_join(prod_threads[i], NULL);
    for (int i = 0; i < NUM_CONSUMERS; ++i) pthread_join(cons_threads[i], NULL);

    printf("[B4] Done. produced=%ld consumed=%ld (non-deterministic)\n",
           items_produced, items_consumed);
    return 0;
}

/*
 * BUILD
 * -----
 * gcc -O1 -pthread bench4_producer_consumer.c -o b4 && ./b4
 * gcc -O1 -pthread -fsanitize=thread bench4_producer_consumer.c -o b4_tsan
 *
 * RACY VARIABLES TABLE
 * --------------------
 *   ring.head, ring.tail, ring.count   → RMW races
 *   ring.slots[i].ready                → WW / RW races
 *   ring.slots[i].data[]               → RW races during handoff window
 *   ring.slots[i].sequence             → RW race
 *   items_produced, items_consumed     → classic lost-update races
 *
 * DETECTOR CHALLENGE
 * ------------------
 * A precise analysis should be able to determine that after a consumer
 * observes ready==1 and clears it, the producer no longer touches data[].
 * Detecting (or not detecting) the handoff window race distinguishes
 * sound detectors from approximate ones.
 */
