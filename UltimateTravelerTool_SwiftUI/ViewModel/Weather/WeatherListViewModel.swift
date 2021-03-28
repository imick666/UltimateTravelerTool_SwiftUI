//
//  WeatherListViewModel.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 27/03/2021.
//

import Foundation
import Combine

final class WeatherListViewModel: ObservableObject {
    
    @Published var localWeather: WeatherViewModel?
    @Published var weathers = [WeatherViewModel]()
    
    lazy private(set) var localSearchService = LocalSearchService()
    private lazy var locationService = LocationService()
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        locationService.publisher
            .flatMap { $0 }
            .sink(receiveCompletion: { print($0) },
                  receiveValue: { self.localWeather = $0 })
            .store(in: &subscriptions)
        
        localSearchService.selectedLocationPublisher
            .flatMap { $0 }
            .sink(receiveCompletion: { print($0) },
                  receiveValue: { self.weathers.append($0) })
            .store(in: &subscriptions)
    }
    
    public func getUserWeather() {
        guard localWeather == nil else { return }
        locationService.getUserLocationWeather()
    }
}
