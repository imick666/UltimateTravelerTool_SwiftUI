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
    
    private var fetcher = WeatherFetcher()
    var subscriptions = Set<AnyCancellable>()
    
    init(weather: WeatherResponse) {
        self.weather = weather
    }
    
    deinit {
        subscriptions.forEach { $0.cancel() }
    }
    
    private func getIcon(for id: String) -> UIImage? {
        
        var image: UIImage? = nil
        
        fetcher.getIcon(for: id)
            .tryMap { data -> UIImage in
                guard let image = UIImage(data: data) else { throw HTTPError.parsing }
                return image
            }
            .mapError { error -> HTTPError in
                switch error {
                case is HTTPError: return error as! HTTPError
                default: return HTTPError.otherError
                }
            }
            .sink(receiveCompletion: { print($0) },
                  receiveValue: { image = $0 } )
            .store(in: &subscriptions)

        return image
    }
    
}

extension CurrentWeatherViewModel {
    
    var description: String {
        return weather.current.weather[0].weatherDescription.rawValue
    }
    
    var temp: String {
        let temp = weather.current.temp
        return "\(temp)"
    }
    
    var maxTemp: String {
        let temp = weather.daily[0].temp.max
        return "\(temp)"
    }
    
    var minTemp: String {
        let temp = weather.daily[0].temp.min
        return "\(temp)"
    }
    
    var icon: Image {
        let id = weather.current.weather[0].icon
        guard let image = getIcon(for: id) else { return Image("") }
        return Image(uiImage: image)
    }
    
    
}
