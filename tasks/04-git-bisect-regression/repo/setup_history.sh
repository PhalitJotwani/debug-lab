#!/usr/bin/env bash
set -euo pipefail

cd /tmp
rm -rf calc_project
mkdir calc_project
cd calc_project
git init

git config user.name "Dev User"
git config user.email "dev@example.com"

# ── Commit 1: Initial calc.py with add(), basic test ──
cat > calc.py << 'PYEOF'
def add(a, b):
    return a + b
PYEOF

cat > test_calc.py << 'PYEOF'
import unittest
from calc import add

class TestCalc(unittest.TestCase):
    def test_add(self):
        self.assertEqual(add(2, 3), 5)
        self.assertEqual(add(-1, 1), 0)
        self.assertEqual(add(0, 0), 0)

if __name__ == "__main__":
    unittest.main()
PYEOF

git add -A
export GIT_AUTHOR_DATE="2024-01-01T10:00:00+00:00"
export GIT_COMMITTER_DATE="2024-01-01T10:00:00+00:00"
git commit -m "Initial commit: add function and basic test"

# ── Commit 2: Add subtract() ──
cat > calc.py << 'PYEOF'
def add(a, b):
    return a + b

def subtract(a, b):
    return a - b
PYEOF

git add -A
export GIT_AUTHOR_DATE="2024-01-02T10:00:00+00:00"
export GIT_COMMITTER_DATE="2024-01-02T10:00:00+00:00"
git commit -m "Add subtract function"

# ── Commit 3: Add test for subtract ──
cat > test_calc.py << 'PYEOF'
import unittest
from calc import add, subtract

class TestCalc(unittest.TestCase):
    def test_add(self):
        self.assertEqual(add(2, 3), 5)
        self.assertEqual(add(-1, 1), 0)
        self.assertEqual(add(0, 0), 0)

    def test_subtract(self):
        self.assertEqual(subtract(5, 3), 2)
        self.assertEqual(subtract(0, 0), 0)
        self.assertEqual(subtract(-1, -1), 0)

if __name__ == "__main__":
    unittest.main()
PYEOF

git add -A
export GIT_AUTHOR_DATE="2024-01-03T10:00:00+00:00"
export GIT_COMMITTER_DATE="2024-01-03T10:00:00+00:00"
git commit -m "Add test for subtract"

# ── Commit 4: Add multiply() ──
cat > calc.py << 'PYEOF'
def add(a, b):
    return a + b

def subtract(a, b):
    return a - b

def multiply(a, b):
    return a * b
PYEOF

git add -A
export GIT_AUTHOR_DATE="2024-01-04T10:00:00+00:00"
export GIT_COMMITTER_DATE="2024-01-04T10:00:00+00:00"
git commit -m "Add multiply function"

# ── Commit 5: Add test for multiply ──
cat > test_calc.py << 'PYEOF'
import unittest
from calc import add, subtract, multiply

class TestCalc(unittest.TestCase):
    def test_add(self):
        self.assertEqual(add(2, 3), 5)
        self.assertEqual(add(-1, 1), 0)
        self.assertEqual(add(0, 0), 0)

    def test_subtract(self):
        self.assertEqual(subtract(5, 3), 2)
        self.assertEqual(subtract(0, 0), 0)
        self.assertEqual(subtract(-1, -1), 0)

    def test_multiply(self):
        self.assertEqual(multiply(3, 4), 12)
        self.assertEqual(multiply(-2, 3), -6)
        self.assertEqual(multiply(0, 5), 0)

if __name__ == "__main__":
    unittest.main()
PYEOF

git add -A
export GIT_AUTHOR_DATE="2024-01-05T10:00:00+00:00"
export GIT_COMMITTER_DATE="2024-01-05T10:00:00+00:00"
git commit -m "Add test for multiply"

# ── Commit 6: BAD COMMIT — Regression in multiply ──
cat > calc.py << 'PYEOF'
def add(a, b):
    return a + b

def subtract(a, b):
    return a - b

def multiply(a, b):
    return a + b
PYEOF

git add -A
export GIT_AUTHOR_DATE="2024-01-06T10:00:00+00:00"
export GIT_COMMITTER_DATE="2024-01-06T10:00:00+00:00"
git commit -m "Refactor multiply for clarity"

# ── Commit 7: Add divide() ──
cat > calc.py << 'PYEOF'
def add(a, b):
    return a + b

def subtract(a, b):
    return a - b

def multiply(a, b):
    return a + b

def divide(a, b):
    return a / b
PYEOF

git add -A
export GIT_AUTHOR_DATE="2024-01-07T10:00:00+00:00"
export GIT_COMMITTER_DATE="2024-01-07T10:00:00+00:00"
git commit -m "Add divide function"

