import XCTest
@testable import EssentialKit

final class ColdStorageTests: XCTestCase {
    
    var storage: ColdStorage!
    
    override func setUp() {
        storage = ColdStorage(name: UUID().uuidString)
    }
    
    override func tearDown() {
        storage.destroy().sink(receiveCompletion: { _ in },
                               receiveValue: {_ in })
    }
    
    func testStringWriteRead() {
        let testWriteData = "TestWriteString"
        let writeExpectation = XCTestExpectation(description: "Writing String")
        let readExpectation = XCTestExpectation(description: "Reading String")
        readExpectation.expectedFulfillmentCount = 2
        
        var wop = storage.writeString(testWriteData, key: "TestKey")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertNotNil(error)
                } else {
                    XCTAssertTrue(true)
                }
                writeExpectation.fulfill()
            }, receiveValue: { _ in })
        
        var rop = storage.readString("TestKey")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertNotNil(error)
                } else {
                    XCTAssertTrue(true)
                }
                readExpectation.fulfill()
            }, receiveValue: { string in
                XCTAssertEqual(string, testWriteData)
                readExpectation.fulfill()
            })
        
        wait(for: [writeExpectation, readExpectation], timeout: 1.0)
    }
    
    static var allTests = [
        ("testStringWriteRead", testStringWriteRead),
    ]
}
