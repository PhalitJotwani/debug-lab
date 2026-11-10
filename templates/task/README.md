# {{TASK_NAME}}

## Symptom

_Describe the observable symptom here. What goes wrong? How can it be reproduced?_

## Difficulty

_Easy / Medium / Hard_

## Tools

_List debugging tools that would help: e.g., gdb, ASan, valgrind, git bisect, profiler_

## Reproduction

```bash
docker build -t debug-lab-{{TASK_NAME}} .
docker run --rm debug-lab-{{TASK_NAME}} bash /workspace/run_tests.sh
```

The test will fail. Your goal is to make it pass.
