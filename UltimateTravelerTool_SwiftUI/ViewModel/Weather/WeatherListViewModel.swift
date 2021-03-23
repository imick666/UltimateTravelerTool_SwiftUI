//
//  WeatehrListViewModel.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 16/03/2021.
//

import Foundation
import Combine

final class WeatherListViewModel: ObservableObject {
    
    @Published var weathers = [WeatherViewModel]()
    
    private var weatehrFetcher = WeatherFetcher()
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        weathers.append(WeatherViewModel.placeholder)
    }
    
}
