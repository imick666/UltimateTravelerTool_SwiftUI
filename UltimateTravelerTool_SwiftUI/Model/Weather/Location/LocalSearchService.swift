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
    
    private lazy var localSearchCompletter = MKLocalSearchCompleter()
    
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
        
        search(from: request)
    }
    
    public func getSuggestions(for query: String) {
        localSearchCompletter.queryFragment = query
        localSearchCompletter.region = MKCoordinateRegion(.world)
        localSearchCompletter.resultTypes = .address
    }
    
    private func search(from request: MKLocalSearch.Request) {
        let search = MKLocalSearch(request: request)
        search.start { (response, _) in
            guard let response = response else { return }
            self.cityNamePublisher.send(response.mapItems[0].placemark.locality ?? "N/C")
        }
    }
    
}
extension LocalSearchService: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let results = completer.results
        suggestionPublisher.send(results)
    }
}
