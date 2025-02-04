//
//  ForecastApiManager.swift
//  EkyWeather
//
//  Created by Eky on 30/01/25.
//

class ForecastApiManager: ApiManager {
    
    static let shared = ForecastApiManager()
    
    private let api = ForecastApi()
        
    func getCurrent(latitude: Double, longitude: Double, completion: @escaping (Result<OpenMateoResponseModel, Error>) -> Void) -> Void {
        let url = api.current(latitude: latitude, longitude: longitude)
        request(url: url, expecting: OpenMateoResponseModel.self, completion: completion)
    }
    func getHourly(latitude: Double, longitude: Double, completion: @escaping (Result<OpenMateoResponseModel, Error>) -> Void) -> Void {
        let url = api.hourly(latitude: latitude, longitude: longitude)
        request(url: url, expecting: OpenMateoResponseModel.self, completion: completion)
    }
    func getDaily(latitude: Double, longitude: Double, completion: @escaping (Result<OpenMateoResponseModel, Error>) -> Void) -> Void {
        let url = api.daily(latitude: latitude, longitude: longitude)
        request(url: url, expecting: OpenMateoResponseModel.self, completion: completion)
    }
}
