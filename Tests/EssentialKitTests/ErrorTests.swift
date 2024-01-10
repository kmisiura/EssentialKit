import XCTest
import System
@testable import EssentialKit

final class ErrorTests: XCTestCase {
    
    enum Test: Error {
        case nsErrorCopy(description: String, reason: String, code: Int, error: Error?)
    }
    
    func testEnumErrorParse () {
        XCTAssertEqual(noErr, errSecSuccess)
        
        let error = Test.nsErrorCopy(description: "description", reason: "reason", code: 666, error: nil)
        let nsError = error.nsError
        XCTAssertEqual(nsError.domain, "Test")
        XCTAssertEqual(nsError.localizedDescription, "description")
        XCTAssertEqual(nsError.localizedFailureReason, "reason")
        XCTAssertEqual(nsError.code, 666)
    }
    
    static var allTests = [
        ("testEnumErrorParse", testEnumErrorParse),
    ]
}
