import Foundation

struct NegativeAmountError: Error {}
struct NoSuchFileError: Error {}

func change(_ amount: Int) -> Result<[Int:Int], NegativeAmountError> {
    if amount < 0 {
        return .failure(NegativeAmountError())
    }
    var (counts, remaining) = ([Int:Int](), amount)
    for denomination in [25, 10, 5, 1] {
        (counts[denomination], remaining) = 
            remaining.quotientAndRemainder(dividingBy: denomination)
    }
    return .success(counts)
}

// Write your first then lower case function here
func firstThenLowerCase(of strings: [String], satisfying predicate: (String) -> Bool) -> String? {
    return strings.first(where: predicate)?.lowercased()
}

// Write your say function here
class Say {
    var phrase: String

    init(_ initialPhrase: String = "") {
        self.phrase = initialPhrase
    }

    func and(_ word: String) -> Say {
        self.phrase += " " + word
        return self
    }

    var phraseResult: String {
        return phrase.trimmingCharacters(in: .whitespaces)
    }
}

func say(_ initialPhrase: String = "") -> Say {
    return Say(initialPhrase)
}


// Write your meaningfulLineCount function here

func meaningfulLineCount(_ filePath: String) -> Result<Int, Error> {
    do {
        // Read the file content
        let content = try String(contentsOfFile: filePath, encoding: .utf8)
        
        // Split content into lines
        let lines = content.split(separator: "\n")
        
        // Filter out meaningful lines
        let meaningfulLines = lines.filter { line in
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            return !trimmedLine.isEmpty && !trimmedLine.hasPrefix("#")
        }
        
        // Return the count of meaningful lines
        return .success(meaningfulLines.count)
    } catch {
        // Return an error if file not found
        return .failure(error)
    }
}


// Write your Quaternion struct here

struct Quaternion: CustomStringConvertible, Equatable {
    let a,b,c,d: Double 

    // static constants 
    static let ZERO = Quaternion(a: 0, b: 0, c: 0, d: 0) 
    static let ONE = Quaternion(a: 1, b: 0, c: 0, d: 0) 
    static let I = Quaternion(a: 0, b: 1, c: 0, d: 0)   
    static let J = Quaternion(a: 0, b: 0, c: 1, d: 0)  
    static let K = Quaternion(a: 0, b: 0, c: 0, d: 1)  

    // initializer but defualt so any part can be omitted
    init(a: Double = 0, b: Double = 0, c: Double = 0, d: Double = 0) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }
    // returns the quaternion's coefficients as an array 
    var coefficients: [Double] {
        return [a, b, c, d]
    }
    // returns the conjugate of the quaternion (negates the imaginary parts)
    var conjugate: Quaternion {
        return Quaternion(a: a, b: -b, c: -c, d: -d)
    }

     // addition 
    static func +(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        return Quaternion(a: lhs.a + rhs.a, b: lhs.b + rhs.b, c: lhs.c + rhs.c, d: lhs.d + rhs.d)
    }

    // multiplication 
    static func *(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        return Quaternion(
            a: lhs.a * rhs.a - lhs.b * rhs.b - lhs.c * rhs.c - lhs.d * rhs.d,  // Real part
            b: lhs.a * rhs.b + lhs.b * rhs.a + lhs.c * rhs.d - lhs.d * rhs.c,  // i part
            c: lhs.a * rhs.c - lhs.b * rhs.d + lhs.c * rhs.a + lhs.d * rhs.b,  // j part
            d: lhs.a * rhs.d + lhs.b * rhs.c - lhs.c * rhs.b + lhs.d * rhs.a   // k part
        )
    }

    // equal check between two quaternions
    static func ==(lhs: Quaternion, rhs: Quaternion) -> Bool {
        return abs(lhs.a - rhs.a) < 1e-10 &&
               abs(lhs.b - rhs.b) < 1e-10 &&
               abs(lhs.c - rhs.c) < 1e-10 &&
               abs(lhs.d - rhs.d) < 1e-10
    }

    // provides a string representation of the quaternion, omitting zero parts
    var description: String {
        var parts: [String] = []

        if a != 0 {
            parts.append("\(a)") 
        }
        if b != 0 {
            // append i part 
            parts.append(b == 1 ? "i" : (b == -1 ? "-i" : "\(b)i"))
        }
        if c != 0 {
            // append j part 
            parts.append(c == 1 ? "j" : (c == -1 ? "-j" : "\(c)j"))
        }
        if d != 0 {
            // append k part 
            parts.append(d == 1 ? "k" : (d == -1 ? "-k" : "\(d)k"))
        }

        // join parts
        return parts.isEmpty ? "0" : parts.joined(separator: "+").replacingOccurrences(of: "+-", with: "-")
    }
}


// Write your Binary Search Tree enum here

indirect enum BinarySearchTree {
    case empty
    case node(String, BinarySearchTree, BinarySearchTree)

    var size: Int {
        switch self {
        case .empty:
            return 0
        case let .node(_, left, right):
            return 1 + left.size + right.size
        }
    }

    func contains(_ value: String) -> Bool {
        switch self {
        case .empty:
            return false
        case let .node(data, left, right):
            if value < data {
                return left.contains(value)
            } else if value > data {
                return right.contains(value)
            } else {
                return true
            }
        }
    }

    func insert(_ value: String) -> BinarySearchTree {
        switch self {
        case .empty:
            return .node(value, .empty, .empty)
        case let .node(data, left, right):
            if value < data {
                return .node(data, left.insert(value), right)
            } else if value > data {
                return .node(data, left, right.insert(value))
            } else {
                return self // No duplicates allowed
            }
        }
    }

    func description() -> String {
        switch self {
        case .empty:
            return "()"
        case let .node(data, left, right):
            let leftDesc = left.description()
            let rightDesc = right.description()
            return "(\(leftDesc)\(data)\(rightDesc))".replacingOccurrences(of: "()", with: "")
        }
    }
}