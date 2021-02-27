//
//  ExchangeViewModel.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 27/02/2021.
//

import SwiftUI

final class ExchangeViewModel: ObservableObject {
    
    @Published var currencyOne: Currency?
    @Published var currencyTwo: Currency?
    @Published var result = ""
    @Published var error = ""
    
    private var formatter = NumberFormatter()
    private var fixer = FixerFetcher()
    
    
    func makeCalcul(amount: String) {
        guard let amount = Double(amount) else {
            error = "error"
            return
        }
        fixer.calculExchange(of: amount, from: currencyTwo!.code!, to: currencyTwo!.code!) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error): self.error = error.localizedDescription
                case .success(let toAmount):
                    self.formatter.numberStyle = .currency
                    self.formatter.locale = Locale.current
                    self.result = self.formatter.string(from: NSNumber(value: toAmount))!
                }
            }
            
        }
    }
    
}
