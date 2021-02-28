//
//  SelectCurrencyView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 28/02/2021.
//

import SwiftUI

struct SelectCurrencyView: View {
    
    @Environment(\.presentationMode) var presentaion
    
    @ObservedObject var viewModel: ExchangeViewModel
    @State var pickerSelection = 0
    
    var body: some View {
        VStack {
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
                CountryListView(countries: viewModel.countries) { currency in
                    presentaion.wrappedValue.dismiss()
                }
                .navigationTitle("Select a country")
            default:
                CurrencyListView(currencies: viewModel.currencies) { currency in
                    presentaion.wrappedValue.dismiss()
                }
                .navigationTitle("Select a currency")
            }
        }
    }
}

struct SelectCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        SelectCurrencyView(viewModel: ExchangeViewModel())
    }
}
