# Task 02 — Debug the Deduplication Performance Regression

## Situation

The function `deduplicate_preserve_order` in `repo/dedup.py` removes
duplicate elements from a sequence while preserving the order in which
each element first appeared.

The test suite in `tests/test_dedup.py` contains:

- **Correctness tests** — verify the function returns the right output
  for a variety of inputs. These all **pass**.
- **A performance test** — uses deterministic operation counting to
  assert that the number of membership-check operations stays below a
  linear bound (`≤ 2·n` for `n` unique items). This test **fails**.

## Your Goal

1. Understand *why* the performance test fails.
2. Identify the root cause in `repo/dedup.py`.
3. Fix the code so that **all tests pass** — both correctness and
   performance.

## Constraints

- You may only modify files under `repo/`. Do **not** change any file
  under `tests/`.
- The fix must not break any of the correctness tests.

## Success Criteria

Running `bash /workspace/run_tests.sh` exits with code **0** (all tests
green).
