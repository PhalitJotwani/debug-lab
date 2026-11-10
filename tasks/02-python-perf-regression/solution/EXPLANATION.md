# Root Cause Analysis — Task 02: Python Performance Regression

## The Bug

The function `deduplicate_preserve_order` in `repo/dedup.py` uses the
expression `item not in result` where `result` is a plain Python `list`.

List membership testing (`x in some_list`) performs a **linear scan** —
it walks through every element and calls `__eq__` until it finds a match
or reaches the end. When this check is performed inside a loop over *n*
items, the total work is:

    1 + 2 + 3 + … + (n − 1) = n·(n − 1) / 2 = O(n²)

For 10 000 unique items this means roughly **50 million** equality
comparisons.

## How to Find It

1. **Read the performance test** — it counts `__eq__` invocations and
   asserts they stay below `2·n`. The assertion message reports the
   actual count, which will be on the order of 50 000 000 for 10 000
   items — a clear O(n²) signal.
2. **Profile** — running `cProfile` or `py-spy` on a large input shows
   that virtually all time is spent inside `list.__contains__`.
3. **Complexity reasoning** — the `in` operator on a list is O(n);
   using it inside an O(n) loop gives O(n²).

## The Fix

Introduce an auxiliary `set` called `seen` to track elements that have
already been added to `result`. Set membership (`x in some_set`) is
**O(1)** on average (hash-table lookup), bringing the total work back
down to **O(n)**.

```python
def deduplicate_preserve_order(items):
    seen = set()
    result = []
    for item in items:
        if item not in seen:
            seen.add(item)
            result.append(item)
    return result
```

## Why the Fix Is Correct

- **Correctness**: `seen` mirrors `result` exactly — an item is added to
  both at the same time — so the membership check is equivalent.
  Insertion order is preserved because `result` is still a list and
  items are still appended in first-seen order.
- **Performance**: Each of the *n* iterations now does an O(1) set
  lookup and (at most) an O(1) set insertion, giving O(n) total.
