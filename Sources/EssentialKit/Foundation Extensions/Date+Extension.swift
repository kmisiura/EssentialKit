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
}
