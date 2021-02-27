//
//  SelectedCurrencyRowView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 27/02/2021.
//

import SwiftUI

struct CountryRowView: View {

    var country: RestcountriesResponse
    
    var body: some View {
        if country.currencies.count == 1 {
            singleCurrency
        } else {
            someCurrencies
        }
        
    }
    
    private var singleCurrency: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(country.name)
                    .font(.title2)
                    .foregroundColor(.primary)
                Text(country.currencies[0].name ?? "NC")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .padding(5)
            
            Spacer()
            
            Text(country.currencies[0].symbol ?? "")
                .padding()
        }
    }
    
    private var someCurrencies: some View {
        NavigationLink(
            destination: CurrencyListView(currencies: country.currencies),
            label: {
                VStack(alignment: .leading) {
                    Text(country.name)
                        .font(.title2)
                        .foregroundColor(.primary)
                    Text("multiple")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding(5)
                
                Spacer()
            })
    }
}

struct SelectedCurrencyRowView_Previews: PreviewProvider {
    static var previews: some View {
        let curreny = RestcountriesResponse(currencies: [Currency(code: "EUR", name: "Euros", symbol: "€")], translations: Translations(br: "", pt: "", nl: "", hr: "", fa: "", de: "", es: "", fr: "France", ja: "", it: "Francia"), name: "France")
        CountryRowView(country: curreny)
            .previewLayout(.sizeThatFits)
    }
}
