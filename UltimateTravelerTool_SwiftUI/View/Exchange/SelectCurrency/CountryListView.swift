//
//  CountryListView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 28/02/2021.
//

import SwiftUI

struct CountryListView: View {
    
    @ObservedObject var viewModel: ExchangeViewModel
    var didSelect: (Currency) -> Void
    
    var body: some View {
        List {
            ForEach(viewModel.countriesList) { country in
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
        CountryListView(viewModel: ExchangeViewModel()) { _ in
            
        }
    }
}
