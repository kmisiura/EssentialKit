import CryptoKit
import Foundation
import OSLogger

public struct Crypto {
    static public func sha1(_ data: Data) -> String {
        let digest = Insecure.SHA1.hash(data: data)
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
    
    static public func sha1(_ string: String) -> String {
        let data = Data(string.utf8)
        return sha1(data)
    }
    
    static public func md5(_ data: Data) -> String {
        let digest = Insecure.MD5.hash(data: data)
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
    
    static public func md5(_ string: String) -> String {
        let data = Data(string.utf8)
        return md5(data)
    }
    
    static public func sha256(_ data: Data) -> String {
        let digest = SHA256.hash(data: data)
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
    
    static public func sha256(_ string: String) -> String {
        let data = Data(string.utf8)
        return sha256(data)
    }
}
