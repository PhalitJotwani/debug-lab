#!/usr/bin/env bash
# Run the tests for this task.
# Exit code 0 = pass, non-zero = fail.
set -euo pipefail

cd /workspace
g++ -std=c++17 -fsanitize=address -g -I repo/ tests/test_ring_buffer.cpp -o /tmp/test_ring_buffer
/tmp/test_ring_buffer
