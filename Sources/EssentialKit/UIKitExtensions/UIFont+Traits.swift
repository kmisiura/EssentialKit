#if os(iOS)
import UIKit

public extension UIFont {
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
    
    var bold: UIFont {
        return withTraits(traits: .traitBold)
    }
    
    var italic: UIFont {
        return withTraits(traits: .traitItalic)
    }
    
    static func preferredFont(for style: TextStyle, weight: Weight) -> UIFont {
            let metrics = UIFontMetrics(forTextStyle: style)
            let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
            let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
            return metrics.scaledFont(for: font)
    }
}
#endif
