"""
dedup — Deduplicate a sequence while preserving insertion order.

Provides a single public helper:

    deduplicate_preserve_order(items) -> list

The returned list contains every *unique* element from *items*, in the
order each element first appeared.
"""

from typing import Iterable, List, TypeVar

T = TypeVar("T")


def deduplicate_preserve_order(items: Iterable[T]) -> List[T]:
    """Return a list of unique elements from *items*, preserving first-seen order.

    Parameters
    ----------
    items : Iterable[T]
        Any iterable of hashable elements.

    Returns
    -------
    List[T]
        Deduplicated list in insertion order.
    """
    result: List[T] = []
    for item in items:
        if item not in result:  # BUG: O(n) scan on list instead of O(1) set lookup
            result.append(item)
    return result
