//
//  ExchangeViewModel.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 28/02/2021.
//

import SwiftUI
import Combine

final class ExchangeViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var amounts = ["", ""]
    @Published var currencies: [Currency?] = [nil, nil]
    @Published var numberOfCurrencies = 2
    @Published var countriesList = [RestcountriesResponse]()
    @Published var currenciesList = [Currency]()
    @Published var searchTerms: String = ""
    
    private(set) var restCountriesFetcher = RestcountriesFetcher()
    private var exchangeRates = [String: Double]()
    private var fixerFetcher = FixerFetcher()
    private var formatter = NumberFormatter()
    
    private var subscribers = Set<AnyCancellable>()
    
    // MARK: - Init

    init() {
        
        $searchTerms
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
            .sink(receiveValue: { _ in self.sortCountries() })
            .store(in: &subscribers)

    }
    
    // MARK: - Methodes
    
    private func sortCountries() {
        restCountriesFetcher.getCountries(searchTerms: searchTerms)
            .sink { _ in }
                receiveValue: { self.countriesList = $0 }
            .store(in: &subscribers)

    }
    
    func plusCurrency() {
        numberOfCurrencies += 1
        amounts.append("")
        currencies.append(nil)
    }
    
    func lessCurrency() {
        guard numberOfCurrencies > 2 else { return }
        numberOfCurrencies -= 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.amounts.removeLast()
            self.currencies.removeLast()
        }
    }
    
    func executeExchange(for id: Int) {
        guard let amount = Double(amounts[id]) else {
            for (index, _) in amounts.enumerated() where index != id {
                amounts[index] = ""
            }
            return
        }
        
        for (index, currency) in currencies.enumerated() where index != id && currency != nil {
            guard let from = currencies[id]?.code, let to = currency?.code else { return }
            guard let fromRate = exchangeRates[from], let toRate = exchangeRates[to] else { return }
            let result = fixerFetcher.calculExchange(amount, from: fromRate, to: toRate)
            formatter.numberStyle = .currency
            formatter.currencyCode = to
            amounts[index] = formatter.string(for: result)!
        }
    }

    
    private func getExchangeRates() {
        guard exchangeRates.isEmpty else { return }
        
        fixerFetcher.getRates()
            .sink { (completion) in
                switch completion {
                case .finished: break
                case.failure(let error): print(error)
                }
            } receiveValue: { value in
                self.exchangeRates = value
            }
            .store(in: &subscribers)

    }
    
    
}
