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
    
    @Published var amount = ["", ""]
    @Published var currencies: [Currency?] = [nil, nil]
    @Published var numberOfCurrencies = 2
    @Published var countriesList = [RestcountriesResponse]()
    @Published var currenciesList = [Currency]()
    
    private var restCountriesFetcher = RestcountriesFetcher()
    private var fixerFetcher = FixerFetcher()
    private var formatter = NumberFormatter()
    
    private var token = Set<AnyCancellable>() {
        didSet {
            print(token)
        }
    }
    
    // MARK: - Init

    
    
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
        guard let amount = Double(amount[id]), let from = currencies[id] else {
            for (index, _) in self.amount.enumerated() {
                self.amount[index] = ""
            }
            return
        }
        
        for (index, to) in self.currencies.enumerated() where index != id && to != nil {
            fixerFetcher.calculeExchange(amount, from: from, to: to!)
                .receive(on: DispatchQueue.main)
                .sink { (completion) in
                    switch completion {
                    case .finished:
                        print("observed has finish")
                    case .failure(_): return
                    }
                } receiveValue: { (exchangeAmount) in
                    self.formatter.numberStyle = .currency
                    self.formatter.locale = Locale.current
                    self.formatter.currencyCode = to?.code!
                    guard let stringExhcnage = self.formatter.string(for: exchangeAmount) else { return }
                    self.amount[index] = stringExhcnage
                }
                .store(in: &token)
        }
        
    }
}
