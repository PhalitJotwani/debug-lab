# Task: Fix the Concurrent Counter

## Symptom

The `Counter` class in `repo/src/main/java/com/debuglab/Counter.java` has an
`incrementIfBelow(int threshold)` method. Its contract states that `count`
must never exceed the threshold. However, under concurrent access from
multiple threads, the counter's value **exceeds the threshold**.

## Test

The test in `repo/src/test/java/com/debuglab/CounterTest.java` uses a
`CyclicBarrier` to synchronise 100 threads so they all call
`incrementIfBelow(50)` at the same instant, then asserts that
`counter.getCount() <= 50`. The scenario runs 50 times to ensure
reproducibility.

## Success Criteria

- `run_tests.sh` exits with code 0 (all test iterations pass).
- The counter's value never exceeds the threshold, regardless of how many
  threads call `incrementIfBelow()` concurrently.
- Do **not** modify the test code.

## Constraints

- Fix only the production code in `repo/src/main/java/`.
- The fix must preserve the existing API (method signatures, return values).
- Java 17 language features are available.
