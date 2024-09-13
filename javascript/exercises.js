import { open } from "node:fs/promises"

export function change(amount) {
  if (!Number.isInteger(amount)) {
    throw new TypeError("Amount must be an integer")
  }
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative")
  }
  let [counts, remaining] = [{}, amount]
  for (const denomination of [25, 10, 5, 1]) {
    counts[denomination] = Math.floor(remaining / denomination)
    remaining %= denomination
  }
  return counts
}

// Write your first then lower case function here
export function firstThenLowerCase(a, p) {
  return a.find(p)?.toLowerCase()
}
// Write your powers generator here
export function* powersGenerator({ ofBase: base, upTo: limit }) {
  let power = 1
  while (power <= limit) {
    yield power
    power *= base
  }
}

// Write your say function here
export function say(s = "") {
  return function (next) {
    if (next === undefined) {
      return s.trim()
    }
    return say(s + " " + next)
  }
}

// Write your line count function here
export function meaningfulLineCount(filePath) {
  try {
    const fs = require("fs")
    const data = fs.readFileSync(filePath, "utf8")
    const lines = data.split("\n")

    const meaningfulLines = lines.filter((line) => {
      const trimmedLine = line.trim()
      return trimmedLine.length > 0 && !trimmedLine.startsWith("#")
    })

    return meaningfulLines.length
  } catch (error) {
    if (error.code === "ENOENT") {
      throw new Error("No such file: " + filePath)
    }
    throw error
  }
}

// Write your Quaternion class here
export class Quaternion {
  constructor(a, b, c, d) {
    Object.assign(this, { a, b, c, d })
    Object.freeze(this)
  }

  plus(v) {
    return new Quaternion(
      this.a + v.a,
      this.b + v.b,
      this.c + v.c,
      this.d + v.d
    )
  }

  get conjugate() {
    return new Quaternion(this.a, -this.b, -this.c, -this.d)
  }

  times(v) {
    const a1 = this.a,
      b1 = this.b,
      c1 = this.c,
      d1 = this.d
    const a2 = v.a,
      b2 = v.b,
      c2 = v.c,
      d2 = v.d

    const newA = a1 * a2 - b1 * b2 - c1 * c2 - d1 * d2
    const newB = a1 * b2 + b1 * a2 + c1 * d2 - d1 * c2
    const newC = a1 * c2 - b1 * d2 + c1 * a2 + d1 * b2
    const newD = a1 * d2 + b1 * c2 - c1 * b2 + d1 * a2

    return new Quaternion(newA, newB, newC, newD)
  }

  toString() {
    const formatTerm = (coef, variable) => {
      if (coef === 0) return ""
      if (coef > 0) return `+ ${coef}${variable}`
      return `- ${Math.abs(coef)}${variable}`
    }

    const aStr =
      this.a === 0 && this.b === 0 && this.c === 0 && this.d === 0
        ? "0"
        : `${this.a !== 0 ? this.a : ""}${formatTerm(this.b, "i")}${formatTerm(
            this.c,
            "j"
          )}${formatTerm(this.d, "k")}`

    return aStr.trim().replace(/^(\+|\s)/, "")
  }

  get coefficients() {
    return [this.a, this.b, this.c, this.d]
  }
}
