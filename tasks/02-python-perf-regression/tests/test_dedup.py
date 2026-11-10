"""Tests for dedup.deduplicate_preserve_order.

Two categories:
  1. Correctness — verify the function returns the right results.
  2. Performance — use deterministic operation counting (not wall-clock time)
     to assert the algorithm runs in O(n), not O(n²).
"""

import sys
import os
import pytest

# ---------------------------------------------------------------------------
# Make the repo package importable
# ---------------------------------------------------------------------------
sys.path.insert(0, os.path.join(os.path.dirname(__file__), os.pardir, "repo"))

from dedup import deduplicate_preserve_order


# ===================================================================
# Correctness tests
# ===================================================================

class TestCorrectnessEmpty:
    def test_empty_list(self):
        assert deduplicate_preserve_order([]) == []


class TestCorrectnessNoDuplicates:
    def test_no_duplicates(self):
        assert deduplicate_preserve_order([1, 2, 3]) == [1, 2, 3]

    def test_single_element(self):
        assert deduplicate_preserve_order([42]) == [42]


class TestCorrectnessAllDuplicates:
    def test_all_same(self):
        assert deduplicate_preserve_order([7, 7, 7, 7]) == [7]


class TestCorrectnessMixed:
    def test_mixed_integers(self):
        assert deduplicate_preserve_order([1, 2, 3, 2, 1, 4]) == [1, 2, 3, 4]

    def test_preserves_insertion_order(self):
        assert deduplicate_preserve_order([5, 3, 5, 1, 3, 1]) == [5, 3, 1]

    def test_strings(self):
        assert deduplicate_preserve_order(["a", "b", "a", "c", "b"]) == [
            "a",
            "b",
            "c",
        ]

    def test_large_correct(self):
        """Correctness at scale: 10 000 unique items should all be preserved."""
        items = list(range(10_000))
        assert deduplicate_preserve_order(items) == items


# ===================================================================
# Performance test — deterministic operation counting
# ===================================================================

class _ContainsCounter:
    """Wrapper that counts how many ``__eq__`` calls are made against it.

    We wrap each input element so that every ``==`` comparison (which is
    what ``in`` ultimately calls) increments a shared counter.
    """

    eq_count: int = 0  # class-level shared counter

    def __init__(self, value):
        self.value = value

    # ``in`` on a list triggers __eq__ for each element comparison.
    def __eq__(self, other):
        _ContainsCounter.eq_count += 1
        if isinstance(other, _ContainsCounter):
            return self.value == other.value
        return NotImplemented

    def __hash__(self):
        return hash(self.value)

    def __repr__(self):
        return f"W({self.value!r})"


class TestPerformanceOperationCount:
    """Assert that the number of equality checks stays within O(n).

    For *n* unique items a correct O(n) implementation (using a ``set``
    for membership) performs roughly *n* hash lookups and very few
    ``__eq__`` calls (only on hash collisions — typically ≤ 2·n).

    An O(n²) implementation (``item in result_list``) performs on the
    order of n²/2 equality checks and will vastly exceed the bound.
    """

    def test_contains_operations_are_linear(self):
        n = 10_000

        # Reset the shared counter.
        _ContainsCounter.eq_count = 0

        # All-unique wrapped items.
        items = [_ContainsCounter(i) for i in range(n)]

        deduplicate_preserve_order(items)

        ops = _ContainsCounter.eq_count

        # An O(n) set-based implementation will trigger very few __eq__
        # calls (only on hash collisions).  We allow up to 2·n as a
        # generous upper bound.  The buggy O(n²) version will hit
        # ~n²/2 = 50 000 000 — far above this limit.
        upper_bound = 2 * n
        assert ops <= upper_bound, (
            f"Too many equality checks: {ops:,} (limit {upper_bound:,}). "
            f"The implementation appears to be O(n²) rather than O(n)."
        )
