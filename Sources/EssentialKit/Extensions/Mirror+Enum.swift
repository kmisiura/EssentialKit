import Foundation

public extension Mirror {
    static func reflectEnum(_ aEnum: Any) -> (parent: String, label: String, params: [String: Any])? {
        let reflection = Mirror(reflecting: aEnum)
        guard reflection.displayStyle == .enum else {
            return nil
        }
        guard let associated = reflection.children.first else {
            return ("\(reflection.subjectType)", "\(aEnum)", [:])
        }
        let values = Mirror(reflecting: associated.value).children
        var valuesArray = [String: Any]()
        if values.isEmpty {
            valuesArray[""] = associated.value
        } else {
            for case let item in values where item.label != nil {
                valuesArray[item.label!] = item.value
            }
        }
        return ("\(reflection.subjectType)", associated.label!, valuesArray)
    }
}
