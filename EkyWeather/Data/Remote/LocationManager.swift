//
//  LocationViewModel.swift
//  EkyWeather
//
//  Created by Eky on 31/01/25.
//

import UIKit
import CoreLocation

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    // Publishers for location data
    var latitude: Double?
    var longitude: Double?
    var city: String?
    var country: String?
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        // Set up location manager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // Reverse geocode location to get city and country
    private func reverseGeocode(location: CLLocation) async {
        let geocoder = CLGeocoder()
        
        do {
            let placemark = try await geocoder.reverseGeocodeLocation(location)
            city = placemark.first?.locality
            country = placemark.first?.country
//                .publisher
//                .sink { completion in
//                    if case .failure(let error) = completion {
//                        print("Failed to reverse geo code location: \(error.localizedDescription)")
//                        log.error("Failed to reverse geo code location: \(error)")
//                    }
//                } receiveValue: { [weak self] placemark in
//                    self?.city = placemark.locality ?? "Unknown City"
//                    self?.country = placemark.country ?? "Unknown Country"
//                    log.info("Reverse Geocode Location City: \(self?.city ?? ""), Country: \(self?.country ?? "")")
//                }
//                .store(in: &cancellables)
        } catch {
            log.error("Failed to reverse geo code location: \(error.localizedDescription)")
        }
        
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Stop updating location to save battery
        locationManager.stopUpdatingLocation()
        
        // Update latitude and longitude
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        
        // Reverse geocode the location
        Task {
            await reverseGeocode(location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log.error("Failed to find user's location: \(error.localizedDescription)")
    }
}
