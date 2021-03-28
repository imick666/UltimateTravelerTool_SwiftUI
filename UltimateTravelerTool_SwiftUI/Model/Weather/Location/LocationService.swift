//
//  LocationService.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 27/03/2021.
//

import Foundation
import Combine
import CoreLocation

final class LocationService: NSObject {
    
    var publisher = PassthroughSubject<AnyPublisher<WeatherViewModel, HTTPError>, Never>()
    
    private lazy var locationManager = CLLocationManager()
    private lazy var weatherFetcher = WeatherFetcher()
    
    override init() {
        super.init()
        askAuthorisations()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    public func getUserLocationWeather() {
        locationManager.startUpdatingLocation()
    }
    
    public func stopUserLocationWeather() {
        locationManager.stopUpdatingLocation()
    }
    
    private func askAuthorisations() {
        guard locationManager.authorizationStatus == .authorizedWhenInUse else {
            locationManager.requestWhenInUseAuthorization()
            return
        }

    }
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        let location = (lat: lastLocation.coordinate.latitude, lon: lastLocation.coordinate.longitude)
        
        publisher.send(weatherFetcher.getWeather(for: location))
    }
    
}
