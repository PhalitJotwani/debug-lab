# Task Specification Contract

Every task directory under `tasks/` must conform to this contract.
`scripts/verify_task.sh` enforces it automatically.

## Required Files

| File / Directory | Purpose |
|---|---|
| `Dockerfile` | Builds the task's environment. Must use a **pinned base image tag** (never `:latest`). All tools and dependencies are installed at image-build time so verification needs **no network access**. |
| `README.md` | Describes the **symptom** and how to reproduce it. Lists the difficulty level and relevant tools (e.g., ASan, `gdb`, `git bisect`). **Must not contain spoilers** about the root cause or the fix — that belongs in `solution/EXPLANATION.md`. |
| `TASK.md` | The prompt a developer or AI agent would receive. Contains: symptom description, constraints, success criteria. No hints about the solution. |
| `repo/` | The **buggy project source code**. Should be small (roughly 50–300 lines of source). This is the code the developer must debug. |
| `tests/` | Verifier tests that **FAIL on the buggy code** and **PASS after applying the golden fix**. |
| `solution/fix.patch` | A unified diff (golden reference fix) applicable with `git apply` or `patch -p1` from `repo/`. Must **not modify anything under `tests/`**. |
| `solution/EXPLANATION.md` | Root-cause analysis: what the bug is, how to find it, why the fix is correct. |
| `run_tests.sh` | Single entrypoint that runs the tests **inside the container**. Exit code `0` = pass, non-zero = fail. |

## Verification Protocol

`scripts/verify_task.sh <task_dir>` performs these steps in order:

### Step 1 — Build
Build the Docker image from `<task_dir>/Dockerfile`.

### Step 2 — Fail on buggy code
Run `run_tests.sh` inside the container using the unmodified `repo/` and `tests/`.
**Require a non-zero exit code.** Record the failure output.

### Step 3 — Pass after fix
Copy `repo/` to a temporary location, apply `solution/fix.patch` with `patch -p1`,
then run `run_tests.sh` with the patched code.
**Require exit code 0.**

### Step 4 — No test tampering
Verify that `solution/fix.patch` does not modify any file under `tests/`.
This ensures the fix is in the production code, not in the tests.

### Step 5 — Report
Print `PASS` or `FAIL` for the task with a one-line reason.

## Design Principles

### Determinism
Every task must produce **identical results** across runs. No reliance on
wall-clock timing, random ordering, or external services.

**For performance regression tasks:** Do NOT assert on wall-clock time.
Instead, use one of these deterministic techniques:
- **Operation counting:** Inject a counter into the algorithm and assert that
  the number of operations is below a complexity-derived bound (e.g.,
  `ops ≤ k·n` for an O(n) algorithm).
- **Complexity proxy:** Use instrumented inputs of varying sizes and assert
  that the ratio of operations stays within the expected complexity class.

The chosen technique must be documented in the task's `README.md`.

### Pinned Versions
All base images use specific version tags (e.g., `python:3.11.7-slim`,
never `python:latest`). This ensures reproducibility across time and
environments.

### No Network at Verify Time
All dependencies are installed at Docker image build time. The verification
step (`run_tests.sh`) must work entirely offline.

### Golden Solution + Verifier
Every task ships with a known-correct fix (`solution/fix.patch`) and an
automated verifier (`run_tests.sh` + `tests/`). Together they prove:
1. The bug is real (tests fail without the fix).
2. The fix is correct (tests pass with the fix).

### No Test Tampering
The golden fix must not modify test files. The fix must be in the
production code, proving the tests are a valid oracle.
