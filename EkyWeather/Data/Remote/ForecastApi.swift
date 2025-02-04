//
//  WeatherApi.swift
//  EkyWeather
//
//  Created by Eky on 30/01/25.
//

class ForecastApi: OpenMeteoApi {
    
    func current(latitude: Double, longitude: Double) -> Endpoint {
        return createEndpoint(path: "forecast", method: .get, query: [
            "latitude": latitude,
            "longitude": longitude,
            "current": "temperature_2m,relative_humidity_2m,is_day,weather_code"
        ])
    }
    
    func hourly(latitude: Double, longitude: Double) -> Endpoint {
        return createEndpoint(path: "forecast", method: .get, query: [
            "latitude": latitude,
            "longitude": longitude,
            "hourly": "temperature_2m,relative_humidity_2m,apparent_temperature,weather_code"
        ])
    }
    
    func daily(latitude: Double, longitude: Double) -> Endpoint {
        return createEndpoint(path: "forecast", method: .get, query: [
            "latitude": latitude,
            "longitude": longitude,
            "daily": "weather_code,temperature_2m_max,temperature_2m_min"
        ])
    }
}
