import XCTest
@testable import EssentialKit

final class StringExtensionsTests: XCTestCase {
    
    func testFirstPathComponent() {
        var path = "/"
        XCTAssertEqual(path.firstPathComponent, nil)
        
        path = ""
        XCTAssertEqual(path.firstPathComponent, nil)
        
        path = "/A/"
        XCTAssertEqual(path.firstPathComponent, "A")
        
        path = "A/"
        XCTAssertEqual(path.firstPathComponent, "A")
        
        path = "/A"
        XCTAssertEqual(path.firstPathComponent, "A")
        
        path = "/A/B/"
        XCTAssertEqual(path.firstPathComponent, "A")
        
        path = "/A/B"
        XCTAssertEqual(path.firstPathComponent, "A")
        
        path = "A/B"
        XCTAssertEqual(path.firstPathComponent, "A")
        
        path = "A"
        XCTAssertEqual(path.firstPathComponent, "A")
    }
    
    func testLastPathComponent() {
        var path = "/"
        XCTAssertEqual(path.lastPathComponent, nil)
        
        path = ""
        XCTAssertEqual(path.lastPathComponent, nil)
        
        path = "/A/"
        XCTAssertEqual(path.lastPathComponent, "A")
        
        path = "A/"
        XCTAssertEqual(path.lastPathComponent, "A")
        
        path = "/A"
        XCTAssertEqual(path.lastPathComponent, "A")
        
        path = "/A/B/"
        XCTAssertEqual(path.lastPathComponent, "B")
        
        path = "/A/B"
        XCTAssertEqual(path.lastPathComponent, "B")
        
        path = "A/B"
        XCTAssertEqual(path.lastPathComponent, "B")
        
        path = "B"
        XCTAssertEqual(path.lastPathComponent, "B")
    }
    
    static var allTests = [
        ("testFirstPathComponent", testFirstPathComponent),
        ("testLastPathComponent", testLastPathComponent),
    ]
}
