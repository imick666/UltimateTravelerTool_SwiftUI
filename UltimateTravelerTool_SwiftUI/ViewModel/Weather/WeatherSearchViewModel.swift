//
//  WeatherSearchViewModel.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 27/03/2021.
//

import Foundation
import Combine
import MapKit

final class WeatherSearchViewModel: ObservableObject {
    
    @Published var result = [MKLocalSearchCompletion]()
    @Published var serachTerms = ""
    
    private var localSearchService: LocalSearchService
    private var subscriptions = Set<AnyCancellable>()
    
    init(localSearchService: LocalSearchService) {
        
        self.localSearchService = localSearchService
        
        $serachTerms
            .sink(receiveValue: {
                if $0.isEmpty { self.result = [] }
                self.getSuggestions(from: $0)
            })
            .store(in: &subscriptions)
        
        self.localSearchService.suggestionPublisher
            .sink(receiveValue: { self.result = $0 })
            .store(in: &subscriptions)
    }
    
    func getWeather(for suggestion: MKLocalSearchCompletion) {
        localSearchService.getWeather(for: suggestion)
    }
    
    private func getSuggestions(from searchTerms: String) {
        localSearchService.getSuggestions(for: searchTerms)
    }
}
