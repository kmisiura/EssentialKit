import XCTest
import System
@testable import EssentialKit

final class KeychainTests: XCTestCase {
    
    let testServiceKey = "KeychainTestsService"
    let testKey = "KeychainTestsValueKey"
    let testValue = "This Is Test Secret Value"
    
    override func tearDownWithError() throws {
        try deleteAll()
    }
    
    private func createItem() throws {
        let query: [String: AnyObject] = [kSecAttrService as String: testServiceKey as AnyObject,
                                          kSecAttrAccount as String: testKey as AnyObject,
                                          kSecClass as String: kSecClassGenericPassword as AnyObject,
                                          kSecMatchLimit as String: kSecMatchLimitAll,
                                          kSecValueData as String: testValue.data(using: .ascii)! as AnyObject]
        if let error = SecItemAdd(query as CFDictionary, nil).info {
            throw Keychain.Error.securityError(code: error.code, description: error.description)
        }
    }
    
    private func numberOfItems() throws -> Int {
        let query: [String: AnyObject] = [kSecAttrService as String: testServiceKey as AnyObject,
                                          kSecAttrAccount as String: testKey as AnyObject,
                                          kSecClass as String: kSecClassGenericPassword as AnyObject,
                                          kSecMatchLimit as String: kSecMatchLimitAll]
        
        var queryResult: AnyObject?
        let result = SecItemCopyMatching(query as CFDictionary, &queryResult)
        guard result != errSecItemNotFound else { return 0 }
        if let error = result.info {
            throw Keychain.Error.securityError(code: error.code, description: error.description)
        }
        guard let array = queryResult as? [AnyObject] else {
            throw Keychain.Error.failedToDecodeResult
        }
        
        return array.count
    }
    
    private func deleteAll() throws {
        let query: [String: AnyObject] = [kSecAttrService as String: testServiceKey as AnyObject,
                                          kSecAttrAccount as String: testKey as AnyObject,
                                          kSecClass as String: kSecClassGenericPassword as AnyObject,
                                          kSecAttrSynchronizable as String: kCFBooleanFalse]
        
        let result = SecItemDelete(query as CFDictionary)
        guard result != errSecItemNotFound else { return }
        if let error = result.info {
            throw Keychain.Error.securityError(code: error.code, description: error.description)
        }
    }
    
    func testDelete() {
        XCTAssertNoThrow(try createItem())
        XCTAssertNoThrow(try Keychain.delete(key: testKey, service: testServiceKey))
        var number: Int = -1
        XCTAssertNoThrow(number = try numberOfItems())
        XCTAssertEqual(number, 0)
    }
    
    func testStore() {
        // Test write on clean
        XCTAssertNoThrow(try Keychain.store(value: testValue.data(using: .ascii)!, key: testKey, service: testServiceKey))
        var number: Int = 0
        XCTAssertNoThrow(number = try numberOfItems())
        XCTAssertEqual(number, 1)
        
        // Testing overwrite
        XCTAssertNoThrow(try Keychain.store(value: testValue.data(using: .ascii)!, key: testKey, service: testServiceKey))
        number = 0
        XCTAssertNoThrow(number = try numberOfItems())
        XCTAssertEqual(number, 1)
    }
    
    func testRetrieve() {
        XCTAssertNoThrow(try createItem())
        
        var value: Data? = nil
        XCTAssertNoThrow(value = try Keychain.retrieveValue(for: testKey, service: testServiceKey) as? Data)
        XCTAssertNotNil(value)
        XCTAssertEqual(String(data: value ?? Data(), encoding: .ascii), testValue)
    }
    
    static var allTests = [
        ("testStore", testStore),
    ]
}
