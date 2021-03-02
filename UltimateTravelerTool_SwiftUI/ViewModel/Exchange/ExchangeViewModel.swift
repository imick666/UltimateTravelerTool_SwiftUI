//
//  ExchangeViewModel.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 28/02/2021.
//

import SwiftUI

final class ExchangeViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var amount = ["", ""]
    @Published var currencies: [Currency?] = [nil, nil]
    @Published var numberOfCurrencies = 2
    
    private var restCountriesFetcher = RestcountriesFetcher()
    private var fixerFetcher = FixerFetcher()
    private var restCountriesResult = [RestcountriesResponse]()
    private var fixerResult: FixerResponse?
    private var formatter = NumberFormatter()
    
    var countriesList: [RestcountriesResponse] {
        return sortCountries()
    }
    var currenciesList: [Currency] {
        return sortCurrencies()
    }
    
    // MARK: - Init
    
    init() {
        fetchFixer()
        fetchCountries()
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
    
    
    func executeExchange(for id: Int) {
        guard let amount = Double(amount[id]) else {
            self.amount.enumerated().forEach { index, _ in
                self.amount[index] = ""
            }
            return
        }
        
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        
        for (index, currency) in currencies.enumerated() where index != id && currency != nil {
            
            guard let fromCode = currencies[id]?.code, let toCode = currency?.code else {
                print("code invalide")
                return
            }
            guard let fromRate = fixerResult?.rates[fromCode], let toRate = fixerResult?.rates[toCode] else {
                print("rate invalide")
                return
            }
            
            let amountInEuro = amount / fromRate
            
            let result = amountInEuro * toRate
            
            formatter.currencyCode = currency?.code
            
            self.amount[index] = formatter.string(for: result)!
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
        guard fixerResult == nil else {
            return
        }
        
        fixerFetcher.getExchanges { (result) in
            DispatchQueue.main.async {
                switch result {
                case.failure(_): return
                case .success(let data): self.fixerResult = data
                }
            }
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
