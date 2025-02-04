//
//  OpenMateoResponseModel.swift
//  EkyWeather
//
//  Created by Eky on 30/01/25.
//

import Foundation

// MARK: - OpenMateoResponseModel
struct OpenMateoResponseModel: Codable {
    let latitude, longitude, generationtimeMS: Double?
    let utcOffsetSeconds: Int?
    let timezone, timezoneAbbreviation: String?
    let elevation: Int?
    let currentUnits: CurrentUnits?
    let current: Current?
    let hourlyUnits: HourlyUnits?
    let hourly: Hourly?
    let dailyUnits: DailyUnits?
    let daily: Daily?

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case generationtimeMS = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
        case currentUnits = "current_units"
        case current
        case hourlyUnits = "hourly_units"
        case hourly
        case dailyUnits = "daily_units"
        case daily
    }
}

// MARK: - Current
internal struct Current: Codable {
    let time: String?
    let interval: Int?
    let temperature2M: Double?
    let relativeHumidity2M, isDay, weatherCode: Int?

    enum CodingKeys: String, CodingKey {
        case time, interval
        case temperature2M = "temperature_2m"
        case relativeHumidity2M = "relative_humidity_2m"
        case isDay = "is_day"
        case weatherCode = "weather_code"
    }
}

// MARK: - CurrentUnits
internal struct CurrentUnits: Codable {
    let time, interval, temperature2M, relativeHumidity2M: String?
    let isDay, weatherCode: String?

    enum CodingKeys: String, CodingKey {
        case time, interval
        case temperature2M = "temperature_2m"
        case relativeHumidity2M = "relative_humidity_2m"
        case isDay = "is_day"
        case weatherCode = "weather_code"
    }
}

// MARK: - Daily
internal struct Daily: Codable {
    let time: [String]?
    let weatherCode: [Int]?
    let temperature2MMax, temperature2MMin: [Double]?

    enum CodingKeys: String, CodingKey {
        case time
        case weatherCode = "weather_code"
        case temperature2MMax = "temperature_2m_max"
        case temperature2MMin = "temperature_2m_min"
    }
}

// MARK: - DailyUnits
internal struct DailyUnits: Codable {
    let time, weatherCode, temperature2MMax, temperature2MMin: String?

    enum CodingKeys: String, CodingKey {
        case time
        case weatherCode = "weather_code"
        case temperature2MMax = "temperature_2m_max"
        case temperature2MMin = "temperature_2m_min"
    }
}

// MARK: - Hourly
internal struct Hourly: Codable {
    let time: [String]?
    let temperature2M: [Double]?
    let relativeHumidity2M: [Int]?
    let apparentTemperature: [Double]?
    let weatherCode: [Int]?

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case relativeHumidity2M = "relative_humidity_2m"
        case apparentTemperature = "apparent_temperature"
        case weatherCode = "weather_code"
    }
}

// MARK: - HourlyUnits
internal struct HourlyUnits: Codable {
    let time, temperature2M, relativeHumidity2M, apparentTemperature: String?
    let weatherCode: String?

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case relativeHumidity2M = "relative_humidity_2m"
        case apparentTemperature = "apparent_temperature"
        case weatherCode = "weather_code"
    }
}
