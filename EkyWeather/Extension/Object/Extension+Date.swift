//
//  Extension+Date.swift
//  EkyWeather
//
//  Created by Eky on 19/01/25.
//

import Foundation

extension Date {

    init(day: Int, month: Int, year: Int) {
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month, day: day)
        self = calendar.date(from: components)!
    }

    // Get tomorrow's date
    func getTomorrow() -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    // Get yesterday's date
    func getYesterday() -> Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }

    // Get the name of today's day
    func getDayNameToday() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"  // Full weekday name
        return formatter.string(from: self)
    }

    // Get the name of the day for a specific date
    func getDayName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"  // Full weekday name
        return formatter.string(from: date)
    }
    
    // Get the name of the day for a specific date
    func getStringFormattedDate(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    // Compare two dates and return true if self is older than the provided date
    func isOlderThan(_ date: Date) -> Bool {
        return self.compare(date) == .orderedAscending
    }

    static func from(day: Int, month: Int, year: Int) -> Date? {

        let calendar = Calendar.current

        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day

        if let date = calendar.date(from: dateComponents) {
            return date
        } else {
            return nil
        }
    }

    static func tryParse(string: String, dateFormats: [String]? = nil) -> Date? {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")  // To ensure consistent parsing regardless of device settings

        // Default date formats if none are provided
        let formats: [String]
        if let providedFormats = dateFormats {
            formats = providedFormats
        } else {
            formats = [
                "yyyy-MM-dd",  // Example: "2025-01-15"
                "dd-MM-yyyy",  // Example: "15-01-2025"
                "MM/dd/yyyy",  // Example: "01/15/2025"
                "yyyy/MM/dd",  // Example: "2025/01/15"
                "dd/MM/yyyy",  // Example: "15/01/2025"
                "MM-dd-yyyy",  // Example: "01-15-2025"
            ]
        }

        // Try each format until one works
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: string) {
                return date
            }
        }

        // If no format worked, return nil
        return nil
    }

}
