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
    @Published var countriesList = [RestcountriesResponse]()
    @Published var currenciesList = [Currency]()
    
    private var restCountriesFetcher = RestcountriesFetcher()
    private var fixerFetcher = FixerFetcher()
    private var fixerResult: FixerResponse?
    private var formatter = NumberFormatter()
    
    
    
    // MARK: - Init
    
    init() {
        fetchFixer()
//        fetchCountries()
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
    
    func getCountries() {
        guard countriesList.isEmpty else { return }
        restCountriesFetcher.getCountries { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(_): return
                case .success(let data): self.countriesList = data
                }
            }
        }
    }
    
    func getCurrecnies() {
        guard currenciesList.isEmpty else { return }
        
        restCountriesFetcher.getCurrencies { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(_): return
                case .success(let data): self.currenciesList = data
                }
            }
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
    
    
    
}
