# Java Race Condition — Concurrent Counter

## Symptom

A `Counter` class provides an `incrementIfBelow(int threshold)` method that
should never allow `count` to exceed the given threshold. However, when
multiple threads call this method concurrently, `count` **exceeds the
threshold**.

## How to Reproduce

The test spawns 100 threads, synchronises them with a `CyclicBarrier` so
they all call `incrementIfBelow(50)` at the exact same instant, and then
asserts that `count <= 50`. Run:

```bash
docker build -t debug-lab-03 .
docker run --rm debug-lab-03 bash /workspace/run_tests.sh
```

The test will fail, reporting that the counter exceeded the threshold.

## Relevant Tools

- Thread dumps (`jstack`, IDE debuggers)
- Java concurrency analysis
- Code review for shared mutable state patterns
- `java.util.concurrent` utilities (CyclicBarrier, CountDownLatch)

## Difficulty

**Hard** — Requires understanding of Java memory model, thread interleaving,
and check-then-act anti-patterns.
