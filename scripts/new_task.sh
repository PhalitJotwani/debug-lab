#!/usr/bin/env bash
# new_task.sh — Scaffold a new task from the template.
# Usage: scripts/new_task.sh <task_name>
# Example: scripts/new_task.sh 05-rust-memory-leak

set -euo pipefail

TASK_NAME="${1:?Usage: new_task.sh <task_name>}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_DIR="$REPO_ROOT/templates/task"
TARGET_DIR="$REPO_ROOT/tasks/$TASK_NAME"

if [ -d "$TARGET_DIR" ]; then
    echo "Error: Task directory already exists: $TARGET_DIR" >&2
    exit 1
fi

if [ ! -d "$TEMPLATE_DIR" ]; then
    echo "Error: Template directory not found: $TEMPLATE_DIR" >&2
    exit 1
fi

echo "Creating new task: $TASK_NAME"
cp -r "$TEMPLATE_DIR" "$TARGET_DIR"

# Replace placeholder in files
find "$TARGET_DIR" -type f -exec sed -i "s/{{TASK_NAME}}/$TASK_NAME/g" {} +

echo ""
echo "Task scaffolded at: $TARGET_DIR"
echo ""
echo "Next steps:"
echo "  1. Edit $TARGET_DIR/Dockerfile — set the base image and install tools"
echo "  2. Write the buggy code in $TARGET_DIR/repo/"
echo "  3. Write failing tests in $TARGET_DIR/tests/"
echo "  4. Create the golden fix in $TARGET_DIR/solution/fix.patch"
echo "  5. Write explanations in $TARGET_DIR/solution/EXPLANATION.md"
echo "  6. Update $TARGET_DIR/README.md and $TARGET_DIR/TASK.md"
echo "  7. Test with: make verify TASK=tasks/$TASK_NAME"
echo ""
