import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Optional;
import java.util.function.Predicate;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class Exercises {
    static Map<Integer, Long> change(long amount) {
        if (amount < 0) {
            throw new IllegalArgumentException("Amount cannot be negative");
        }
        var counts = new HashMap<Integer, Long>();
        for (var denomination : List.of(25, 10, 5, 1)) {
            counts.put(denomination, amount / denomination);
            amount %= denomination;
        }
        return counts;
    }

    // first then lowercase function
    public static Optional<String> firstThenLowerCase(List<String> strings, Predicate<String> predicate) {
        return strings.stream()
                .filter(predicate)
                .map(String::toLowerCase)
                .findFirst();
    }

    // say function
    private String phrase;

    private Exercises(String phrase) {
        this.phrase = phrase;
    }

    public static Exercises say(String... words) {
        return new Exercises(String.join(" ", words).trim());
    }

    public Exercises and(String word) {
        phrase += " " + word;
        return this;
    }

    public String phrase() {
        return phrase.trim();
    }

    // meaningfulLineCount function
    public static int meaningfulLineCount(String filePath) throws IOException {
        int meaningfulLinesCount = 0;

        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (!line.isEmpty() && !line.startsWith("#")) {
                    meaningfulLinesCount++;
                }
            }
        } catch (IOException e) {
            throw new IOException("No such file: " + filePath, e);
        }

        return meaningfulLinesCount;
    }
}

// Quaternion data class
record Quaternion(double a, double b, double c, double d) {
    static final Quaternion ZERO = new Quaternion(0, 0, 0, 0);
    static final Quaternion I = new Quaternion(0, 1, 0, 0);
    static final Quaternion J = new Quaternion(0, 0, 1, 0);
    static final Quaternion K = new Quaternion(0, 0, 0, 1);

    Quaternion {
        if (Double.isNaN(a) || Double.isNaN(b) || Double.isNaN(c) || Double.isNaN(d)) {
            throw new IllegalArgumentException("Coefficients cannot be NaN");
        }
    }

    List<Double> coefficients() {
        return List.of(a, b, c, d);
    }

    Quaternion plus(Quaternion q) {
        return new Quaternion(a + q.a, b + q.b, c + q.c, d + q.d);
    }

    Quaternion times(Quaternion q) {
        return new Quaternion(
                a * q.a - b * q.b - c * q.c - d * q.d,
                a * q.b + b * q.a + c * q.d - d * q.c,
                a * q.c - b * q.d + c * q.a + d * q.b,
                a * q.d + b * q.c - c * q.b + d * q.a
        );
    }

    Quaternion conjugate() {
        return new Quaternion(a, -b, -c, -d);
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        appendTerm(sb, a, "");
        appendTerm(sb, b, "i");
        appendTerm(sb, c, "j");
        appendTerm(sb, d, "k");
        return sb.length() == 0 ? "0" : sb.toString();
    }

    private void appendTerm(StringBuilder sb, double coefficient, String symbol) {
        if (coefficient == 0) return;
        if (sb.length() > 0 && coefficient > 0) sb.append("+");
        sb.append(coefficient == 1 || coefficient == -1 ? (coefficient < 0 ? "-" : "") + symbol : coefficient + symbol);
    }
}

// Binary Search Tree interface
sealed interface BinarySearchTree {
    int size();
    boolean contains(String value);
    BinarySearchTree insert(String value);
    String toString();
}

final class Node implements BinarySearchTree {
    String value;
    BinarySearchTree left;
    BinarySearchTree right;

    Node(String value) {
        this.value = value;
        this.left = new Empty();
        this.right = new Empty();
    }

    Node(String value, BinarySearchTree left, BinarySearchTree right) {
        this.value = value;
        this.left = left;
        this.right = right;
    }

    public int size() {
        return 1 + left.size() + right.size();
    }

    public BinarySearchTree insert(String value) {
        if (value.compareTo(this.value) < 0) {
            return new Node(this.value, left.insert(value), right);
        } else if (value.compareTo(this.value) > 0) {
            return new Node(this.value, left, right.insert(value));
        } else {
            return this;
        }
    }

    public boolean contains(String value) {
        if (this.value.equals(value)) {
            return true;
        } else if (value.compareTo(this.value) < 0) {
            return left.contains(value);
        } else {
            return right.contains(value);
        }
    }

    public String toString() {
        return ("(" + left.toString() + this.value + right.toString() + ")").replace("()", "");
    }
}

// implementing classes
final class Empty implements BinarySearchTree {
    public int size() {
        return 0;
    }

    public boolean contains(String value) {
        return false;
    }

    public BinarySearchTree insert(String value) {
        return new Node(value);
    }

    public String toString() {
        return "";
    }
}