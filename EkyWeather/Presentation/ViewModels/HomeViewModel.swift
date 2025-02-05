
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
    
    private lazy var locationManager: LocationManager = {
        let manager = LocationManager()
        manager.delegate = self
        return manager
    }()
    
    @Published var error: String?
    
    @Published var currentForecast: CurrentForecastEntity?
    @Published var oneDayForecast: OneDayForecastEntity?
    @Published var sevenDaysForecast: SevenDaysForecastEntity?
    
    @Published var latitude: Double?
    @Published var longitude: Double?
    @Published var city: String?
    @Published var country: String?
    
    init(forecastUseCase: ForecastUseCase) {
        self.forecastUseCase = forecastUseCase
    }
    
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func getCurrentForecast(_ latitude: Double, _ longitude: Double) {
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
        if let latitude = locationManager.latitude, let longitude = locationManager.longitude {
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
        
    }
    
    func getSevenDaysForecast() {
        if let latitude = locationManager.latitude, let longitude = locationManager.longitude {
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
}

extension HomeViewModel: LocationManagerDelegate {
    
    func didUpdateLocation(latitude: Double, longitude: Double, city: String?, country: String?) {
        self.latitude = latitude
        self.longitude = longitude
        self.city = city
        self.country = country
    }
    
    func didFailWithError(error: any Error) {
        self.error = error.localizedDescription
    }
}
