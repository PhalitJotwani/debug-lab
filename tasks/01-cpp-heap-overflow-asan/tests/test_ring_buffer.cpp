#include <cassert>
#include <iostream>
#include <vector>
#include "ring_buffer.hpp"

/// Minimal test harness — no framework required.
/// Compile with:  g++ -std=c++17 -fsanitize=address -g -I repo/ tests/test_ring_buffer.cpp

static void test_basic_push_pop() {
    RingBuffer<int> rb(4);
    rb.push(10);
    rb.push(20);
    rb.push(30);
    assert(rb.size() == 3);
    assert(!rb.full());
    assert(rb.peek() == 10);

    assert(rb.pop() == 10);
    assert(rb.pop() == 20);
    assert(rb.pop() == 30);
    assert(rb.empty());
    std::cout << "[PASS] test_basic_push_pop\n";
}

static void test_wrap_around() {
    // Capacity 4, push 5 elements to force a wrap-around.
    // This triggers the bug: push() increments head_ past the end
    // of the allocated array on the 5th element.
    RingBuffer<int> rb(4);
    rb.push(1);  // head_=0
    rb.push(2);  // head_=1
    rb.push(3);  // head_=2
    rb.push(4);  // head_=3  (buffer full)
    rb.push(5);  // head_=4  <-- BUG: writes buffer_[4], out of bounds!

    // After wrapping the oldest element (1) should have been overwritten.
    // Expected contents from tail to head: 2, 3, 4, 5
    assert(rb.size() == 4);
    assert(rb.full());

    assert(rb.pop() == 2);
    assert(rb.pop() == 3);
    assert(rb.pop() == 4);
    assert(rb.pop() == 5);
    assert(rb.empty());
    std::cout << "[PASS] test_wrap_around\n";
}

static void test_empty_and_full() {
    RingBuffer<int> rb(2);
    assert(rb.empty());
    assert(!rb.full());
    assert(rb.size() == 0);

    rb.push(42);
    assert(!rb.empty());
    assert(!rb.full());

    rb.push(43);
    assert(rb.full());
    assert(rb.size() == 2);

    rb.pop();
    rb.pop();
    assert(rb.empty());
    std::cout << "[PASS] test_empty_and_full\n";
}

int main() {
    std::cout << "=== RingBuffer Test Suite ===\n";
    test_basic_push_pop();
    test_wrap_around();
    test_empty_and_full();
    std::cout << "All tests passed.\n";
    return 0;
}
