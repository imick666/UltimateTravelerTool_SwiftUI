//
//  SelectCurrencyViewModel.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 12/03/2021.
//

import Foundation
import Combine

final class SelectCurrencyViewModel: ObservableObject {
    
    @Published private(set) var currencies = [Currency]()
    @Published var searchTerms: String
    
    private var subscribers = Set<AnyCancellable>()
    private var restcountries: RestcountriesFetcher
    
    init(restcountries: RestcountriesFetcher, searchTerms: String = "") {
        self.restcountries = restcountries
        self.searchTerms = searchTerms
        
        $searchTerms
            .sink(receiveValue: { _ in self.sortCurrencies() })
            .store(in: &subscribers)
    }
    
    private func sortCurrencies() {
        _ = restcountries.getCurrencies(searchTerms: searchTerms)
            .sink(receiveCompletion: { print($0) },
                  receiveValue: { self.currencies = $0 })
    }
    
    
    
}
