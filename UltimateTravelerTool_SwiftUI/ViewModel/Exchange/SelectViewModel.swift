//
//  SelectViewModel.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 15/03/2021.
//

import Foundation
import Combine

final class SelectViewModel: ObservableObject {
    
    @Published var searchTerms = ""
    @Published var countries = [RestcountriesResponse]()
    @Published var currencies = [Currency]()
    
    private(set) var restcountriesFetcher = RestcountriesFetcher()
    private(set) var exchangeDelegate: exchangeDelegate
    private var subscriptions = Set<AnyCancellable>()
    
    init(delegate: exchangeDelegate) {
        self.exchangeDelegate = delegate
        
        $searchTerms
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { _ in
                self.getRestcountries()
            }
            .store(in: &subscriptions)
    }
    
    private func getRestcountries() {
        restcountriesFetcher.getCountries(searchTerms: searchTerms)
            .sink { print($0) }
                receiveValue: { self.countries = $0 }
            .store(in: &subscriptions)
        
        restcountriesFetcher.getCurrencies(searchTerms: searchTerms)
            .sink(receiveCompletion: { print($0 )},
                  receiveValue: { self.currencies = $0 })
            .store(in: &subscriptions)
    }
    
}
