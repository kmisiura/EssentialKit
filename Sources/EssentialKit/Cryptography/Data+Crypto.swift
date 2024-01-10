import Foundation

public extension Data {
    var sha1: String {
        return Crypto.sha1(self)
    }
    
    var md5: String {
        return Crypto.md5(self)
    }
    
    var sha256: String {
        return Crypto.sha256(self)
    }
}
