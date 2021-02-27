//
//  CountryListView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 27/02/2021.
//

import SwiftUI

struct CountryListView: View {
    
    var countries: [RestcountriesResponse]
    
    var body: some View {
        List {
            ForEach(countries) { country in
                if country.currencies.count == 1 {
                    Button(action: {
                        
                    }, label: {
                        CountryRowView(country: country)
                    })
                }
            }
        }
    }
}

struct CountryListView_Previews: PreviewProvider {
    static var previews: some View {
        let country = RestcountriesResponse(id: UUID(), currencies: [Currency(id: UUID(), code: "EUR", name: "Euros", symbol: "€")], translations: Translations(br: "", pt: "", nl: "", hr: "", fa: "", de: "", es: "", fr: "France", ja: "", it: "Francia"), name: "France")
        CountryListView(countries: [country, country, country, country, country])
    }
}
