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

    // Write your first then lower case function here
    public static Optional<String> firstThenLowerCase(List<String> strings, Predicate<String> predicate) {
        return strings.stream()
                .filter(predicate)
                .map(String::toLowerCase)
                .findFirst();
    }

    // Write your say function here
    
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



    // Write your line count function here
    
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

// Write your Quaternion record class here
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

    private void appendTerm(StringBuilder sb, double coeff, String symbol) {
        if (coeff == 0) return;
        if (sb.length() > 0 && coeff > 0) sb.append("+");
        sb.append(coeff == 1 || coeff == -1 ? (coeff < 0 ? "-" : "") + symbol : coeff + symbol);
    }
}




// Write your BinarySearchTree sealed interface and its implementations here
sealed interface BinarySearchTree permits Empty, Node {
    int size();
    boolean contains(String s);
    BinarySearchTree insert(String s);
}

final class Empty implements BinarySearchTree {
    public int size() {
        return 0; 
    }

    public boolean contains(String s) {
        return false; 
    }

    public BinarySearchTree insert(String s) {
        return new Node(s); 
    }

    public String toString() {
        return "()"; 
    }
}

final class Node implements BinarySearchTree {
    String data;
    BinarySearchTree left;
    BinarySearchTree right;

    // Constructor for creating a new Node
    Node(String data) {
        this.data = data;
        this.left = new Empty();
        this.right = new Empty();
    }

    // New constructor for creating a Node with left and right children
    Node(String data, BinarySearchTree left, BinarySearchTree right) {
        this.data = data;
        this.left = left;
        this.right = right;
    }

    public int size() {
        return 1 + left.size() + right.size();
    }

    public BinarySearchTree insert(String s) {
        if (s.compareTo(this.data) < 0) {
            return new Node(this.data, left.insert(s), right); 
        } else if (s.compareTo(this.data) > 0) {
            return new Node(this.data, left, right.insert(s)); 
        } else {
            return this; // No changes made if the value already exists
        }
    }

    public boolean contains(String s) {
        if (this.data.equals(s)) {
            return true;
        } else if (s.compareTo(this.data) < 0) {
            return left.contains(s); 
        } else {
            return right.contains(s);
        }
    }

    public String toString() {
        return ("(" + left.toString() + this.data + right.toString() + ")").replace("()", ""); 
    }
}