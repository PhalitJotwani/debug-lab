# debug-lab

[![CI](https://github.com/<owner>/debug-lab/actions/workflows/ci.yml/badge.svg)](https://github.com/<owner>/debug-lab/actions/workflows/ci.yml)

**Reproducible, self-verifying debugging benchmarks.** debug-lab is a collection
of Dockerized debugging tasks, each containing a buggy program, a failing test,
a golden reference solution, and an automated verifier. It proves, for every
task, that (a) the test FAILS on the buggy code and (b) the test PASSES after
applying the golden fix — the same structure used by reinforcement-learning and
evaluation environments for software-engineering agents.

## Tasks

| # | Name | Language | Bug Class | Tools | Difficulty |
|---|------|----------|-----------|-------|------------|
| 01 | cpp-heap-overflow-asan | C++17 | Heap buffer overflow | ASan, gdb | Medium |
| 02 | python-perf-regression | Python 3.11 | O(n²) performance regression | Profiler, op-counting | Medium |
| 03 | java-race-condition | Java 17 | Check-then-act race condition | Thread dumps, latches | Hard |
| 04 | git-bisect-regression | Shell/Git | History regression | git bisect, git revert | Medium |

## Quick Start

### Verify all tasks
```bash
make verify
```

### Verify a single task
```bash
make verify TASK=tasks/01-cpp-heap-overflow-asan
```

### Add a new task
```bash
scripts/new_task.sh 05-my-new-task
# or
make new-task NAME=05-my-new-task
```

Then fill in the scaffolded files. See [docs/task-spec.md](docs/task-spec.md)
for the full contract every task must follow.

## Design Principles

- **Determinism.** Every task produces identical results across runs. No
  reliance on wall-clock timing, random ordering, or external services.
  Performance tests use operation counting, not time measurement.

- **Pinned versions.** All Docker base images use specific version tags —
  never `:latest`. This ensures reproducibility across time and environments.

- **No network at verify time.** All dependencies are installed at Docker
  image build time. Verification runs entirely offline.

- **Golden solution + verifier.** Every task ships with a known-correct fix
  and an automated verifier that proves the bug is real and the fix is correct.

- **No test tampering.** The golden fix must not modify test files. The fix
  lives in production code, proving the tests are a valid oracle.

## Repository Layout

```
debug-lab/
  README.md              # this file
  LICENSE                # MIT
  Makefile               # top-level commands
  scripts/
    verify_task.sh       # verifies ONE task
    verify_all.sh        # verifies all tasks, prints summary
    new_task.sh          # scaffolds a new task from template
  templates/task/        # skeleton for new tasks
  docs/
    task-spec.md         # the contract every task must follow
  .github/workflows/
    ci.yml               # GitHub Actions CI
  tasks/
    01-cpp-heap-overflow-asan/
    02-python-perf-regression/
    03-java-race-condition/
    04-git-bisect-regression/
```

## License

MIT — see [LICENSE](LICENSE).
