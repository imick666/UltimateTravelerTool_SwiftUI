//
//  WeatherListViewModel.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 27/03/2021.
//

import Foundation
import Combine

final class WeatherListViewModel: ObservableObject {
    
    @Published var locaWeather: WeatherViewModel?
    @Published var weathers = [WeatherViewModel]()
    
    private var locationService: LocationService
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        self.weathers = [WeatherViewModel.placeholder]
        self.locationService = LocationService()
        
        locationService.locationServicePublisher
            .flatMap { $0 }
            .sink(receiveCompletion: { print($0) },
                  receiveValue: { self.locaWeather = $0 })
            .store(in: &subscriptions)
    }
    
    public func getUserWeather() {
        locationService.getUserLocationWeather()
    }
}
