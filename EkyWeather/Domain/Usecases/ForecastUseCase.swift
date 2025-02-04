//
//  AuthUseCase.swift
//  EkyWeather
//
//  Created by Eky on 22/01/25.
//


import Combine

protocol ForecastUseCase {
    func getCurrent(latitude: Double, longitude: Double) -> AnyPublisher<CurrentForecastEntity, Error>
    func getOneDay(latitude: Double, longitude: Double) -> AnyPublisher<OneDayForecastEntity, Error>
    func getSevenDays(latitude: Double, longitude: Double) -> AnyPublisher<SevenDaysForecastEntity, Error>
}

class ForecastUseCaseImpl: ForecastUseCase {
    private let repository: ForecastRepositoryImpl
    
    init() {
        self.repository = ForecastRepositoryImpl()
    }
    
    func getCurrent(latitude: Double, longitude: Double) -> AnyPublisher<CurrentForecastEntity, Error> {
        repository.getCurrent(latitude: latitude, longitude: longitude)
    }
    func getOneDay(latitude: Double, longitude: Double) -> AnyPublisher<OneDayForecastEntity, Error> {
        repository.getOneDay(latitude: latitude, longitude: longitude)
    }
    func getSevenDays(latitude: Double, longitude: Double) -> AnyPublisher<SevenDaysForecastEntity, Error> {
        repository.getSevenDays(latitude: latitude, longitude: longitude)
    }
}
