import Foundation

public extension String {
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    mutating func append(path: String) {
        guard path.isEmpty == false else { return }
        
        let selfSlash: Bool = self.last == "/"
        let pathSlash: Bool = path.first == "/"
        
        if selfSlash && pathSlash {
            self.append(contentsOf: path.dropFirst())
            return
        }
        
        if !selfSlash && !pathSlash {
            self.append("/")
        }
        
        self.append(path)
    }
    
    func appending(path: String) -> String {
        guard path.isEmpty == false else { return self }
        
        let selfSlash: Bool = self.last == "/"
        let pathSlash: Bool = path.first == "/"
        
        if selfSlash && pathSlash {
            return self.appending(path.dropFirst())
        }
        
        if !selfSlash && !pathSlash {
            return self + "/" + path
        }
        
        return self.appending(path)
    }
    
    var firstPathComponent: String? {
        guard let url = URL(string: self) else { return nil }
        let components = url.pathComponents
        if components.first == "/" && components.count > 1 {
            return components[1]
        } else if components.first == "/" {
            return nil
        }
        
        return components.first
    }
    
    var lastPathComponent: String? {
        guard let url = URL(string: self) else { return nil }
        let components = url.pathComponents
        if components.last == "/" && components.count > 1 {
            return components[components.count - 2]
        } else if components.last == "/" {
            return nil
        }
        
        return components.last
    }
    
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
    
    func UUIDCompare(_ uuidString: String) -> Bool {
        return UUID(uuidString: self) == UUID(uuidString: uuidString)
    }
}

typealias UUIDString = String

extension UUIDString {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.UUIDCompare(rhs)
    }
}

public extension Array where Element == String {
    
    /// Helper function to construct multiple lines messages from array of strings
    ///
    /// - Parameter withBullet: The first charachter of every line. Default: No bullet
    func multilineMessage(withBullet bullet: String = "") -> String {
        if self.count == 1 {
            return self[0]
        } else {
            return self.map({ bullet + $0 }).joined(separator: "\n")
        }
    }
}

public extension String {
    
    enum StringCaseFormat {
        
        public enum SnakeCase {
            case lower
            case upper
            case capitalized
        }
        
        public enum CamelCase {
            case `default`
            case capitalized
        }
    }
    
    func caseSplit() -> [String] {
        var res: [String] = []
        let trim = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let alphanumerics = CharacterSet.alphanumerics
        let uppercaseLetters = CharacterSet.uppercaseLetters
        let lowercaseLetters = CharacterSet.lowercaseLetters
        trim.split(separator: " ").forEach { str in
            var previousCase = 0
            var currentCase = 0
            var caseChange = false
            var scalars = UnicodeScalarView()
            for scalar in str.unicodeScalars {
                if alphanumerics.contains(scalar) {
                    if uppercaseLetters.contains(scalar) {
                        currentCase = 1
                    } else if lowercaseLetters.contains(scalar) {
                        currentCase = 2
                    } else {
                        currentCase = 0
                    }
                    let letterInWord = scalars.count
                    if !caseChange && letterInWord > 0 {
                        if currentCase != previousCase {
                            if previousCase == 1 {
                                if letterInWord > 1 {
                                    caseChange = true
                                }
                            } else {
                                caseChange = true
                            }
                        }
                    }
                    if caseChange {
                        res.append(String(scalars))
                        scalars.removeAll()
                    }
                    scalars.append(scalar)
                    caseChange = false
                    previousCase = currentCase
                } else {
                    caseChange = true
                }
            }
            if scalars.count > 0 {
                res.append(String(scalars))
            }
        }
        return res
    }
    
    func snakeCased(_ format: StringCaseFormat.SnakeCase = .lower) -> String {
        let split = self.caseSplit()
        if format == .lower {
            return split.map { $0.lowercased() }.joined(separator: "_")
        } else if format == .upper {
            return split.map { $0.uppercased() }.joined(separator: "_")
        }
        return split.map { $0.capitalized }.joined(separator: "_")
    }
    
    func camelCased(_ format: StringCaseFormat.CamelCase = .default) -> String {
        var res: [String] = []
        for (idx, str) in self.caseSplit().enumerated() {
            if idx == 0 && format == .default {
                res.append(str.lowercased())
                continue
            }
            res.append(str.capitalized)
        }
        return res.joined()
    }
    
    var lastDomainNameItem: String {
        let components = self.split(separator: ".").filter { !$0.isEmpty }
        guard components.count > 1 else { return self }
        guard let last = components.last else { return self }
        return String(last)
    }
}
