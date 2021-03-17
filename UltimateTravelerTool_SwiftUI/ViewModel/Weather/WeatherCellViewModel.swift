//
//  WeatherCellViewModel.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 16/03/2021.
//

import Foundation
import Combine

final class WeatherCellViewModel: ObservableObject {
    
    @Published var weather: WeatherViewModel
    
    init(weather: WeatherViewModel) {
        self.weather = weather
    }
    
}
