//
//  WeatherFetcher.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 16/03/2021.
//

import Foundation
import Combine

final class WeatherFetcher {
    
    private var httpHelper: HTTPRequestHelper
    
    init(httpHelper: HTTPRequestHelper = HTTPRequestHelper()) {
        self.httpHelper = httpHelper
    }
    
    func getWeather(for location: (lat: String, lon: String)) -> AnyPublisher<WeatherViewModel, HTTPError> {
        fetchWeather(for: location)
            .map { WeatherViewModel(weather: $0) }
            .eraseToAnyPublisher()
    }
    
    private func fetchWeather(for location: (lat: String, lon: String)) -> AnyPublisher<WeatherResponse, HTTPError> {
        guard let url = getUrl(for: location) else { return Fail(outputType: WeatherResponse.self, failure: HTTPError.badUrl).eraseToAnyPublisher() }
        
        return httpHelper.fetchJson(url: url)
            .eraseToAnyPublisher()
    }
    
    private func getUrl(for location: (lat: String, lon: String)) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/onecall"
        
        components.queryItems = [
            URLQueryItem(name: "lat", value: location.lat),
            URLQueryItem(name: "lon", value: location.lon),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "exclude", value: "alerts,minutely"),
            URLQueryItem(name: "lang", value: Locale.current.languageCode),
            URLQueryItem(name: "appid", value: APIConfig.openWeatherKey)
        ]
        
        
        return components.url
    }
    
    
}
