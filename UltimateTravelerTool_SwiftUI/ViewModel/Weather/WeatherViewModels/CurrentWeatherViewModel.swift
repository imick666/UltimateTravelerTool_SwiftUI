//
//  CurrentWeatherViewModel.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 17/03/2021.
//

import SwiftUI
import Combine

final class CurrentWeatherViewModel {
    
    private var weather: WeatherResponse
    
    init(weather: WeatherResponse) {
        self.weather = weather
        
    }
}

extension CurrentWeatherViewModel {
    
    var description: String {
        return weather.current.weather[0].description
    }
    
    var temp: String {
        let temp = weather.current.temp
        let formatter = NumberFormatter()
        formatter.allowsFloats = false
        return formatter.string(for: temp)! + "°"
    }
    
    var maxTemp: String {
        let temp = weather.daily[0].temp.max
        let formatter = NumberFormatter()
        formatter.allowsFloats = false
        return formatter.string(for: temp)! + "°"
    }
    
    var minTemp: String {
        let temp = weather.daily[0].temp.min
        let formatter = NumberFormatter()
        formatter.allowsFloats = false
        return formatter.string(for: temp)! + "°"
    }
    
    var iconName: String {
        return  weather.current.weather[0].iconName
    }
    
    
}
