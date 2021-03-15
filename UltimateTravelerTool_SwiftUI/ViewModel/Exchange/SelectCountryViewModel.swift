//
//  SelectCountryViewModel.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 12/03/2021.
//

import Foundation
import Combine

final class SelectCoutnryViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published private(set) var countries = [RestcountriesResponse]()
    @Published var searchTerms: String = ""
    
    private var subscribers = Set<AnyCancellable>()
    private var restcountries: RestcountriesFetcher
    
    // MARK: - Init
    
    init(restcountries: RestcountriesFetcher, searchTerms: String = "") {
        self.restcountries = restcountries
        self.searchTerms = searchTerms
        
        $searchTerms
            .sink(receiveValue: { _ in self.sortCountries() })
            .store(in: &subscribers)
    }
    
    // MARK: - Methodes
    
    private func sortCountries() {
        _ = restcountries.getCountries(searchTerms: searchTerms)
            .sink(receiveCompletion: { print($0) },
                  receiveValue: { self.countries = $0 })
    }
}
