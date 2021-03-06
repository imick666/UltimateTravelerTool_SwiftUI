//
//  SelectCurrencyView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 28/02/2021.
//

import SwiftUI

struct SelectCurrencyView: View {
    
    @Environment(\.presentationMode) var presentaion
    
    @ObservedObject var viewModel: SelectViewModel
    @State var pickerSelection = 0
    var id: Int
    
    var body: some View {
        VStack {
            SearchBar(searchTerms: $viewModel.searchTerms)
            
            Picker("Sort :", selection: $pickerSelection) {
                Text("By Countries")
                    .tag(0)
                Text("By currencies")
                    .tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Spacer()
            
            switch pickerSelection {
            case 0:
                CountryListView(viewModel: viewModel) { currency in
                    viewModel.exchangeDelegate.didSelectCurrency(currency, for: id)
                    presentaion.wrappedValue.dismiss()
                    
                }
                .navigationTitle("Select a country")
            default:
                CurrencyListView(viewModel: viewModel) { currency in
                    viewModel.exchangeDelegate.didSelectCurrency(currency, for: id)
                    presentaion.wrappedValue.dismiss()
                }
                .navigationTitle("Select a currency")
            }
        }

    }
}

struct SelectCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        SelectCurrencyView(viewModel: SelectViewModel(delegate: ExchangeViewModel()), id: 0)
    }
}
