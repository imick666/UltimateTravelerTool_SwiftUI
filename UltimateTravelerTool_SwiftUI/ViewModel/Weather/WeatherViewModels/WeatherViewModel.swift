//
//  WeatherViewModel.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 17/03/2021.
//

import SwiftUI
import Combine

struct WeatherViewModel: Identifiable {
    
    var id = UUID()
    var current: CurrentWeatherViewModel
    var hourly = [HourlyWeatherViewModel]()
    var daily = [DailyWeatherViewModel]()
    
    init(weather: WeatherResponse) {
        self.current = CurrentWeatherViewModel(weather: weather)
        self.hourly = self.getHourly(from: weather)
        self.daily = self.getDaily(from: weather)
    }
    
    private func getHourly(from weather: WeatherResponse) -> [HourlyWeatherViewModel] {
        
        var hourlyResponse = weather.hourly
        hourlyResponse.removeSubrange(24 ..< hourlyResponse.count)
        
        var sun = [Current]()
        
        for current in weather.daily {
            
            let hourlyRange = hourlyResponse.first!.dt ... hourlyResponse.last!.dt
            
            if hourlyRange ~= current.sunrise { sun.append(Current(dt: current.sunrise, sunrise: nil, sunset: nil, temp: 2000, weather: [])) }
            if hourlyRange ~= current.sunset { sun.append(Current(dt: current.sunset, sunrise: nil, sunset: nil, temp: 3000, weather: []))}
        }
        
        
        hourlyResponse += sun
        hourlyResponse.sort(by: { $0.dt < $1.dt })
        let viewModels = hourlyResponse.map { HourlyWeatherViewModel(weather: $0, timeOffset: weather.timezoneOffset)}
        
        return viewModels
    }
    
    private func getDaily(from weather: WeatherResponse) -> [DailyWeatherViewModel] {
        let dailyResponse = weather.daily.sorted(by: { $0.dt < $1.dt })
        
        let viewModels = dailyResponse.map { DailyWeatherViewModel(weather: $0, timeOffset: weather.timezoneOffset)}
        
        return viewModels
    }
    
}

#if DEBUG
extension WeatherViewModel {
    
    static var placeholder: WeatherViewModel {
        let bundle = Bundle(for: WeatherFetcher.self)
        let url = bundle.url(forResource: "Weather", withExtension: "json")!
        let json = try! Data(contentsOf: url)
        let data = try! JSONDecoder().decode(WeatherResponse.self, from: json)
        
        return WeatherViewModel(weather: data)
        
    }
    
}
#endif
