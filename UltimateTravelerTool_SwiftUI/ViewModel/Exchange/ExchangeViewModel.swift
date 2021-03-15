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
    
    private(set) var restCountriesFetcher = RestcountriesFetcher()
    private var fixerFetcher = FixerFetcher()
    private var formatter = NumberFormatter()
    
    // MARK: - Init

    init() {
        
    }
    
    // MARK: - Methodes
    
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
            guard let from = currencies[id], let to = currency else { return }
            _ = fixerFetcher.executeExchange(amount, from: from, to: to)
                .sink(receiveCompletion: { print($0) }) { (result) in
                    self.formatter.numberStyle = .currency
                    self.formatter.currencyCode = to.code!
                    self.amounts[index] = self.formatter.string(for: result)!
                }
        }
    }
}
