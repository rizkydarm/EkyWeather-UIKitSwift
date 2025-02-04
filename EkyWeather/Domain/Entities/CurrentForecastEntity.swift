//
//  CurrentForecastEntity.swift
//  EkyWeather
//
//  Created by Eky on 30/01/25.
//

struct CurrentForecastEntity: Equatable {
    let latitude, longitude: Double?
    let time: String?
    let interval: Int?
    let temperature2M: Double?
    let relativeHumidity2M, isDay, weatherCode: Int?
    
    static func fromResponseModel(_ model: OpenMateoResponseModel) -> CurrentForecastEntity {
        return CurrentForecastEntity(
            latitude: model.latitude,
            longitude: model.longitude,
            time: model.current?.time,
            interval: model.current?.interval,
            temperature2M: model.current?.temperature2M,
            relativeHumidity2M: model.current?.relativeHumidity2M,
            isDay: model.current?.isDay,
            weatherCode: model.current?.weatherCode
        )
    }
}
