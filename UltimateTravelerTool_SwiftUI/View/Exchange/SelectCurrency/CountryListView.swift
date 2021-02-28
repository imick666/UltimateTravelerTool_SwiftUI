//
//  CountryListView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 28/02/2021.
//

import SwiftUI

struct CountryListView: View {
    
    var countries: [RestcountriesResponse]
    var didSelect: (Currency) -> Void
    
    var body: some View {
        List {
            ForEach(countries) { country in
                Button(action: {
                    didSelect(country.currencies[0])
                }, label: {
                    HStack() {
                        VStack(alignment: .leading) {
                            Text(country.name)
                            Text(country.currencies[0].name!)
                        }
                        Spacer()
                        Text(country.currencies[0].symbol ?? "")
                    }
                })
            }
        }
    }
}

struct CountryListView_Previews: PreviewProvider {
    static var previews: some View {
        CountryListView(countries: [RestcountriesResponse(id: UUID(), currencies: [Currency(id: UUID(), code: "EUR", name: "Euros", symbol: "€")], translations: Translations(br: "", pt: "", nl: "", hr: "", fa: "", de: "", es: "", fr: "", ja: "", it: ""), name: "France")]) { _ in
            
        }
    }
}
