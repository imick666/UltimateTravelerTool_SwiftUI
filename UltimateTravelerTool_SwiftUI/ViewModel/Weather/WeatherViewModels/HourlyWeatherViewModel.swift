//
//  HourlyWeatherViewModel.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 17/03/2021.
//

import SwiftUI
import Combine

final class HourlyWeatherViewModel: Identifiable {
    
    
    var id = UUID()
    private var timeOffset: Int
    private var weather: Current
    
    init(weather: Current, timeOffset: Int) {
        self.weather = weather
        self.timeOffset = timeOffset
    }
}

extension HourlyWeatherViewModel {
    
    /// Return system icon name (ex. sunset.fill)
    var iconName: String {
        guard weather.temp != 2000 else { return "sunrise.fill" }
        guard weather.temp != 3000 else { return "sunset.fill"}
        return weather.weather[0].iconName
    }

    /// Return hour
    var hour: String {
        guard weather.temp < 1000  else { return weather.dt.dateString(timeOffset: timeOffset, returnStyle: .hourMinutes) }
        return weather.dt.dateString(timeOffset: timeOffset, returnStyle: .hour)
    }
    
    /// Return Temperature without float (ex. 17°)
    var temp: String {
        guard weather.temp != 2000 else { return "sunrise" }
        guard weather.temp != 3000 else { return "sunset"}
        let temp = weather.temp
        let formatter = NumberFormatter()
        formatter.allowsFloats = false
        return formatter.string(for: temp)! + "°"
    }
}
