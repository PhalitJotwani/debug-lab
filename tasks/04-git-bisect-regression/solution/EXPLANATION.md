# Root Cause Analysis

## The Bug

In commit 6 ("Refactor multiply for clarity"), the `multiply` function
in `calc.py` was changed from:

```python
def multiply(a, b):
    return a * b
```

to:

```python
def multiply(a, b):
    return a + b    # BUG: addition instead of multiplication
```

This is a classic typo regression — `*` was replaced with `+`.

## How to Find It

### Step 1: Confirm the regression

```bash
cd /tmp/calc_project
python -m unittest test_calc -v
# test_multiply FAILS: multiply(3, 4) == 7, expected 12
```

### Step 2: Use git bisect

```bash
git bisect start
git bisect bad HEAD          # current HEAD is broken
git bisect good HEAD~11      # first commit (only has add) is good
git bisect run python -m pytest test_calc.py -x 2>/dev/null || git bisect run python -m unittest test_calc
```

Or manually:

```bash
git bisect start
git bisect bad HEAD
git bisect good <first-commit-hash>

# Git checks out a middle commit; run tests:
python -m unittest test_calc
# Mark good or bad based on result, repeat until bisect identifies the commit.
```

Bisect identifies **commit 6** ("Refactor multiply for clarity") as the
first bad commit.

### Step 3: Inspect the bad commit

```bash
git show <commit-6-hash>
# Shows: multiply changed from `return a * b` to `return a + b`
```

### Step 4: Create the fix branch

```bash
git bisect reset
git checkout -b fix/regression main
```

Edit `calc.py` — change `multiply` back to `return a * b`:

```python
def multiply(a, b):
    """Return the product of a and b."""
    return a * b
```

Commit the fix:

```bash
git add calc.py
git commit -m "Fix multiply regression: use * instead of +"
```

### Step 5: Verify

```bash
python -m unittest test_calc -v
# All tests pass
```

## Why the Fix Is Correct

The fix restores the correct multiplication operator (`*`) in the
`multiply` function. The function's docstring says "Return the product
of a and b", and `a * b` is the product. All existing tests pass with
this change.
