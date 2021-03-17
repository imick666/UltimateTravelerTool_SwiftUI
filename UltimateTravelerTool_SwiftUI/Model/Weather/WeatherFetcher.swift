//
//  WeatherFetcher.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 16/03/2021.
//

import Foundation
import Combine

final class WeatherFetcher {
    
    var httpHelper: HTTPRequestHelper
    
    init(httpHelper: HTTPRequestHelper = HTTPRequestHelper()) {
        self.httpHelper = httpHelper
    }
    
    func getWeather(for location: (lat: String, lon: String)) -> AnyPublisher<WeatherResponse, HTTPError> {
        fetchWeather(for: location)
    }
    
    func getIcon(for id: String) -> AnyPublisher<Data, HTTPError> {
        guard let url = getIconUrl(for: id) else { return Fail(outputType: Data.self, failure: HTTPError.badUrl).eraseToAnyPublisher() }
        
        return httpHelper.fetchData(url: url)
            .eraseToAnyPublisher()
            
    }
    
    private func fetchWeather(for location: (lat: String, lon: String)) -> AnyPublisher<WeatherResponse, HTTPError> {
        guard let url = getUrl(for: location) else { return Fail(outputType: WeatherResponse.self, failure: HTTPError.badUrl).eraseToAnyPublisher() }
        
        return httpHelper.fetchJson(url: url)
            .eraseToAnyPublisher()
    }
    
    private func getIconUrl(for id: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "openweathermap.org"
        components.path = "/img/wn/"
        components.query = "\(id)@2x.png"
        
        return components.url
        
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
