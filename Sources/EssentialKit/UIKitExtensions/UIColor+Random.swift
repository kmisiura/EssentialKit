#if os(iOS)
import UIKit

public extension UIColor {
    static var random: UIColor {
        UIColor(hue: CGFloat(drand48()), saturation: CGFloat(drand48()), brightness: CGFloat(drand48()), alpha: 1)
    }
}
#endif
