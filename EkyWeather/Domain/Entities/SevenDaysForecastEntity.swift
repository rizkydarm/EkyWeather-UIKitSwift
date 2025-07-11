//
//  CurrentForecastEntity.swift
//  EkyWeather
//
//  Created by Eky on 30/01/25.
//

struct SevenDaysForecastEntity: Equatable {
    let latitude, longitude: Double?
    let dailyForecast: [DailyForecastEntity]?
    
    static func fromResponseModel(_ model: OpenMateoResponseModel) -> SevenDaysForecastEntity {
        
        let timeArray = model.daily?.time ?? []
        let temperatureMaxArray = model.daily?.temperature2MMax ?? []
        let temperatureMinArray = model.daily?.temperature2MMin ?? []
        let weatherCodeArray = model.daily?.weatherCode ?? []
        
        var dailyArray: [DailyForecastEntity] = []
        for index in 0..<timeArray.count {
            let entity = DailyForecastEntity(
                time: timeArray[index],
                weatherCondition: WeatherCondition.init(rawValue: weatherCodeArray[index]),
                temperature2MMax: temperatureMaxArray[index],
                temperature2MMin: temperatureMinArray[index]
            )
            dailyArray.append(entity)
        }
        return SevenDaysForecastEntity(
            latitude: model.latitude, longitude: model.longitude, dailyForecast: dailyArray
        )
    }
}

struct DailyForecastEntity: Equatable {
    let time: String?
    let weatherCondition: WeatherCondition?
    let temperature2MMax, temperature2MMin: Double?
}
