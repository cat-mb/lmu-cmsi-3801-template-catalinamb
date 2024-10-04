import java.io.BufferedReader
import java.io.FileReader
import java.io.IOException

fun change(amount: Long): Map<Int, Long> {
    require(amount >= 0) { "Amount cannot be negative" }
    
    val counts = mutableMapOf<Int, Long>()
    var remaining = amount
    for (denomination in listOf(25, 10, 5, 1)) {
        counts[denomination] = remaining / denomination
        remaining %= denomination
    }
    return counts
}

// Write your first then lower case function here
fun firstThenLowerCase(words: List<String>, predicate: (String) -> Boolean): String? {
    return words.firstOrNull(predicate)?.lowercase()
}

// Write your say function here
class Say(private val sentence: String = "") {
    val phrase: String
        get() = sentence.trim()

    fun and(nextWord: String): Say {
        return Say("$sentence $nextWord")
    }
}

fun say(word: String = ""): Say {
    return Say(word)
}

// Write your meaningfulLineCount function here
fun meaningfulLineCount(filePath: String): Long {
    val inputFile = java.io.File(filePath)
    if (!inputFile.exists()) {
        throw IOException("No such file")
    }

    return inputFile.readLines()
        .filterNot { it.isBlank() || it.startsWith("//") }
        .count().toLong()
}

// Write your Quaternion data class here
data class Quaternion(val a: Double, val b: Double, val c: Double, val d: Double) {
    companion object {
        val ZERO = Quaternion(0.0, 0.0, 0.0, 0.0)
        val I = Quaternion(0.0, 1.0, 0.0, 0.0)
        val J = Quaternion(0.0, 0.0, 1.0, 0.0)
        val K = Quaternion(0.0, 0.0, 0.0, 1.0)
    }

    operator fun plus(q: Quaternion): Quaternion {
        return Quaternion(a + q.a, b + q.b, c + q.c, d + q.d)
    }

    operator fun times(q: Quaternion): Quaternion {
        return Quaternion(
            a * q.a - b * q.b - c * q.c - d * q.d,
            a * q.b + b * q.a + c * q.d - d * q.c,
            a * q.c - b * q.d + c * q.a + d * q.b,
            a * q.d + b * q.c - c * q.b + d * q.a
        )
    }

    fun coefficients(): List<Double> = listOf(a, b, c, d)

    fun conjugate(): Quaternion = Quaternion(a, -b, -c, -d)

    override fun toString(): String {
        return buildString {
            if (a != 0.0) append(a)
            if (b != 0.0) append("${if (b > 0 && isNotEmpty()) "+" else ""}${if (b == 1.0) "" else b}i")
            if (c != 0.0) append("${if (c > 0 && isNotEmpty()) "+" else ""}${if (c == 1.0) "" else c}j")
            if (d != 0.0) append("${if (d > 0 && isNotEmpty()) "+" else ""}${if (d == 1.0) "" else d}k")
            if (isEmpty()) append("0")
        }
    }
}

// Write your Binary Search Tree interface and implementing classes here
sealed interface BinarySearchTree {
    fun size(): Int
    fun contains(value: String): Boolean
    fun insert(value: String): BinarySearchTree
    override fun toString(): String

    object Empty : BinarySearchTree {
        override fun size(): Int = 0
        override fun contains(value: String): Boolean = false
        override fun insert(value: String): BinarySearchTree = Node(value, Empty, Empty)
        override fun toString(): String = "()"
    }
}

data class Node(val value: String, val left: BinarySearchTree = BinarySearchTree.Empty, val right: BinarySearchTree = BinarySearchTree.Empty) : BinarySearchTree {
    override fun size(): Int = 1 + left.size() + right.size()

    override fun contains(value: String): Boolean {
        return when {
            value == this.value -> true
            value < this.value -> left.contains(value)
            else -> right.contains(value)
        }
    }

    override fun insert(value: String): BinarySearchTree {
        return when {
            value < this.value -> Node(this.value, left.insert(value), right)
            value > this.value -> Node(this.value, left, right.insert(value))
            else -> this
        }
    }

    override fun toString(): String {
        val leftStr = if (left is BinarySearchTree.Empty) "" else "($left)"
        val rightStr = if (right is BinarySearchTree.Empty) "" else "($right)"
        return "$leftStr$value$rightStr"
    }
}
