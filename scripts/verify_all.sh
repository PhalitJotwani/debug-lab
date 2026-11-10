#!/usr/bin/env bash
# verify_all.sh — Verify all tasks and print a summary table.
# Usage: scripts/verify_all.sh [tasks_dir]
#
# Exits non-zero if any task fails.

set -uo pipefail

TASKS_DIR="${1:-tasks}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m'

TOTAL=0
PASSED=0
FAILED=0
RESULTS=()

echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║           debug-lab verification suite           ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════════════════╝${NC}"
echo ""

# If a specific task is provided via TASK env var, only run that one
if [ -n "${TASK:-}" ]; then
    TASK_DIRS=("$TASK")
else
    TASK_DIRS=()
    for d in "$TASKS_DIR"/*/; do
        [ -d "$d" ] && TASK_DIRS+=("${d%/}")
    done
fi

if [ ${#TASK_DIRS[@]} -eq 0 ]; then
    echo "No tasks found in $TASKS_DIR/"
    exit 1
fi

for task_dir in "${TASK_DIRS[@]}"; do
    TOTAL=$((TOTAL + 1))
    task_name="$(basename "$task_dir")"
    echo -e "${BOLD}─── Task: $task_name ───${NC}"

    if bash "$SCRIPT_DIR/verify_task.sh" "$task_dir"; then
        PASSED=$((PASSED + 1))
        RESULTS+=("${GREEN}PASS${NC}|$task_name")
    else
        FAILED=$((FAILED + 1))
        RESULTS+=("${RED}FAIL${NC}|$task_name")
    fi
    echo ""
done

# Print summary table
echo -e "${BOLD}═══════════════════════════════════════════════════${NC}"
echo -e "${BOLD}  SUMMARY${NC}"
echo -e "${BOLD}═══════════════════════════════════════════════════${NC}"
printf "  %-8s %s\n" "Status" "Task"
echo "  ------   ----"
for result in "${RESULTS[@]}"; do
    status="${result%%|*}"
    name="${result##*|}"
    printf "  "
    echo -en "$status"
    printf "     %s\n" "$name"
done
echo ""
echo -e "  Total: $TOTAL | ${GREEN}Passed: $PASSED${NC} | ${RED}Failed: $FAILED${NC}"
echo -e "${BOLD}═══════════════════════════════════════════════════${NC}"

if [ "$FAILED" -gt 0 ]; then
    exit 1
fi
exit 0
