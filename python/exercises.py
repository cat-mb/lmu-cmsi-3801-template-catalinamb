from dataclasses import dataclass
from collections.abc import Callable


def change(amount: int) -> dict[int, int]:
    if not isinstance(amount, int):
        raise TypeError('Amount must be an integer')
    if amount < 0:
        raise ValueError('Amount cannot be negative')
    counts, remaining = {}, amount
    for denomination in (25, 10, 5, 1):
        counts[denomination], remaining = divmod(remaining, denomination)
    return counts


# Write your first then lower case function here
def first_then_lower_case(lst, predicate):
    for item in lst:
        if predicate(item):
            return item.lower()
    return None

# Write your powers generator here
def powers_generator(base, limit):
    power = 1
    while power <= limit:
        yield power
        power *= base

# Write your say function here
def say(s=""):
    def next_word(next=None):
        if next is None:
            return s.strip()
        return say(s + " " + next)
    return next_word

# Write your line count function here
def meaningful_line_count(file_path):
    try:
        with open(file_path, 'r') as file:
            lines = file.readlines()
    except FileNotFoundError as e:
        raise FileNotFoundError(f"No such file: {file_path}") from e

    meaningful_lines = [
        line for line in lines if line.strip() and not line.strip().startswith('#')
    ]
    return len(meaningful_lines)

# Write your Quaternion class here
class Quaternion:
    def __init__(self, a, b, c, d):
        self.a = float(a)
        self.b = float(b)
        self.c = float(c)
        self.d = float(d)

    def coefficients(self):
        return (self.a, self.b, self.c, self.d)

    def __add__(self, other):
        if not isinstance(other, Quaternion):
            return NotImplemented
        return Quaternion(
            self.a + other.a,
            self.b + other.b,
            self.c + other.c,
            self.d + other.d
        )

    def __mul__(self, other):
        if not isinstance(other, Quaternion):
            return NotImplemented
        a1, b1, c1, d1 = self.coefficients()
        a2, b2, c2, d2 = other.coefficients()

        newA = a1 * a2 - b1 * b2 - c1 * c2 - d1 * d2
        newB = a1 * b2 + b1 * a2 + c1 * d2 - d1 * c2
        newC = a1 * c2 - b1 * d2 + c1 * a2 + d1 * b2
        newD = a1 * d2 + b1 * c2 - c1 * b2 + d1 * a2

        return Quaternion(newA, newB, newC, newD)

    def conjugate(self):
        return Quaternion(self.a, -self.b, -self.c, -self.d)

    def __eq__(self, other):
        if not isinstance(other, Quaternion):
            return NotImplemented
        return (
            self.a == other.a and
            self.b == other.b and
            self.c == other.c and
            self.d == other.d
        )

    def __str__(self):
        parts = []
        if self.a != 0 or not (self.b or self.c or self.d):
            parts.append(f"{self.a}")
        if self.b != 0:
            parts.append(f"{'+' if self.b > 0 and self.a != 0 else ''}{self.b}i")
        if self.c != 0:
            parts.append(f"{'+' if self.c > 0 and (self.a != 0 or self.b != 0) else ''}{self.c}j")
        if self.d != 0:
            parts.append(f"{'+' if self.d > 0 and (self.a != 0 or self.b != 0 or self.c != 0) else ''}{self.d}k")
        return ''.join(parts) if parts else '0'