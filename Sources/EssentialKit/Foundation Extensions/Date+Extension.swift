//
//  Date+Extension.swift
//  EssentialKit
//
//  Created by Karolis Misiūra on 28/10/2024.
//

import Foundation

public extension Date {
    
    // MARK: - Converting into string
    
    func string(dateStyle: DateFormatter.Style = .medium,
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
    
    func dateOnlyString() -> String {
        return string(dateStyle: .short, timeStyle: .none)
    }
    
    func timeString() -> String {
        return string(dateStyle: .short, timeStyle: .short)
    }
    
    func timeAndSecondsString() -> String {
        return string(dateStyle: .short, timeStyle: .medium)
    }
    
    // MARK: - Manipulating
    
    func floorToMinutes() -> Date? {
        let components = Calendar.current.dateComponents([.calendar, .era, .year, .month, .day, .hour, .minute, .timeZone], from: self)
        return components.date
    }
    
    // MARK: - Calculating
    
    static func getDuration(from: Date, to: Date) -> TimeInterval {
        return  to.timeIntervalSinceReferenceDate - from.timeIntervalSinceReferenceDate
    }
    
    static func getDurationInMinutes(from: Date, to: Date) -> Int {
        let seconds = Int(to.timeIntervalSince1970 - from.timeIntervalSince1970)
        return seconds / 60
    }
}
