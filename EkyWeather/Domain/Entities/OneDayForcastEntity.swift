//
//  OneDayForcastEntity.swift
//  EkyWeather
//
//  Created by Eky on 30/01/25.
//

struct OneDayForecastEntity: Equatable {
    let latitude, longitude: Double?
    let hourlyForecast: [HourlyForecastEntity]?
    
    static func fromResponseModel(_ model: OpenMateoResponseModel) -> OneDayForecastEntity {
        
        let time = model.hourly?.time ?? []
        let temperature2M = model.hourly?.temperature2M ?? []
        let relativeHumidity2M = model.hourly?.relativeHumidity2M ?? []
        let apparentTemperature = model.hourly?.apparentTemperature ?? []
        let weatherCode = model.hourly?.weatherCode ?? []
        
        var hourlyArray: [HourlyForecastEntity] = []
        for i in 0..<time.count {
            let entity = HourlyForecastEntity(
                time: time[i],
                temperature2M: temperature2M[i],
                relativeHumidity2M: relativeHumidity2M[i],
                apparentTemperature: apparentTemperature[i],
                weatherCode: weatherCode[i]
            )
            hourlyArray.append(entity)
        }
        return OneDayForecastEntity(
            latitude: model.latitude, longitude: model.longitude, hourlyForecast: hourlyArray
        )
    }

}

struct HourlyForecastEntity: Equatable {
    let time: String?
    let temperature2M: Double?
    let relativeHumidity2M: Int?
    let apparentTemperature: Double?
    let weatherCode: Int?
}
