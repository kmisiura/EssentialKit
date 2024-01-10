import Foundation

public extension Array where Element: Hashable {
    func next(after item: Element) -> Element? {
        if let index = firstIndex(of: item), index + 1 <= self.count {
            return index + 1 == self.count ? self[0] : self[index + 1]
        }
        return nil
    }
    
    func prev(before item: Element) -> Element? {
        if let index = firstIndex(of: item), index >= 0 {
            return index == 0 ? self.last : self[index - 1]
        }
        return nil
    }
    
    func removingDuplicates() -> Self {
        var seen = Set<Element>()
        
        return self.compactMap { element in
            guard !seen.contains(element)
            else { return nil }
            
            seen.insert(element)
            return element
        }
    }
    
    @discardableResult mutating func removeDuplicates() -> Self {
        var seen = Set<Element>()
        var duplicates = Array<Element>()
        
        self.removeAll { element in
            guard !seen.contains(element) else {
                duplicates.append(element)
                return true
            }
            
            seen.insert(element)
            return false
        }
        
        return duplicates
    }
}
