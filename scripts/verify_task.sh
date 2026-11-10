#!/usr/bin/env bash
# verify_task.sh — Verify a single debug-lab task.
# Usage: scripts/verify_task.sh <task_dir>
#
# Exits 0 on PASS, 1 on FAIL.

set -euo pipefail

TASK_DIR="${1:?Usage: verify_task.sh <task_dir>}"
TASK_NAME="$(basename "$TASK_DIR")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

fail() {
    echo -e "${RED}FAIL${NC} [$TASK_NAME] $1" >&2
    exit 1
}

pass() {
    echo -e "${GREEN}PASS${NC} [$TASK_NAME] $1"
    exit 0
}

info() {
    echo -e "${YELLOW}INFO${NC} [$TASK_NAME] $1"
}

# --- Pre-flight checks ---
for required in Dockerfile README.md TASK.md repo tests solution/fix.patch solution/EXPLANATION.md run_tests.sh; do
    if [ ! -e "$TASK_DIR/$required" ]; then
        fail "Missing required file/directory: $required"
    fi
done

# Check for :latest in Dockerfile
if grep -qE 'FROM\s+\S+:latest' "$TASK_DIR/Dockerfile"; then
    fail "Dockerfile uses :latest tag — pin a specific version"
fi

# --- Step 4 (early): Check that fix.patch does not touch tests/ ---
if grep -qE '^\+\+\+ [ab]/tests/' "$TASK_DIR/solution/fix.patch" 2>/dev/null || \
   grep -qE '^diff .* [ab]/tests/' "$TASK_DIR/solution/fix.patch" 2>/dev/null; then
    fail "solution/fix.patch modifies files under tests/ — fix must not tamper with tests"
fi

# --- Step 1: Build the Docker image ---
IMAGE_TAG="debug-lab-${TASK_NAME}:verify"
info "Building Docker image: $IMAGE_TAG"
if ! docker build -t "$IMAGE_TAG" "$TASK_DIR" > /tmp/debug-lab-build-${TASK_NAME}.log 2>&1; then
    cat /tmp/debug-lab-build-${TASK_NAME}.log >&2
    fail "Docker build failed"
fi

# --- Step 2: Run tests on BUGGY code — expect FAILURE ---
info "Running tests on buggy code (expecting failure)..."
BUGGY_OUTPUT=$(docker run --rm "$IMAGE_TAG" bash /workspace/run_tests.sh 2>&1 || true)
BUGGY_EXIT=$(docker run --rm "$IMAGE_TAG" bash -c 'bash /workspace/run_tests.sh > /dev/null 2>&1; echo $?' 2>/dev/null || echo "1")

# We need to capture the actual exit code properly
BUGGY_EXIT=0
docker run --rm "$IMAGE_TAG" bash /workspace/run_tests.sh > /tmp/debug-lab-buggy-${TASK_NAME}.log 2>&1 || BUGGY_EXIT=$?

if [ "$BUGGY_EXIT" -eq 0 ]; then
    echo "--- Buggy code test output ---" >&2
    cat /tmp/debug-lab-buggy-${TASK_NAME}.log >&2
    echo "--- End output ---" >&2
    fail "Tests PASSED on buggy code — they should FAIL"
fi
info "Tests correctly FAILED on buggy code (exit code: $BUGGY_EXIT)"

# --- Step 3: Apply fix and run tests — expect PASS ---
info "Applying golden fix and running tests (expecting pass)..."

# Create a container, apply the patch, run the tests
CONTAINER_ID=$(docker create "$IMAGE_TAG" bash -c '
    set -e
    cd /workspace
    cp -r repo repo_fixed
    cd repo_fixed
    patch -p1 < /workspace/solution/fix.patch
    cd /workspace
    # Replace repo with fixed version
    rm -rf repo
    mv repo_fixed repo
    bash run_tests.sh
')

docker start -a "$CONTAINER_ID" > /tmp/debug-lab-fixed-${TASK_NAME}.log 2>&1
FIXED_EXIT=$?
docker rm "$CONTAINER_ID" > /dev/null 2>&1 || true

if [ "$FIXED_EXIT" -ne 0 ]; then
    echo "--- Fixed code test output ---" >&2
    cat /tmp/debug-lab-fixed-${TASK_NAME}.log >&2
    echo "--- End output ---" >&2
    fail "Tests FAILED on fixed code — golden fix is incorrect"
fi
info "Tests correctly PASSED on fixed code"

# --- Step 5: Report ---
pass "Buggy=FAIL(exit $BUGGY_EXIT), Fixed=PASS, no test tampering"
