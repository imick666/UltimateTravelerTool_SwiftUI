//
//  WeatherViewModel.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 17/03/2021.
//

import SwiftUI
import Combine

final class WeatherViewModel: Identifiable {
    
    var id = UUID()
    var current: CurrentWeatherViewModel
    
    init(weather: WeatherResponse) {
        self.current = CurrentWeatherViewModel(weather: weather)
    }
    
}



extension WeatherViewModel {
    
    static var placeholder: WeatherViewModel {
        let currentWeather = Weather(id: 800, main: Main.clear, weatherDescription: Description.clearSky, icon: "01d")
        let current = Current(dt: 1615917960, sunrise: 1615904234, sunset: 1615947377, temp: 11.81, weather: [currentWeather])
        
        let dailyTemp = Temp(day: 12, min: 12, max: 12)
        let daily = Daily(dt: 1616097600, sunrise: 1616076853, sunset: 1616120285, temp: dailyTemp, weather: [currentWeather, currentWeather, currentWeather])
        
        let weather = WeatherResponse(lat: 37.323, lon: -122.0527, timezone: "America/Los_Angeles", timezoneOffset: -25200, current: current, hourly: [current, current, current], daily: [daily, daily, daily, daily])
        
        
        return WeatherViewModel(weather: weather)
        
    }
    
}
