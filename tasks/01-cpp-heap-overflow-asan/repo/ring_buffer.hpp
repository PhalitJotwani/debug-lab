#ifndef RING_BUFFER_HPP
#define RING_BUFFER_HPP

#include <cstddef>
#include <stdexcept>
#include <memory>

/// A fixed-capacity ring buffer (circular buffer).
/// Elements are pushed at the head and popped from the tail.
template <typename T>
class RingBuffer {
public:
    /// Construct a ring buffer that can hold up to @p capacity elements.
    explicit RingBuffer(std::size_t capacity)
        : capacity_{capacity},
          size_{0},
          head_{0},
          tail_{0},
          buffer_{new T[capacity]} {}

    /// Push an element into the buffer.
    /// If the buffer is full the oldest element is silently overwritten.
    void push(const T& value) {
        if (size_ == capacity_) {
            // Buffer is full — overwrite the oldest element and advance tail.
            // BUG: head_ is incremented WITHOUT modulo, so when head_ ==
            //      capacity_ - 1 the next value of head_ becomes capacity_,
            //      which is one past the end of buffer_.
            head_++;                     // <-- should be: head_ = (head_ + 1) % capacity_;
            buffer_[head_] = value;      // HEAP-BUFFER-OVERFLOW when head_ == capacity_
            tail_ = (tail_ + 1) % capacity_;
        } else {
            if (size_ > 0) {
                head_ = (head_ + 1) % capacity_;
            }
            buffer_[head_] = value;
            ++size_;
        }
    }

    /// Remove and return the oldest element.
    /// @throws std::underflow_error if the buffer is empty.
    T pop() {
        if (empty()) {
            throw std::underflow_error("pop() called on empty RingBuffer");
        }
        T value = buffer_[tail_];
        tail_ = (tail_ + 1) % capacity_;
        --size_;
        return value;
    }

    /// Return the oldest element without removing it.
    /// @throws std::underflow_error if the buffer is empty.
    const T& peek() const {
        if (empty()) {
            throw std::underflow_error("peek() called on empty RingBuffer");
        }
        return buffer_[tail_];
    }

    /// Current number of elements in the buffer.
    std::size_t size() const noexcept { return size_; }

    /// True when the buffer holds no elements.
    bool empty() const noexcept { return size_ == 0; }

    /// True when the buffer has reached its maximum capacity.
    bool full() const noexcept { return size_ == capacity_; }

    /// Maximum number of elements the buffer can hold.
    std::size_t capacity() const noexcept { return capacity_; }

private:
    std::size_t capacity_;
    std::size_t size_;
    std::size_t head_;   // index where the most-recently-pushed element lives
    std::size_t tail_;   // index of the oldest element
    std::unique_ptr<T[]> buffer_;
};

#endif // RING_BUFFER_HPP
