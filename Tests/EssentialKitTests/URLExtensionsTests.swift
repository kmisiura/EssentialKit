import XCTest
@testable import EssentialKit

final class URLExtensionsTests: XCTestCase {
    
    func testAppendQueryItems() {
        var url = URL(string: "https://subdomain.domain.net/api/service/v4")!
        url = url.appendingQueryItems(["itemOne": "1"])!
        XCTAssertEqual(url.absoluteString, "https://subdomain.domain.net/api/service/v4?itemOne=1")
        
        url = URL(string: "https://subdomain.domain.net/api/service/v4/")!
        url = url.appendingQueryItems(["itemOne": "1"])!
        XCTAssertEqual(url.absoluteString, "https://subdomain.domain.net/api/service/v4/?itemOne=1")
        
        url = URL(string: "https://subdomain.domain.net/api/service/v4?oldItem=old")!
        url = url.appendingQueryItems(["itemOne": "1"])!
        XCTAssertEqual(url.absoluteString, "https://subdomain.domain.net/api/service/v4?oldItem=old&itemOne=1")
    }
    
    func testMutatingAppendQueryItems() {
        var url = URL(string: "https://subdomain.domain.net/api/service/v4")!
        url.appendQueryItems(["itemOne": "1"])
        XCTAssertEqual(url.absoluteString, "https://subdomain.domain.net/api/service/v4?itemOne=1")
        
        url = URL(string: "https://subdomain.domain.net/api/service/v4/")!
        url.appendQueryItems(["itemOne": "1"])
        XCTAssertEqual(url.absoluteString, "https://subdomain.domain.net/api/service/v4/?itemOne=1")
        
        url = URL(string: "https://subdomain.domain.net/api/service/v4?oldItem=old")!
        url.appendQueryItems(["itemOne": "1"])
        XCTAssertEqual(url.absoluteString, "https://subdomain.domain.net/api/service/v4?oldItem=old&itemOne=1")
    }
    
    static var allTests = [
        ("testMutatingAppendQueryItems", testMutatingAppendQueryItems),
        ("testAppendQueryItems", testAppendQueryItems),
    ]
}
