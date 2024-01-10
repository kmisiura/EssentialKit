import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(EssentialKitTests.allTests),
        testCase(StringExtensionsTests.allTests),
        testCase(PublisherExtensionTests.allTests),
        testCase(URLExtensionsTests.allTests),
        testCase(ArrayExtensionsTests.allTests),
    ]
}
#endif
