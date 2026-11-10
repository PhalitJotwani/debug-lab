# Task 02 — Python Performance Regression

## Symptom

The `deduplicate_preserve_order` function in `repo/dedup.py` produces
**correct output** — all correctness tests pass — but the **performance
test fails**. The performance test uses deterministic operation counting
(not wall-clock time) to assert that the number of equality-check
operations stays below a linear bound. On the current implementation the
count far exceeds this bound, indicating a worse-than-linear algorithm.

## How to Reproduce

```bash
docker build -t debug-lab-02 .
docker run --rm debug-lab-02 bash /workspace/run_tests.sh
```

All correctness tests pass; the performance test fails.

## Relevant Tools & Techniques

- **Complexity analysis** — reason about the algorithmic complexity of
  each statement inside the loop.
- **Profiling** — `cProfile`, `py-spy`, or `line_profiler` can reveal
  where time is spent.
- **Operation counting** — the test itself instruments equality checks;
  inspect its output to see the actual count vs. the allowed bound.

## Performance Testing Approach

This task uses **operation counting** (see `docs/task-spec.md`).
A custom wrapper class counts `__eq__` invocations. The test asserts
that the total stays within O(n) for *n* unique items. This is fully
deterministic and flake-free.

## Difficulty

**Medium**
