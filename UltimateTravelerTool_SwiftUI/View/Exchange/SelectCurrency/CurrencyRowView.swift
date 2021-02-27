//
//  SelectCurrencyByCodeRowView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 27/02/2021.
//

import SwiftUI

struct CurrencyRowView: View {
    
    var currency: Currency
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(currency.name ?? "NC")
                    .font(.title2)
                    .foregroundColor(.primary)
                Text(currency.code ?? "NC")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .padding(5)
            
            Spacer()
            
            Text(currency.symbol ?? "")
                .padding()
        }
    }
}

struct SelectCurrencyByCodeRowView_Previews: PreviewProvider {
    static var previews: some View {
        let currency = Currency(code: "EUR", name: "Euros", symbol: "€")
        CurrencyRowView(currency: currency)
            .previewLayout(.sizeThatFits)
    }
}
