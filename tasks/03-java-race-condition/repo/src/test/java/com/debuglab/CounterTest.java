package com.debuglab;

import org.junit.jupiter.api.Test;

import java.util.concurrent.CyclicBarrier;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Deterministic race-condition test for Counter.
 *
 * Strategy: use a CyclicBarrier so that all threads call incrementIfBelow()
 * at the exact same instant, maximising the chance of interleaving in the
 * check-then-act window.  Run the scenario many times; if count ever exceeds
 * the threshold the test fails.
 */
class CounterTest {

    private static final int NUM_THREADS = 100;
    private static final int THRESHOLD = 50;
    private static final int ITERATIONS = 50;

    @Test
    void counterMustNeverExceedThreshold() throws Exception {
        for (int iteration = 0; iteration < ITERATIONS; iteration++) {
            Counter counter = new Counter();
            CyclicBarrier barrier = new CyclicBarrier(NUM_THREADS);
            ExecutorService pool = Executors.newFixedThreadPool(NUM_THREADS);

            for (int t = 0; t < NUM_THREADS; t++) {
                pool.submit(() -> {
                    try {
                        barrier.await();          // all threads release at once
                        counter.incrementIfBelow(THRESHOLD);
                    } catch (Exception e) {
                        Thread.currentThread().interrupt();
                    }
                });
            }

            pool.shutdown();
            assertTrue(pool.awaitTermination(10, TimeUnit.SECONDS),
                    "Thread pool did not terminate in time");

            int finalCount = counter.getCount();
            assertTrue(finalCount <= THRESHOLD,
                    String.format(
                            "Iteration %d: count %d exceeded threshold %d — "
                            + "check-then-act race condition detected!",
                            iteration, finalCount, THRESHOLD));
        }
    }
}
