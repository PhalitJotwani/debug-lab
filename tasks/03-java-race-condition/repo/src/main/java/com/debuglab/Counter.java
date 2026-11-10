package com.debuglab;

/**
 * A simple counter that supports conditional incrementing.
 * Intended for use across multiple threads.
 */
public class Counter {
    private int count = 0;

    /**
     * Increments the counter only if its current value is below the given threshold.
     *
     * @param threshold the upper bound; counter is incremented only if count < threshold
     * @return true if the counter was incremented, false otherwise
     */
    public boolean incrementIfBelow(int threshold) {
        if (count < threshold) {  // check
            count++;               // act — race window between check and act!
            return true;
        }
        return false;
    }

    /**
     * Returns the current count.
     */
    public int getCount() {
        return count;
    }

    /**
     * Resets the counter to zero.
     */
    public void reset() {
        count = 0;
    }
}
