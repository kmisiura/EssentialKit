import XCTest
@testable import EssentialKit

final class PublisherExtensionTests: XCTestCase {
    
    func testRetryWithDelay() {
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        
        let numberOfRetries = 2
        let delayBase = 2.0
        
        let retryExpectation = expectation(description: "Waiting to retry")
        retryExpectation.expectedFulfillmentCount = numberOfRetries + 1
        
        let completionExpectation = expectation(description: "Waiting to complete")
        
        var lastTry: TimeInterval? = nil
        var retryCount = 0
        
        MockURLProtocol.requestHandler = { _ in
            let now = Date().timeIntervalSinceReferenceDate
            if let lastTry = lastTry {
                // retryCount is the current attempt index (1-based), matching currentAttempt in implementation
                let expectedDelay = pow(delayBase, Double(retryCount))
                let timeBetweenRetry = now - lastTry - expectedDelay
                XCTAssertLessThan(timeBetweenRetry, 2.0)
                XCTAssertGreaterThan(timeBetweenRetry, -0.5)
            }
            lastTry = now
            retryCount += 1
            retryExpectation.fulfill()
        }
        
        let url = URL(string: "https://testp2984y4p2983hyfp2983hpfu23hfp2ugh3.net")!
        let publisher = session.dataTaskPublisher(for: url)
        var cancelable: Any? = nil
        
        cancelable = publisher.retryWithDelay(count: numberOfRetries, delay: delayBase).sink { completion in
            completionExpectation.fulfill()
        } receiveValue: { value in }
        
        // Sum of all exponential delays: delay^1 + delay^2 + ... + delay^numberOfRetries
        let totalDelay = (1...numberOfRetries).reduce(0.0) { $0 + pow(delayBase, Double($1)) }
        wait(for: [retryExpectation, completionExpectation], timeout: totalDelay + 5.0)
        cancelable = nil
    }
    
    static var allTests = [
        ("testRetryWithDelay", testRetryWithDelay),
    ]
}
