//
//  CurrencyListView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 28/02/2021.
//

import SwiftUI

struct CurrencyListView: View {
    
    @ObservedObject var viewModel: SelectCurrencyViewModel
    var didSelect: (Currency) -> Void
    
    var body: some View {
        List {
            ForEach(viewModel.currencies) { currency in
                Button(action: {
                    didSelect(currency)
                }, label: {
                    HStack() {
                        VStack(alignment: .leading) {
                            Text(currency.name!)
                            Text(currency.code!)
                        }
                        Spacer()
                        Text(currency.symbol ?? "")
                    }
                })
            }
        }
    }
}

struct CurrencyListView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyListView(viewModel: SelectCurrencyViewModel(restcountries: RestcountriesFetcher())) { _ in
            
        }
    }
}
