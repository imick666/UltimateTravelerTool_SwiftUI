//
//  LocalSearchService.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 27/03/2021.
//

import Foundation
import Combine
import MapKit

final class LocalSearchService {
    
    var cityNamePublisher = PassthroughSubject<String, Never>()
    
    public func getCityName(with location: (lat: Double, lon: Double)) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "lat: \(location.lat) lon: \(location.lon)"
        request.region = MKCoordinateRegion(.world)
        request.resultTypes = .address
        
        search(from: request)
    }
    
    private func search(from request: MKLocalSearch.Request) {
        let search = MKLocalSearch(request: request)
        search.start { (response, _) in
            guard let response = response else { return }
            self.cityNamePublisher.send(response.mapItems[0].placemark.locality ?? "N/C")
        }
    }
    
}
