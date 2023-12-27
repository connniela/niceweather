//
//  LocationManager.swift
//  NiceWeather
//
//  Created by Connie Chang on 2023/12/7.
//

import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    
    static let instance = LocationManager()
    
    var lat: Double = 0
    var lon: Double = 0
    
    private var locationPublisher: CurrentValueSubject<CLLocation?, Never> = CurrentValueSubject(nil)
    private let manager = CLLocationManager()
    
    private override init() {
        super.init()
        manager.delegate = self
        manager.pausesLocationUpdatesAutomatically = false
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func location() -> AnyPublisher<CLLocation?, Never> {
       return locationPublisher.eraseToAnyPublisher()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        lat = newLocation.coordinate.latitude
        lon = newLocation.coordinate.longitude
        manager.stopUpdatingLocation()
        locationPublisher.send(newLocation)
    }
}
