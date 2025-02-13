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
        for i in 0..<timeArray.count {
            let entity = DailyForecastEntity(
                time: timeArray[i],
                weatherCondition: WeatherCondition.init(rawValue: weatherCodeArray[i]),
                temperature2MMax: temperatureMaxArray[i],
                temperature2MMin: temperatureMinArray[i]
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
