//
//  ExchangeViewModel.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 28/02/2021.
//

import SwiftUI

final class ExchangeViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var amourOne = ""
    @Published var currencyOne: Currency?
    @Published var amountTwo = ""
    @Published var currencyTwo: Currency?
    
    private var restCountriesFetcher = RestcountriesFetcher()
    private var fixerFetcher = FixerFetcher()
    private var countriesList = [RestcountriesResponse]()
    private var rateList: FixerResponse?
    
    var countries: [RestcountriesResponse] {
        fetchCountries()
        return sortCountries()
    }
    var currencies: [Currency] {
        fetchCountries()
        return sortCurrencies()
    }
    
    // MARK: - Methodes
    
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
        guard rateList == nil else {
            return
        }
        
        
    }
    
    private func sortCountries() -> [RestcountriesResponse] {
        var result = [RestcountriesResponse]()
        countriesList.forEach { country in
            var country = country
            country.id = UUID()
            for (index, currency) in country.currencies.enumerated() {
                var currency = currency
                currency.id = UUID()
                country.currencies[index] = currency
            }
            country.currencies.removeAll(where: { $0.code == nil })
            country.currencies.removeAll(where: {$0.name == nil })
            country.currencies.sort(by: {$0.name! < $1.name! })
            result.append(country)
        }
        
        return result.sorted(by: {$0.name < $1.name })
    }
    
    private func sortCurrencies() -> [Currency] {
        var result = [Currency]()
        
        countriesList.forEach { country in
            for currency in country.currencies where !result.contains(where: { $0.code == currency.code }){
                var currency = currency
                currency.id = UUID()
                result.append(currency)
            }
        }
        
        return result.sorted(by: {$0.name! < $1.name! })
    }
    
}
