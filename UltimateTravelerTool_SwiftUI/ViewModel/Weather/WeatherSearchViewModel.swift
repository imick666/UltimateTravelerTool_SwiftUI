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
    
    private lazy var localSearchService = LocalSearchService()
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        $serachTerms
            .sink(receiveValue: {
                if $0.isEmpty { self.result = [] }
                self.getSuggestions(from: $0)
            })
            .store(in: &subscriptions)
        
        localSearchService.suggestionPublisher
            .sink(receiveValue: { self.result = $0 })
            .store(in: &subscriptions)
    }
    
    private func getSuggestions(from searchTerms: String) {
        localSearchService.getSuggestions(for: searchTerms)
    }
}
