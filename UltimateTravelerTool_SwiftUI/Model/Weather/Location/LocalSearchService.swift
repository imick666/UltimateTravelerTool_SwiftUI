//
//  LocalSearchService.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 27/03/2021.
//

import Foundation
import Combine
import MapKit

final class LocalSearchService: NSObject {
    
    // MARK: - Properties
    
    var cityNamePublisher = PassthroughSubject<String, Never>()
    var suggestionPublisher = PassthroughSubject<[MKLocalSearchCompletion], Never>()
    var selectedLocationPublisher = PassthroughSubject<AnyPublisher<WeatherViewModel, HTTPError>, Never>()
    
    private lazy var localSearchCompletter = MKLocalSearchCompleter()
    private lazy var weatherFetcher = WeatherFetcher()
    
    // MARK: - Init
    
    override init() {
        super.init()
        self.localSearchCompletter.delegate = self
    }
    
    // MARK: - Methodes
    
    public func getCityName(with location: (lat: Double, lon: Double)) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "lat: \(location.lat) lon: \(location.lon)"
        request.region = MKCoordinateRegion(.world)
        request.resultTypes = .address
        
        search(from: request) { item in
            self.cityNamePublisher.send(item.placemark.locality ?? "N/C")
        }
    }
    
    public func getSuggestions(for query: String) {
        localSearchCompletter.queryFragment = query
        localSearchCompletter.region = MKCoordinateRegion(.world)
        localSearchCompletter.resultTypes = .address
    }
    
    public func getWeather(for completion: MKLocalSearchCompletion) {
        let request = MKLocalSearch.Request(completion: completion)
        request.region = MKCoordinateRegion(.world)
        request.resultTypes = .address
        
        search(from: request) { item in
            let lat = item.placemark.coordinate.latitude
            let lon = item.placemark.coordinate.longitude
            
            self.selectedLocationPublisher.send(self.weatherFetcher.getWeather(for: (lat, lon)))
        }
    }
    
    private func search(from request: MKLocalSearch.Request, completionHandler: @escaping ((MKMapItem) -> Void)) {
        let search = MKLocalSearch(request: request)
        search.start { (response, _) in
            guard let response = response else { return }
            completionHandler(response.mapItems[0])
        }
    }
    
}
extension LocalSearchService: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let results = completer.results
        suggestionPublisher.send(results)
    }
}
