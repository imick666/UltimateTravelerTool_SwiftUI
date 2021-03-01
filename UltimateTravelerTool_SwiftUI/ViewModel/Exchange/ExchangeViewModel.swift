//
//  ExchangeViewModel.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 28/02/2021.
//

import SwiftUI

final class ExchangeViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var amount = ["", ""] {
        didSet {
            print(amount)
        }
    }
    @Published var currencies: [Currency?] = [nil, nil] {
        didSet {
            print(currencies)
        }
    }
    
    @Published var numberOfCurrencies = 2
    
    private var restCountriesFetcher = RestcountriesFetcher()
    private var fixerFetcher = FixerFetcher()
    private var restCountriesResult = [RestcountriesResponse]()
    private var rateList: FixerResponse?
    
    var countriesList: [RestcountriesResponse] {
        fetchCountries()
        return sortCountries()
    }
    var currenciesList: [Currency] {
        fetchCountries()
        return sortCurrencies()
    }
    
    // MARK: - Methodes
    
    func plusCurrency() {
        numberOfCurrencies += 1
        amount.append("")
        currencies.append(nil)
    }
    
    func lessCurrency() {
        guard numberOfCurrencies > 2 else { return }
        numberOfCurrencies -= 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.amount.removeLast()
            self.currencies.removeLast()
        }
    }
    
    
    private func fetchCountries() {
        guard restCountriesResult.isEmpty else {
            return
        }
        
        restCountriesFetcher.getCurrenciesList { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data): self.restCountriesResult = data
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
        restCountriesResult.forEach { country in
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
        
        restCountriesResult.forEach { country in
            for currency in country.currencies where !result.contains(where: { $0.code == currency.code }){
                var currency = currency
                currency.id = UUID()
                result.append(currency)
            }
        }
        
        return result.sorted(by: {$0.name! < $1.name! })
    }
    
}
