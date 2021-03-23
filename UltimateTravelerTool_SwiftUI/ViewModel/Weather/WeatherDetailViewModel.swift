//
//  WeatherDetailViewModel.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 20/03/2021.
//

import SwiftUI
import Combine

final class WeatherDetailViewModel: ObservableObject {
    
    @Published var current: CurrentWeatherViewModel
    @Published var hourly: [HourlyWeatherViewModel]
    @Published var daily: [DailyWeatherViewModel]
    
    init(weather: WeatherViewModel) {
        self.current = weather.current
        self.hourly = weather.hourly
        self.daily = weather.daily
    }
}
