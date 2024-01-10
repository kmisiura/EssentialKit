import Foundation
import OSLogger
import Security

public class Keychain {
    
    public enum Error: Swift.Error {
        case failedToDecodeResult
        case itemNotFound(error: Swift.Error?)
        case securityError(code: Int, description: String?)
    }
    
    private static func query(service: String,
                              key: String,
                              keyClass: String? = kSecClassGenericPassword as String,
                              synchronizable: Bool? =  false,
                              extraAttributes: [String: AnyObject] = [:]) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecAttrService as String] = service as AnyObject
        query[kSecAttrAccount as String] = key as AnyObject
        if let keyClass = keyClass {
            query[kSecClass as String] = keyClass as AnyObject
        }
        if let synchronizable = synchronizable {
            query[kSecAttrSynchronizable as String] = synchronizable ? kCFBooleanTrue : kCFBooleanFalse
        }
        
        query.merge(extraAttributes) { (_, new) in new }
        
        return query
    }
    
    public static func delete(key: String,
                              service: String,
                              keyClass: String = kSecClassGenericPassword as String,
                              extraAttributes: [String: AnyObject] = [:]) throws {
        
        let query = Keychain.query(service: service,
                                   key: key,
                                   keyClass: keyClass,
                                   synchronizable: nil,
                                   extraAttributes: extraAttributes)
        
        let result = SecItemDelete(query as CFDictionary)
        guard result != errSecItemNotFound else { return }
        if let error = result.info {
            throw Keychain.Error.securityError(code: error.code, description: error.description)
        }
    }
    
    public static func store(value: Data,
                             key: String,
                             service: String,
                             keyClass: String = kSecClassGenericPassword as String,
                             synchronizable: Bool? =  false,
                             extraAttributes: [String: AnyObject] = [:]) throws {
        
        let mergedExtraAttributes = extraAttributes.merging([kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock],
                                                      uniquingKeysWith: { (old, _) in old })
        
        var query = Keychain.query(service: service,
                                   key: key,
                                   keyClass: keyClass,
                                   synchronizable: synchronizable,
                                   extraAttributes: mergedExtraAttributes)
        
        try delete(key: key, service: service)
        
        query[kSecValueData as String] = value as AnyObject?
        if let error = SecItemAdd(query as CFDictionary, nil).info {
            throw Keychain.Error.securityError(code: error.code, description: error.description)
        }
    }
    
    public static func retrieveValue(for key: String,
                                     service: String,
                                     keyClass: String = kSecClassGenericPassword as String,
                                     synchronizable: Bool? = false,
                                     extraAttributes: [String: AnyObject] = [:]) throws -> AnyObject? {
        
        let mergedExtraAttributes = extraAttributes.merging([kSecMatchLimit as String: kSecMatchLimitOne,
                                                             kSecReturnData as String: kCFBooleanTrue],
                                                            uniquingKeysWith: { (old, _) in old })
        
        let query = Keychain.query(service: service,
                                   key: key,
                                   keyClass: keyClass,
                                   synchronizable: synchronizable,
                                   extraAttributes: mergedExtraAttributes)
        
        var queryResult: AnyObject?
        let result = SecItemCopyMatching(query as CFDictionary, &queryResult)
        guard result != errSecItemNotFound else { return nil }
        if let error = result.info {
            throw Keychain.Error.securityError(code: error.code, description: error.description)
        }
        
        return queryResult
    }
    
    public static func updateValue(value: Data?,
                                   for key: String,
                                   service: String,
                                   keyClass: String = kSecClassGenericPassword as String,
                                   synchronizable: Bool? = false,
                                   extraAttributes: [String: AnyObject] = [:],
                                   extraAttributesToUpdate: [String: AnyObject] = [:]) throws {
        
        let query = Keychain.query(service: service,
                                   key: key,
                                   keyClass: keyClass,
                                   synchronizable: synchronizable,
                                   extraAttributes: extraAttributes)
        
        var attributesToUpdate = extraAttributesToUpdate
        if let value = value { attributesToUpdate[kSecValueData as String] = value as AnyObject? }
        let result = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        
        let secErr: Error?
        if let error = result.info {
            secErr = Keychain.Error.securityError(code: error.code, description: error.description)
        } else { secErr = nil }
        
        if result == errSecItemNotFound {
            throw Keychain.Error.itemNotFound(error: secErr)
        } else if let secErr = secErr {
            throw secErr
        }
    }
}
