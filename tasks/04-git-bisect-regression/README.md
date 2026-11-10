# Task 04: Git Bisect — Regression Hunt

## Symptom

The calculator project's `multiply` function returns incorrect results.
For example, `multiply(3, 4)` returns `7` instead of `12`.

The project has 12 commits of development history. Somewhere in that
history, a commit introduced a regression that broke the multiplication
logic.

## Objective

- Use **`git bisect`** to identify which commit introduced the regression.
- Create a **`fix/regression`** branch from `main` with a single commit
  that corrects the bug.

## Tools

- `git bisect` — binary-search through commit history
- `git log` / `git show` / `git diff` — inspect changes
- `python -m unittest` — run the project test suite

## Difficulty

**Medium** — requires understanding of `git bisect` workflow and reading
diffs to understand what changed.

## Setup

The repository is created by `repo/setup_history.sh`. Run it to get a
git repository at `/tmp/calc_project` with the full commit history.

## Success Criteria

1. The bad commit is correctly identified.
2. A `fix/regression` branch exists, branched from `main`.
3. The branch has exactly one commit that fixes the regression.
4. All tests pass on the `fix/regression` branch.
