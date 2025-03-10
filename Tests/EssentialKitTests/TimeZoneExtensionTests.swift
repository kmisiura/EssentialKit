//
//  TimeZoneExtensionTests.swift
//  EssentialKit
//
//  Created by Karolis Misiūra on 10/03/2025.
//

import XCTest
@testable import EssentialKit

private extension TimeZone {
    init?(hours: Int, minutes: Int) {
        self.init(secondsFromGMT: (hours * 60 + minutes) * 60)
    }
}

final class TimeZoneExtensionTests: XCTestCase {
    func testISO8601() {
        // valid time zones
        XCTAssertEqual(TimeZone(iso8601: "2019-10-21T08:40:45+01"), TimeZone(hours: 1, minutes: 0))
        XCTAssertEqual(TimeZone(iso8601: "2019-10-21T08:40:45+01:00"), TimeZone(hours: 1, minutes: 0))
        XCTAssertEqual(TimeZone(iso8601: "2019-10-21T08:40:45+12:34"), TimeZone(hours: 12, minutes: 34))
        XCTAssertEqual(TimeZone(iso8601: "2019-10-21T08:40:45-12:34"), TimeZone(hours: -12, minutes: 34))

        // no time zone
        XCTAssertNil(TimeZone(iso8601: "2019-10-21"))
        XCTAssertNil(TimeZone(iso8601: "2019-10-21T08:40:45.24"))
        
        // invalid
        XCTAssertNil(TimeZone(iso8601: "2019-10-21T08:40:45.24±01"))
    }
    
    static var allTests = [
        ("testISO8601", testISO8601),
    ]
}
