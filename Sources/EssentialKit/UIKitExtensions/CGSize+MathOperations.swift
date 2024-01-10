import CoreGraphics
import Foundation

public extension CGSize {
    func multiplied(by factor: CGFloat) -> CGSize {
        return CGSize(width: self.width * factor, height: self.height * factor)
    }
    
    var rounded: CGSize {
        CGSize(width: self.width.rounded(), height: self.height.rounded())
    }
}
