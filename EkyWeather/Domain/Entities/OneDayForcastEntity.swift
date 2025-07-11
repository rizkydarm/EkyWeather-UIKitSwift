//
//  OneDayForcastEntity.swift
//  EkyWeather
//
//  Created by Eky on 30/01/25.
//

import Foundation

struct OneDayForecastEntity: Equatable {
    let latitude, longitude: Double?
    let hourlyForecast: [HourlyForecastEntity]?
    
    static func fromResponseModel(_ model: OpenMateoResponseModel) -> OneDayForecastEntity {
        
        let time = model.hourly?.time ?? []
        let temperature2M = model.hourly?.temperature2M ?? []
        let relativeHumidity2M = model.hourly?.relativeHumidity2M ?? []
        let apparentTemperature = model.hourly?.apparentTemperature ?? []
        let weatherCode = model.hourly?.weatherCode ?? []
        
        let len = min(time.count, temperature2M.count, relativeHumidity2M.count, apparentTemperature.count, weatherCode.count)
        
        var hourlyArray: [HourlyForecastEntity] = []
        for index in 0..<len {
            let entity = HourlyForecastEntity(
                time: Date.tryParse(string: time[index], dateFormats: ["yyyy-MM-dd'T'HH:mm"]),
                temperature2M: temperature2M[index],
                relativeHumidity2M: relativeHumidity2M[index],
                apparentTemperature: apparentTemperature[index],
                weatherCondition:  WeatherCondition.init(rawValue: weatherCode[index]),
                temperatureUnit: model.hourlyUnits?.temperature2M
            )
            hourlyArray.append(entity)
        }
        return OneDayForecastEntity(
            latitude: model.latitude,
            longitude: model.longitude,
            hourlyForecast: hourlyArray
        )
    }

}

struct HourlyForecastEntity: Equatable {
    let time: Date?
    let temperature2M: Double?
    let relativeHumidity2M: Int?
    let apparentTemperature: Double?
    let weatherCondition: WeatherCondition?
    let temperatureUnit: String?
}
