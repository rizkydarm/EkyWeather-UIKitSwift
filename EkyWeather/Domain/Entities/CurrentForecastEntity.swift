//
//  CurrentForecastEntity.swift
//  EkyWeather
//
//  Created by Eky on 30/01/25.
//

enum WeatherCondition: Int {
    case clearSky = 0
    case mainlyClear = 1
    case partlyCloudy = 2
    case overcast = 3
    case fog = 45
    case depositingRimeFog = 48
    case lightDrizzle = 51
    case moderateDrizzle = 53
    case denseDrizzle = 55
    case lightFreezingDrizzle = 56
    case denseFreezingDrizzle = 57
    case slightRain = 61
    case moderateRain = 63
    case heavyRain = 65
    case lightFreezingRain = 66
    case heavyFreezingRain = 67
    case slightSnowFall = 71
    case moderateSnowFall = 73
    case heavySnowFall = 75
    case snowGrains = 77
    case slightRainShowers = 80
    case moderateRainShowers = 81
    case violentRainShowers = 82
    case slightSnowShowers = 85
    case heavySnowShowers = 86
    case slightThunderstorm = 95
    case thunderstormWithHail = 96
    case heavyThunderstormWithHail = 99

    var description: String {
        switch self {
        case .clearSky:
            return "Clear sky"
        case .mainlyClear:
            return "Mainly clear"
        case .partlyCloudy:
            return "Partly cloudy"
        case .overcast:
            return "Overcast"
        case .fog:
            return "Fog"
        case .depositingRimeFog:
            return "Depositing rime fog"
        case .lightDrizzle:
            return "Light drizzle"
        case .moderateDrizzle:
            return "Moderate drizzle"
        case .denseDrizzle:
            return "Dense drizzle"
        case .lightFreezingDrizzle:
            return "Light freezing drizzle"
        case .denseFreezingDrizzle:
            return "Dense freezing drizzle"
        case .slightRain:
            return "Slight rain"
        case .moderateRain:
            return "Moderate rain"
        case .heavyRain:
            return "Heavy rain"
        case .lightFreezingRain:
            return "Light freezing rain"
        case .heavyFreezingRain:
            return "Heavy freezing rain"
        case .slightSnowFall:
            return "Slight snow fall"
        case .moderateSnowFall:
            return "Moderate snow fall"
        case .heavySnowFall:
            return "Heavy snow fall"
        case .snowGrains:
            return "Snow grains"
        case .slightRainShowers:
            return "Slight rain showers"
        case .moderateRainShowers:
            return "Moderate rain showers"
        case .violentRainShowers:
            return "Violent rain showers"
        case .slightSnowShowers:
            return "Slight snow showers"
        case .heavySnowShowers:
            return "Heavy snow showers"
        case .slightThunderstorm:
            return "Slight thunderstorm"
        case .thunderstormWithHail:
            return "Thunderstorm with hail"
        case .heavyThunderstormWithHail:
            return "Heavy thunderstorm with hail"
        }
    }
    
    var icon: String {
        switch self {
        case .clearSky:
            return "sun"
        case .mainlyClear:
            return "sun"
        case .partlyCloudy:
            return "suncloudy"
        case .overcast:
            return "suncloudy"
        case .fog:
            return "cloudy"
        case .depositingRimeFog:
            return "cloudy"
        case .lightDrizzle:
            return "thunder"
        case .moderateDrizzle:
            return "thunder"
        case .denseDrizzle:
            return "thunder"
        case .lightFreezingDrizzle:
            return "suncloudy"
        case .denseFreezingDrizzle:
            return "suncloudy"
        case .slightRain:
            return "sunrainy"
        case .moderateRain:
            return "sunrainy"
        case .heavyRain:
            return "thunderstorm"
        case .lightFreezingRain:
            return "sunrainy"
        case .heavyFreezingRain:
            return "sunrainy"
        case .slightSnowFall:
            return "snow"
        case .moderateSnowFall:
            return "snow"
        case .heavySnowFall:
            return "snow"
        case .snowGrains:
            return "snow"
        case .slightRainShowers:
            return "sunrainy"
        case .moderateRainShowers:
            return "sunrainy"
        case .violentRainShowers:
            return "sunrainy"
        case .slightSnowShowers:
            return "snow"
        case .heavySnowShowers:
            return "snow"
        case .slightThunderstorm:
            return "thunderstorm"
        case .thunderstormWithHail:
            return "thunderstorm"
        case .heavyThunderstormWithHail:
            return "thunderstorm"
        }
    }


    static func getWeatherDescription(from code: Int?) -> String? {
        if let condition = WeatherCondition(rawValue: code ?? -1) {
            return condition.description
        } else {
            return nil
        }
    }

}

struct CurrentForecastEntity: Equatable {
    let latitude, longitude: Double?
    let time: String?
    let interval: Int?
    let temperature2M: Double?
    let relativeHumidity2M, isDay: Int?
    let weatherCondition: WeatherCondition?
    let temperatureUnit: String?
    
    static func fromResponseModel(_ model: OpenMateoResponseModel) -> CurrentForecastEntity {
        return CurrentForecastEntity(
            latitude: model.latitude,
            longitude: model.longitude,
            time: model.current?.time,
            interval: model.current?.interval,
            temperature2M: model.current?.temperature2M,
            relativeHumidity2M: model.current?.relativeHumidity2M,
            isDay: model.current?.isDay,
            weatherCondition:  WeatherCondition.init(rawValue: model.current?.weatherCode ?? 0),
            temperatureUnit: model.currentUnits?.temperature2M
        )
    }
}
