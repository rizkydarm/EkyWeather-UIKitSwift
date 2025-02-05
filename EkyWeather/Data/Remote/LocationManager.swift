//
//  LocationViewModel.swift
//  EkyWeather
//
//  Created by Eky on 31/01/25.
//

import UIKit
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation(latitude: Double, longitude: Double, city: String?, country: String?)
    func didFailWithError(error: Error)
}

class LocationManager: NSObject {
    
    var latitude: Double?
    var longitude: Double?
    var city: String?
    var country: String?
    
    private let locationManager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?
    
    override init() {
        super.init()
        
        // Set up location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
    
    private func reverseGeocode(location: CLLocation, completion: @escaping (String?, String?) -> Void) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                self.delegate?.didFailWithError(error: error)
                completion(nil, nil)
                return
            }
            if let placemark = placemarks?.first {
                let city = placemark.locality ?? "Unknown City"
                let country = placemark.country ?? "Unknown Country"
                completion(city, country)
            } else {
                completion(nil, nil)
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Stop updating location to save battery
        locationManager.stopUpdatingLocation()
        
        // Get latitude and longitude
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        // Reverse geocode to get city and country
        reverseGeocode(location: location) { (city, country) in
            self.delegate?.didUpdateLocation(latitude: latitude, longitude: longitude, city: city, country: country)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailWithError(error: error)
    }
}
