# 01 — C++ Heap-Buffer-Overflow (ASan)

## Symptom

A templated ring buffer implementation crashes (or is aborted by
AddressSanitizer) when elements are pushed beyond its capacity, forcing the
internal indices to wrap around.  The program works fine for small inputs that
never fill the buffer.

## Difficulty

Medium

## Tools

- **AddressSanitizer (ASan)** — compile with `-fsanitize=address -g`
- **gdb** — inspect variables and step through the wrapping logic
- **Valgrind** — alternative memory-error detector

## Reproduction

```bash
docker build -t debug-lab-01-cpp-heap-overflow-asan .
docker run --rm debug-lab-01-cpp-heap-overflow-asan bash /workspace/run_tests.sh
```

The test will fail.  Your goal is to make it pass.
