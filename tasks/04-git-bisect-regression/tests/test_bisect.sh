#!/usr/bin/env bash
set -euo pipefail

PASS=0
FAIL=0

pass() { echo "PASS: $1"; PASS=$((PASS + 1)); }
fail() { echo "FAIL: $1"; FAIL=$((FAIL + 1)); }

# Step a) Run setup_history.sh to create the git repo
echo "=== Setting up git history ==="
REPO_PATH=$(bash /workspace/repo/setup_history.sh)

if [ ! -d "$REPO_PATH/.git" ]; then
    fail "Repository was not created at $REPO_PATH"
    echo "Results: $PASS passed, $FAIL failed"
    exit 1
fi
pass "Repository exists at $REPO_PATH"

# Step b) Check expected number of commits (~12)
cd "$REPO_PATH"
COMMIT_COUNT=$(git rev-list --count HEAD)
if [ "$COMMIT_COUNT" -ge 10 ] && [ "$COMMIT_COUNT" -le 14 ]; then
    pass "Repository has $COMMIT_COUNT commits (expected ~12)"
else
    fail "Repository has $COMMIT_COUNT commits (expected ~12)"
fi

# Step c) Confirm the regression exists — multiply is broken on main
echo "=== Checking for regression on main ==="
git checkout main 2>/dev/null || git checkout master 2>/dev/null
if python test_calc.py 2>&1; then
    fail "Tests should fail on main (multiply regression expected)"
else
    pass "Tests fail on main as expected (regression present)"
fi

# Step d) Check that fix/regression branch exists
if git rev-parse --verify fix/regression >/dev/null 2>&1; then
    pass "Branch fix/regression exists"
else
    fail "Branch fix/regression does not exist"
    echo ""
    echo "Results: $PASS passed, $FAIL failed"
    exit 1
fi

# Step e) Checkout fix/regression and verify all tests pass
echo "=== Checking fix branch ==="
git checkout fix/regression
if python test_calc.py 2>&1; then
    pass "All tests pass on fix/regression branch"
else
    fail "Tests fail on fix/regression branch"
fi

# Step f) Verify the fix branch has exactly one commit on top of main
MAIN_BRANCH="main"
git rev-parse --verify main >/dev/null 2>&1 || MAIN_BRANCH="master"
AHEAD_COUNT=$(git rev-list --count "${MAIN_BRANCH}..fix/regression")
if [ "$AHEAD_COUNT" -eq 1 ]; then
    pass "fix/regression has exactly 1 commit ahead of $MAIN_BRANCH"
else
    fail "fix/regression has $AHEAD_COUNT commits ahead of $MAIN_BRANCH (expected 1)"
fi

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
exit 0
