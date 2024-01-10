#if os(iOS)
import UIKit

public extension UITextView {
    
    ///Line Fragment padding of text container. Set to zero in order to fix textView padding
    @IBInspectable var lineFragmentPadding: CGFloat {
        get {
            return textContainer.lineFragmentPadding
        }
        set {
            textContainer.lineFragmentPadding = newValue
        }
    }
    
    ///Inset of text container. Set to zero in order to fix textView padding
    @IBInspectable var containerInset: UIEdgeInsets {
        get {
            return textContainerInset
        }
        set {
            textContainerInset = newValue
        }
    }
}
#endif
