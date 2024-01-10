import XCTest
@testable import EssentialKit

final class PublisherExtensionTests: XCTestCase {
    
    func testFirstPathComponent() {
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)

        let numberOfRetries = 2
        let delayBeforeRetry = 4.0
        
        let retryExpectation = expectation(description: "Waiting to retry")
        retryExpectation.expectedFulfillmentCount = numberOfRetries + 1
        
        let completionExpectation = expectation(description: "Waiting to complete")
        
        var lastTry: TimeInterval? = nil
        
        MockURLProtocol.requestHandler = { _ in
            let now = Date().timeIntervalSinceReferenceDate
            if let lastTry = lastTry { XCTAssertTrue(abs(now - lastTry) - delayBeforeRetry <= 1.0) }
            lastTry = now
            retryExpectation.fulfill()
        }
        
        let url = URL(string: "https://testp2984y4p2983hyfp2983hpfu23hfp2ugh3.net")!
        let publisher = session.dataTaskPublisher(for: url)
        var cancelable: Any? = nil
        
        cancelable = publisher.retryWithDelay(count: numberOfRetries, delay: delayBeforeRetry).sink { completion in
            completionExpectation.fulfill()
        } receiveValue: { value in }
        
        wait(for: [retryExpectation, completionExpectation], timeout: delayBeforeRetry * Double(numberOfRetries + 1))
        cancelable = nil
    }
    
    static var allTests = [
        ("testFirstPathComponent", testFirstPathComponent),
    ]
}
