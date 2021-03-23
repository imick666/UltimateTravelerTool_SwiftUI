//
//  DailyWeatherViewModel.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 17/03/2021.
//

import SwiftUI
import Combine

final class DailyWeatherViewModel: Identifiable {
    
    var id = UUID()
    private var timeOffset: Int
    private  var weather: Daily
    
    init(weather: Daily, timeOffset: Int) {
        self.weather = weather
        self.timeOffset = timeOffset
    }
    
}

extension DailyWeatherViewModel {
    
    /// Return the day (ex. Monday)
    var day: String {
        return weather.dt.dateString(timeOffset: timeOffset, returnStyle: .day)
    }
    
    /// Return the system icon name (ex. Sunrise.fill)
    var icon: String {
        return weather.weather[0].iconName
    }
    
    /// Return the minimum temperature witgout float (ex. 17)
    var minTemp: String {
        let formatter = NumberFormatter()
        formatter.allowsFloats = false
        
        return formatter.string(for: weather.temp.min)!
    }
    
    /// Return the minimum temperature witgout float (ex. 17)
    var maxTemp: String {
        let formatter = NumberFormatter()
        formatter.allowsFloats = false
        
        return formatter.string(for: weather.temp.max)!
    }
}
