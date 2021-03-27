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
    
    var locationServicePublisher = PassthroughSubject<AnyPublisher<WeatherViewModel, HTTPError>, Never>()
    
    private var locationManager: CLLocationManager
    private var weatherFetcher: WeatherFetcher
//    private var userLocation: (lat: Double, lon: Double)?
    
    override init() {
        self.locationManager = CLLocationManager()
        self.weatherFetcher = WeatherFetcher()
        super.init()
        authorisations()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyReduced
    }
    
    public func getUserLocationWeather() {
        locationManager.startUpdatingLocation()
    }
    
    private func authorisations() {
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
        
        locationServicePublisher.send(weatherFetcher.getWeather(for: location))
        
        locationManager.stopUpdatingLocation()
    }
    
}
