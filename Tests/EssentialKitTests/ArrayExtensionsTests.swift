import XCTest
@testable import EssentialKit

final class ArrayExtensionsTests: XCTestCase {
    
    func testRemoveDuplicates () {
        var array = [1,2,4,3,4,5,4,1]
        
        let removedDuplicates = array.removingDuplicates()
        
        let duplicates = array.removeDuplicates()
        XCTAssertEqual(duplicates, [4,4,1])
        XCTAssertEqual(array, [1,2,4,3,5])
        XCTAssertEqual(array, removedDuplicates)
    }
    
    static var allTests = [
        ("testRemoveDuplicates", testRemoveDuplicates),
    ]
}
