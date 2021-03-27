//
//  WeatherListViewModel.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 27/03/2021.
//

import Foundation

final class WeatherListViewModel: ObservableObject {
    
    @Published var weathers = [WeatherViewModel]()
    
    init() {
        self.weathers = [WeatherViewModel.placeholder]
    }
    
}
