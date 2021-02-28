//
//  ExchangeView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 28/02/2021.
//

import SwiftUI

struct ExchangeView: View {
    
    @ObservedObject var viewModel: ExchangeViewModel
    
    var body: some View {
        VStack {
            CurrencyView(viewModel: viewModel, amount: $viewModel.amourOne, currency: $viewModel.currencyOne)
                
            Divider()
            
            CurrencyView(viewModel: viewModel, amount: $viewModel.amountTwo, currency: $viewModel.currencyTwo)
        }
    }
}

struct ExchangeView_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeView(viewModel: ExchangeViewModel())
    }
}