# ── Commit 8: Add test for divide ──
cat > test_calc.py << 'PYEOF'
import unittest
from calc import add, subtract, multiply, divide

class TestCalc(unittest.TestCase):
    def test_add(self):
        self.assertEqual(add(2, 3), 5)
        self.assertEqual(add(-1, 1), 0)
        self.assertEqual(add(0, 0), 0)

    def test_subtract(self):
        self.assertEqual(subtract(5, 3), 2)
        self.assertEqual(subtract(0, 0), 0)
        self.assertEqual(subtract(-1, -1), 0)

    def test_multiply(self):
        self.assertEqual(multiply(3, 4), 12)
        self.assertEqual(multiply(-2, 3), -6)
        self.assertEqual(multiply(0, 5), 0)

    def test_divide(self):
        self.assertEqual(divide(10, 2), 5)
        self.assertEqual(divide(7, 2), 3.5)
        self.assertEqual(divide(-6, 3), -2)

if __name__ == "__main__":
    unittest.main()
PYEOF

git add -A
export GIT_AUTHOR_DATE="2024-01-08T10:00:00+00:00"
export GIT_COMMITTER_DATE="2024-01-08T10:00:00+00:00"
git commit -m "Add test for divide"

# ── Commit 9: Add docstrings ──
cat > calc.py << 'PYEOF'
def add(a, b):
    """Return the sum of a and b."""
    return a + b

def subtract(a, b):
    """Return the difference of a and b."""
    return a - b

def multiply(a, b):
    """Return the product of a and b."""
    return a + b

def divide(a, b):
    """Return the quotient of a divided by b."""
    return a / b
PYEOF

git add -A
export GIT_AUTHOR_DATE="2024-01-09T10:00:00+00:00"
export GIT_COMMITTER_DATE="2024-01-09T10:00:00+00:00"
git commit -m "Add docstrings to all functions"

# ── Commit 10: Add input validation to divide ──
cat > calc.py << 'PYEOF'
def add(a, b):
    """Return the sum of a and b."""
    return a + b

def subtract(a, b):
    """Return the difference of a and b."""
    return a - b

def multiply(a, b):
    """Return the product of a and b."""
    return a + b

def divide(a, b):
    """Return the quotient of a divided by b."""
    if b == 0:
        raise ValueError("Cannot divide by zero")
    return a / b
PYEOF

git add -A
export GIT_AUTHOR_DATE="2024-01-10T10:00:00+00:00"
export GIT_COMMITTER_DATE="2024-01-10T10:00:00+00:00"
git commit -m "Add input validation to divide"

# ── Commit 11: Update test for divide-by-zero ──
cat > test_calc.py << 'PYEOF'
import unittest
from calc import add, subtract, multiply, divide

class TestCalc(unittest.TestCase):
    def test_add(self):
        self.assertEqual(add(2, 3), 5)
        self.assertEqual(add(-1, 1), 0)
        self.assertEqual(add(0, 0), 0)

    def test_subtract(self):
        self.assertEqual(subtract(5, 3), 2)
        self.assertEqual(subtract(0, 0), 0)
        self.assertEqual(subtract(-1, -1), 0)

    def test_multiply(self):
        self.assertEqual(multiply(3, 4), 12)
        self.assertEqual(multiply(-2, 3), -6)
        self.assertEqual(multiply(0, 5), 0)

    def test_divide(self):
        self.assertEqual(divide(10, 2), 5)
        self.assertEqual(divide(7, 2), 3.5)
        self.assertEqual(divide(-6, 3), -2)

    def test_divide_by_zero(self):
        with self.assertRaises(ValueError):
            divide(1, 0)

if __name__ == "__main__":
    unittest.main()
PYEOF

git add -A
export GIT_AUTHOR_DATE="2024-01-11T10:00:00+00:00"
export GIT_COMMITTER_DATE="2024-01-11T10:00:00+00:00"
git commit -m "Add test for divide by zero"

# ── Commit 12: Add README.md ──
cat > README.md << 'MDEOF'
# Calculator Project

A simple Python calculator module with basic arithmetic operations:

- `add(a, b)` — addition
- `subtract(a, b)` — subtraction
- `multiply(a, b)` — multiplication
- `divide(a, b)` — division (with zero-division protection)

## Running Tests

```bash
python -m unittest test_calc -v
```
MDEOF

git add -A
export GIT_AUTHOR_DATE="2024-01-12T10:00:00+00:00"
export GIT_COMMITTER_DATE="2024-01-12T10:00:00+00:00"
git commit -m "Add README"

echo "/tmp/calc_project"
