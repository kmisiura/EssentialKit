#if os(iOS)

import UIKit

public extension UIView {
    
    /// Load view from nib
    /// - Parameter name: Name of the nib.
    /// Default: same name as the view class name.
    /// - Returns: View created from nib
    class func loadFromNib<T: UIView>(name: String = String(describing: T.self)) -> T {
        guard let view = Bundle(for: T.self).loadNibNamed(name, owner: nil, options: nil)?.first as? T else {
            fatalError("Could not load view with type " + String(describing: name))
        }
        return view
    }
}

#endif
