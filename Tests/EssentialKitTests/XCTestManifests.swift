import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(EssentialKitTests.allTests),
        testCase(StringExtensionsTests.allTests),
        testCase(PublisherExtensionTests.allTests),
        testCase(URLExtensionsTests.allTests),
        testCase(ArrayExtensionsTests.allTests),
        testCase(ColdStorageTests.allTests),
        testCase(CryptoTests.allTests),
        testCase(ErrorTests.allTests),
        testCase(KeychainTests.allTests),
        testCase(TimeZoneExtensionTests.allTests),
    ]
}
#endif
