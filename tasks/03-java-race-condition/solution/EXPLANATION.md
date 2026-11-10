# Root Cause

The `Counter.incrementIfBelow(int threshold)` method contains a classic
**check-then-act** race condition. The two operations:

1. **Check:** `if (count < threshold)`
2. **Act:** `count++`

are **not atomic**. When multiple threads call `incrementIfBelow()` concurrently,
the following interleaving can occur:

```
Thread A reads count = 49, sees 49 < 50 → passes check
Thread B reads count = 49, sees 49 < 50 → passes check
Thread A increments count to 50
Thread B increments count to 51  ← EXCEEDS THRESHOLD
```

Because the read of `count` and the subsequent write are separate bytecode
instructions (and separate CPU operations), the JVM's memory model allows
threads to see stale values and interleave in the gap between the check
and the act.

# How to Find It

1. **Code Inspection:** Look for shared mutable state (`count` is a plain
   `int` field) accessed from multiple threads without synchronisation.
   The pattern `if (field < X) { field++; }` is a textbook check-then-act
   anti-pattern.

2. **Thread Dumps:** Under heavy contention, `jstack` or IDE thread dumps
   will show multiple threads simultaneously inside `incrementIfBelow()`.

3. **Testing with CyclicBarrier:** The test in this task uses a
   `CyclicBarrier` to force all threads to call the method at the exact
   same instant, making the race condition manifest deterministically.

# Why the Fix Is Correct

Adding the `synchronized` keyword to `incrementIfBelow()` makes the entire
method body execute under the object's intrinsic lock:

```java
public synchronized boolean incrementIfBelow(int threshold) {
    if (count < threshold) {
        count++;
        return true;
    }
    return false;
}
```

This guarantees that the check and the act happen atomically — no other
thread can observe or modify `count` between the `if` check and the `count++`
increment. The counter will never exceed the threshold.

An alternative fix would use `AtomicInteger` with a compare-and-set loop,
which avoids locking but achieves the same atomicity guarantee.
