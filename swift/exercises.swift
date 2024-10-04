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

//first then lower case function 
func firstThenLowerCase(of strings: [String], satisfying predicate: (String) -> Bool) -> String? {
    return strings.first(where: predicate)?.lowercased()
}

// say function 
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


// meaningfulLineCount function
func meaningfulLineCount(_ filePath: String) -> Result<Int, Error> {
    do {
        let content = try String(contentsOfFile: filePath, encoding: .utf8)
        
        let lines = content.split(separator: "\n")
        
        let meaningfulLines = lines.filter { line in
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            return !trimmedLine.isEmpty && !trimmedLine.hasPrefix("#")
        }
        
        return .success(meaningfulLines.count)
    } catch {
        return .failure(error)
    }
}


// Quaternion struct
struct Quaternion: CustomStringConvertible, Equatable {
    let a, b, c, d: Double 

    static let ZERO = Quaternion(a: 0, b: 0, c: 0, d: 0) 
    static let ONE = Quaternion(a: 1, b: 0, c: 0, d: 0) 
    static let I = Quaternion(a: 0, b: 1, c: 0, d: 0)   
    static let J = Quaternion(a: 0, b: 0, c: 1, d: 0)  
    static let K = Quaternion(a: 0, b: 0, c: 0, d: 1)  

    init(a: Double = 0, b: Double = 0, c: Double = 0, d: Double = 0) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }

    var coefficients: [Double] {
        return [a, b, c, d]
    }

    var conjugate: Quaternion {
        return Quaternion(a: a, b: -b, c: -c, d: -d)
    }

    static func +(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        return Quaternion(a: lhs.a + rhs.a, b: lhs.b + rhs.b, c: lhs.c + rhs.c, d: lhs.d + rhs.d)
    }

    static func *(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        return Quaternion(
            a: lhs.a * rhs.a - lhs.b * rhs.b - lhs.c * rhs.c - lhs.d * rhs.d,  // Real part
            b: lhs.a * rhs.b + lhs.b * rhs.a + lhs.c * rhs.d - lhs.d * rhs.c,  // i part
            c: lhs.a * rhs.c - lhs.b * rhs.d + lhs.c * rhs.a + lhs.d * rhs.b,  // j part
            d: lhs.a * rhs.d + lhs.b * rhs.c - lhs.c * rhs.b + lhs.d * rhs.a   // k part
        )
    }

    static func ==(lhs: Quaternion, rhs: Quaternion) -> Bool {
        return abs(lhs.a - rhs.a) < 1e-10 &&
               abs(lhs.b - rhs.b) < 1e-10 &&
               abs(lhs.c - rhs.c) < 1e-10 &&
               abs(lhs.d - rhs.d) < 1e-10
    }

    var description: String {
        var parts: [String] = []

        if a != 0 {
            parts.append("\(a)") 
        }
        if b != 0 {
            parts.append(b == 1 ? "i" : (b == -1 ? "-i" : "\(b)i"))
        }
        if c != 0 {
            parts.append(c == 1 ? "j" : (c == -1 ? "-j" : "\(c)j"))
        }
        if d != 0 {
            parts.append(d == 1 ? "k" : (d == -1 ? "-k" : "\(d)k"))
        }

        return parts.isEmpty ? "0" : parts.joined(separator: "+").replacingOccurrences(of: "+-", with: "-")
    }
}


// Binary Search Tree enum 
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
                return self 
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
