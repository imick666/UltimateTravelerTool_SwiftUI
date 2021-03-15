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
    @State var searchTerms = ""
    var id: Int
    
    var body: some View {
        VStack {
            HStack {
                SearchBar(searchTerms: $searchTerms)
                Button(action: {
                    self.endEditing()
                    self.searchTerms = ""
                }, label: {
                    Text("Cancel")
                })
                .padding(.trailing)
            }
            
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
                CountryListView(viewModel: SelectCoutnryViewModel(restcountries: viewModel.restCountriesFetcher, searchTerms: searchTerms)) { currency in
                    viewModel.currencies[id] = currency
                    presentaion.wrappedValue.dismiss()
                    
                }
                .navigationTitle("Select a country")
            default:
                CurrencyListView(viewModel: SelectCurrencyViewModel(restcountries: viewModel.restCountriesFetcher, searchTerms: searchTerms)) { currency in
                    viewModel.currencies[id] = currency
                    presentaion.wrappedValue.dismiss()
                }
                .navigationTitle("Select a currency")
            }
        }
    }
}

struct SelectCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        SelectCurrencyView(viewModel: ExchangeViewModel(), id: 0)
    }
}
