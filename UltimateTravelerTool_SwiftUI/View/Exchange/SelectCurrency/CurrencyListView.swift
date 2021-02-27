//
//  CurrencyListView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 27/02/2021.
//

import SwiftUI

struct CurrencyListView: View {
    
    var currencies: [Currency]
    
    var body: some View {
        List {
            ForEach(currencies) { currency in
                Button(action: {
                    
                }, label: {
                    CurrencyRowView(currency: currency)
                })
            }
        }
    }
}

struct CurrencyListView_Previews: PreviewProvider {
    static var previews: some View {
        let currency = Currency(id: UUID(), code: "EUR", name: "Euros", symbol: "€")
        CurrencyListView(currencies: [currency, currency, currency, currency, currency])
    }
}
