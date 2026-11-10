#include <iostream>
#include "ring_buffer.hpp"

int main() {
    constexpr std::size_t CAP = 8;
    RingBuffer<int> rb(CAP);

    std::cout << "Enter integers (Ctrl-D / Ctrl-Z to stop):\n";
    int n;
    while (std::cin >> n) {
        rb.push(n);
        std::cout << "  pushed " << n
                  << "  (size=" << rb.size()
                  << ", full=" << rb.full() << ")\n";
    }

    std::cout << "\nDraining buffer:\n";
    while (!rb.empty()) {
        std::cout << "  " << rb.pop() << "\n";
    }

    return 0;
}
