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
                locale: Locale = .current,
                timeZone: TimeZone? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.timeZone = timeZone
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        dateFormatter.formattingContext = formattingContext
        return dateFormatter.string(from: self)
    }

    /// Date only in short format (02/01/2026).
    func dateOnlyString() -> String {
        return string(dateStyle: .short, timeStyle: .none)
    }
    
    /// Date and time in short format (02/01/2026, 17:44).
    func timeString() -> String {
        return string(dateStyle: .short, timeStyle: .short)
    }
    
    /// Date in short and time in medium format (02/01/2026, 17:44:01).
    func timeAndSecondsString() -> String {
        return string(dateStyle: .short, timeStyle: .medium)
    }
    
    // MARK: - Manipulating
    
    func floorToMinutes() -> Date? {
        let components = Calendar.current.dateComponents([.calendar, .era, .year, .month, .day, .hour, .minute, .timeZone], from: self)
        return components.date
    }
}
