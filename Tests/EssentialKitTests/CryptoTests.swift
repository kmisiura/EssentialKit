import Foundation
@testable import EssentialKit
import XCTest

final class CryptoTests: XCTestCase {
    func testMD5() {
        let string = "The quick brown fox jumps over the lazy dog"
        let expectedResult = "9e107d9d372bb6826bd81d3542a419d6"
        
        XCTAssertEqual(Crypto.md5(string), expectedResult)
        XCTAssertEqual(string.md5, expectedResult)
    }
    
    func testSha1() {
        let string = "The quick brown fox jumps over the lazy dog"
        let expectedResult = "2fd4e1c67a2d28fced849ee1bb76e7391b93eb12"
        
        XCTAssertEqual(Crypto.sha1(string), expectedResult)
        XCTAssertEqual(string.sha1, expectedResult)
    }
    
    func testSha256() {
        let string = "The quick brown fox jumps over the lazy dog"
        let expectedResult = "d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592"
        
        XCTAssertEqual(Crypto.sha256(string), expectedResult)
        XCTAssertEqual(string.sha256, expectedResult)
    }
}

