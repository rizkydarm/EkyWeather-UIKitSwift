
//
//  LoginViewModel.swift
//  EkyWeather
//
//  Created by Eky on 18/01/25.
//

import Foundation
import Combine

class HomeViewModel: BaseViewModel {
    
    private let forecastUseCase: ForecastUseCase
    
    @Published var latitude: Double = 0
    @Published var longitude: Double  = 0
    @Published var isLoading = false
    @Published var error: String?
    
    @Published var currentForecast: CurrentForecastEntity?
    @Published var oneDayForecast: OneDayForecastEntity?
    @Published var sevenDaysForecast: SevenDaysForecastEntity?
    
    init(forecastUseCase: ForecastUseCase) {
        self.forecastUseCase = forecastUseCase
    }
    
    func getCurrentForecast() {
        forecastUseCase.getCurrent(latitude: latitude, longitude: longitude)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] entity in
                self?.currentForecast = entity
            }
            .store(in: &cancellables)
    }
    
    func getOneDayForecast() {
        forecastUseCase.getOneDay(latitude: latitude, longitude: longitude)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] entity in
                self?.oneDayForecast = entity
            }
            .store(in: &cancellables)
    }
    
    func getSevenDaysForecast() {
        forecastUseCase.getSevenDays(latitude: latitude, longitude: longitude)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] entity in
                self?.sevenDaysForecast = entity
            }
            .store(in: &cancellables)
    }
}
