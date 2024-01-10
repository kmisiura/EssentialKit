#if os(iOS)
import UIKit

public extension UILabel {
    static func create(withText text: String,
                       textAlignment: NSTextAlignment = .center,
                       fontSize: CGFloat = 16,
                       fontWeight: UIFont.Weight = .regular) -> UILabel {
        let label = UILabel(frame: .zero)
        label.text = text
        label.textAlignment = textAlignment
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: fontSize, weight: fontWeight))
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }
}
#endif
