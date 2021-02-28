//
//  ExchangeViewModel.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 28/02/2021.
//

import SwiftUI

final class ExchangeViewModel: ObservableObject {
    
    @Published var amourOne = ""
    @Published var currencyOne: Currency?
    @Published var amountTwo = ""
    @Published var currencyTwo: Currency?
    
    private var restCountriesFetcher = RestcountriesFetcher()
    private var fixerFetcher = FixerFetcher()
    private var countriesList = [RestcountriesResponse]()
    
    var countries: [RestcountriesResponse] {
        fetchCountries()
        
        return []
    }
    var currencies: [Currency] {
        fetchCountries()
        
        return []
    }
    
    private func fetchCountries() {
        guard countriesList.isEmpty else {
            return
        }
        
        restCountriesFetcher.getCurrenciesList { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data): self.countriesList = data
                case .failure(_): return
                }
            }

        }
    }
    
    private func fetchFixer() {
        
    }
    
}
