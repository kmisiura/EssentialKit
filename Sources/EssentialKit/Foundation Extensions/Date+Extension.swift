//
//  Date+Extension.swift
//  EssentialKit
//
//  Created by Karolis Misiūra on 28/10/2024.
//

import Foundation

public extension Date {
    
    // MARK: - Converting into string
    
    public func string(dateStyle: DateFormatter.Style = .medium,
                timeStyle: DateFormatter.Style = .medium,
                formattingContext: Formatter.Context = .standalone,
                locale: Locale = .current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        dateFormatter.formattingContext = formattingContext
        return dateFormatter.string(from: self)
    }
    
    public func dateOnlyString() -> String {
        return string(dateStyle: .short, timeStyle: .none)
    }
    
    public func timeString() -> String {
        return string(dateStyle: .short, timeStyle: .short)
    }
    
    public func timeAndSecondsString() -> String {
        return string(dateStyle: .short, timeStyle: .medium)
    }
    
    // MARK: - Manipulating
    
    public func roundedToSeconds() -> Date? {
        let cal = Calendar.current
        return cal.date(bySetting: .second, value: 0, of: self)
    }
    
    // MARK: - Calculating
    
    public static func getDuration(from: Date, to: Date) -> TimeInterval {
        return  to.timeIntervalSinceReferenceDate - from.timeIntervalSinceReferenceDate
    }
    
    public static func getDurationInMinutes(from: Date, to: Date) -> Int {
        let seconds = Int(to.timeIntervalSince1970 - from.timeIntervalSince1970)
        return seconds / 60
    }
}
