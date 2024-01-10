import XCTest
@testable import EssentialKit

final class EssentialKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(EssentialKit().text, "EssentialKit")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
