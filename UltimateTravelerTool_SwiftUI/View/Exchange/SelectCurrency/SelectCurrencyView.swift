//
//  SelectCurrencyView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 27/02/2021.
//

import SwiftUI

struct SelectCurrencyView: View {
    @ObservedObject var viewModel = SelectCurrencyViewModel()
    @State var selectSort = 0
    
    var body: some View {
        Picker("", selection: $selectSort) {
            Text("By Countries").tag(0)
            Text("By Code").tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
        .navigationTitle("Select a currency")
        
        if selectSort == 0 {
            CountryListView(countries: viewModel.countries)
        } else {
            CurrencyListView(currencies: viewModel.currencies)
        }
    }
}

struct SelectCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        SelectCurrencyView()
    }
}
