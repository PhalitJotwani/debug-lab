# Task: C++ Heap-Buffer-Overflow (ASan)

## Symptom

A ring buffer implementation (`repo/ring_buffer.hpp`) crashes under
AddressSanitizer when elements are pushed past its capacity.  The crash
occurs during the wrap-around path in `push()`.  Smaller inputs that do
not fill the buffer work fine.

Run the tests to reproduce:

```bash
bash /workspace/run_tests.sh
```

## Constraints

- You may only modify files under `repo/`.
- You may NOT modify files under `tests/`.
- The fix should be minimal and correct.

## Success Criteria

- `run_tests.sh` exits with code 0.
- The fix addresses the root cause, not just the symptom.
