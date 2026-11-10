# Git Bisect Regression

## Scenario

You are working on a calculator project that has been developed over
12 commits. A user reports that `multiply(3, 4)` returns `7` instead
of `12`. The bug was introduced at some point during development.

## Your Task

1. **Set up the repository** by running `bash /workspace/repo/setup_history.sh`.
   This creates a git repository at `/tmp/calc_project`.

2. **Use `git bisect`** to identify the exact commit that introduced
   the multiply regression.

3. **Create a fix branch**: from the tip of `main`, create a branch
   named `fix/regression` with a single commit that fixes the multiply
   function so all tests pass.

## Constraints

- The fix branch must be named exactly `fix/regression`.
- The fix branch must have exactly **one** commit on top of `main`.
- All existing tests (`test_calc.py`) must pass on the fix branch.
- Do not modify the test file.

## Verification

Run `bash /workspace/run_tests.sh` — exit code 0 means success.
