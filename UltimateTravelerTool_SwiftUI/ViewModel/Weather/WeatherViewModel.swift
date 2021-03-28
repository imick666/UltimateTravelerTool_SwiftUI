//
//  WeatherViewData.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 26/03/2021.
//

import Foundation
import Combine

// MARK: - WeatherViewData

final class WeatherViewModel: Identifiable, ObservableObject {
    
    @Published var id = UUID()
    @Published var city = ""
    @Published var lon: Double
    @Published var lat: Double
    @Published var timeOffset: Int
    @Published var current: CurrentWeatherViewData
    @Published var hourly = [HourlyWeatherViewData]()
    @Published var daily = [DailyWeatherViewData]()
    @Published var isCurrentLocation = false
    
    private lazy var localSearchService = LocalSearchService()
    private var subsciptions = Set<AnyCancellable>()
    
    init (weather: WeatherResponse) {
        self.lon = weather.lon
        self.lat = weather.lat
        self.timeOffset = weather.timezoneOffset
        self.current = CurrentWeatherViewData(from: weather)
        self.hourly = getHourl(from: weather)
        self.daily = getDaily(from: weather)
        
        localSearchService.cityNamePublisher
            .sink(receiveValue: { self.city = $0 })
            .store(in: &subsciptions)
        
        localSearchService.getCityName(with: (lat, lon))
    }
    
    private func getHourl(from weather: WeatherResponse) -> [HourlyWeatherViewData] {
        // Convert WeatherResponse in [HourlyWeatherViewData]
        var hourlyTemp = weather.hourly
            .map { HourlyWeatherViewData(from: $0, for: .temp, with: timeOffset) }
        
        // Remove every item after 24 hours
        hourlyTemp.removeSubrange(24 ..< hourlyTemp.count)
        
        let houreRange = hourlyTemp.first!.dt ... hourlyTemp.last!.dt
        
        // Get sunrises in 24 hours range
        let sunrises = weather.daily
            .filter { houreRange ~= $0.sunrise }
            .map { Current(dt: $0.sunrise, sunrise: $0.sunrise, sunset: $0.sunrise, temp: $0.temp.day, weather: $0.weather) }
            .map { HourlyWeatherViewData(from: $0, for: .sunrise, with: timeOffset)}
        
        // Get sunsets in 24 hours range
        let sunsets = weather.daily
            .filter { houreRange ~= $0.sunset }
            .map { Current(dt: $0.sunset, sunrise: $0.sunrise, sunset: $0.sunset, temp: $0.temp.day, weather: $0.weather) }
            .map { HourlyWeatherViewData(from: $0, for: .sunset, with: timeOffset) }
        
        // Add sunrises and sunsets in houlry
        hourlyTemp.append(contentsOf: sunrises)
        hourlyTemp.append(contentsOf: sunsets)
        
        return hourlyTemp.sorted(by: { $0.dt < $1.dt })
        
    }
    
    private func getDaily(from weather: WeatherResponse) -> [DailyWeatherViewData] {
        let daily = weather.daily
            .dropFirst()
            .map { DailyWeatherViewData(from: $0, with: timeOffset) }
        
        
        return daily.sorted(by: { $0.dt < $1.dt })
    }
    
}

#if DEBUG
extension WeatherViewModel {
    
    static var placeholder: WeatherViewModel {
        let bundle = Bundle(for: WeatherFetcher.self)
        let url = bundle.url(forResource: "Weather", withExtension: "json")!
        let json = try! Data(contentsOf: url)
        let data = try! JSONDecoder().decode(WeatherResponse.self, from: json)
        
        let object = WeatherViewModel(weather: data)
        object.city = "Cupertino"
        
        return object
    }
}
#endif

// MARK: - CurrentWeatherViewData

struct CurrentWeatherViewData {
    
    var temp: String {
        return current.temp.roundedTemp
    }
    var description: String {
        return current.weather[0].description
    }
    var maxTemp: String {
        return weather.daily[0].temp.max.roundedTemp
    }
    var minTemp: String {
        return weather.daily[0].temp.min.roundedTemp
    }
    var iconName: String {
        return current.weather[0].iconName
    }
    
    private var weather: WeatherResponse
    private var current: Current {
        return weather.current
    }
    
    init(from weather: WeatherResponse) {
        self.weather = weather
    }

}

// MARK: - HourlyWeatherViewData

struct HourlyWeatherViewData: Identifiable {
    
    enum EventType {
        case temp, sunrise, sunset
    }
    
    var id = UUID()
    var temp: String {
        switch eventType {
        case .sunrise: return "Sunrise"
        case .sunset: return "Sunset"
        default: return weather.temp.roundedTemp
        }

    }
    
    var hour: String {
        switch eventType {
        case .temp: return dt.dateString(timeOffset: timeOffset, returnStyle: .hour)
        default: return dt.dateString(timeOffset: timeOffset, returnStyle: .hourMinutes)
        }
    }
    
    var iconImage: String {
        switch eventType {
        case .sunrise: return "sunrise.fill"
        case .sunset: return "sunset.fill"
        default: return weather.weather[0].iconName
        }
    }
    
    fileprivate var dt: Int {
        weather.dt
    }
    
    private var weather: Current
    private var eventType: EventType
    private var timeOffset: Int
    
    init(from weather: Current,for eventType: EventType, with timeOffset: Int) {
        self.weather = weather
        self.eventType = eventType
        self.timeOffset = timeOffset
    }
    
}

// MARK: - DailyWeatherViewData

struct DailyWeatherViewData: Identifiable {
    
    var id = UUID()
    var temp: String {
        return weather.temp.day.roundedTemp
    }
    var minTemp: String {
        return weather.temp.min.roundedTemp
    }
    var maxTemp: String {
        return weather.temp.max.roundedTemp
    }
    var day: String {
        return weather.dt.dateString(timeOffset: offset, returnStyle: .day)
    }
    var iconImage: String {
        return weather.weather[0].iconName
    }
    
    fileprivate var dt: Int {
        return weather.dt
    }
    
    private var offset: Int
    private var weather: Daily
    
    init(from weather: Daily, with offset: Int) {
        self.weather = weather
        self.offset = offset
    }
    
}
