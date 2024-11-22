#include <stdexcept>
#include <memory>
#include <algorithm>
using namespace std;

#define MAX_CAPACITY 32768
#define INITIAL_CAPACITY 16

template <typename T>
class Stack {
private:
    unique_ptr<T[]> elements;
    int capacity;
    int top;

    void reallocate() {
        int new_capacity = min(capacity * 2, MAX_CAPACITY);
        auto new_elements = make_unique<T[]>(new_capacity);
        copy(&elements[0], &elements[top], &new_elements[0]);
        elements = std::move(new_elements);
        capacity = new_capacity;
    }

public:
    Stack() : elements(make_unique<T[]>(INITIAL_CAPACITY)), capacity(INITIAL_CAPACITY), top(0) {}

    int size() const {
        return top;
    }

    bool is_empty() const {
        return top == 0;
    }

    bool is_full() const {
        return top == capacity;
    }

    void push(const T& value) {
    if (is_full()) {
        if (capacity == MAX_CAPACITY) {
            throw overflow_error("Stack has reached maximum capacity");
        }
        reallocate();
    }
    elements[top++] = value;
}


    T pop() {
        if (is_empty()) throw underflow_error("cannot pop from empty stack");
        return elements[--top];
    }
};
