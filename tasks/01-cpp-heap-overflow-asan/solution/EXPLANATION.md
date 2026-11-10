# Root Cause

In `ring_buffer.hpp`, the `push()` method has an off-by-one error in the
full-buffer (wrap-around) branch.  When the buffer is full the code does:

```cpp
head_++;
buffer_[head_] = value;
```

The increment is **not taken modulo `capacity_`**, so when `head_` is at its
maximum valid index (`capacity_ - 1`) the post-increment sets it to
`capacity_` — one element **past the end** of the heap-allocated array.
The subsequent write to `buffer_[capacity_]` is a **heap-buffer-overflow**.

The bug only manifests when the buffer has been filled to capacity at least
once and a new element is pushed, forcing a wrap-around.

# How to Find It

1. Compile with AddressSanitizer:
   ```
   g++ -std=c++17 -fsanitize=address -g -I repo/ tests/test_ring_buffer.cpp -o test
   ./test
   ```
2. ASan reports a `heap-buffer-overflow` on the write in `push()`, showing the
   exact source line (`buffer_[head_] = value;`) and the allocation size.
3. Inspecting the code reveals that the full-buffer branch increments `head_`
   without modulo, unlike the non-full branch which correctly uses
   `head_ = (head_ + 1) % capacity_`.

# Why the Fix Is Correct

The fix changes the full-buffer branch to:

```cpp
head_ = (head_ + 1) % capacity_;
buffer_[head_] = value;
```

The modulo operation ensures `head_` always stays within `[0, capacity_)`,
so the array write can never go out of bounds.  The rest of the ring-buffer
logic (tail advancement, size tracking) is unaffected.
