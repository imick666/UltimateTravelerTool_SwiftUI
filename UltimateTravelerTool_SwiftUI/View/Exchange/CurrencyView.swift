//
//  CurrencyView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 28/02/2021.
//

import SwiftUI

struct CurrencyView: View {
    
    @ObservedObject var viewModel: ExchangeViewModel
    @Binding var amount: String
    @Binding var currency: Currency?
    @State var selectCurrencyIdActive = false
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            TextField("0.00", text: $amount)
                .multilineTextAlignment(.center)
                .font(.largeTitle)
//            NavigationLink(
//                destination: SelectCurrencyView(viewModel: viewModel),
//                label: {
//                    Text(currency?.code ?? "Select a currency")
//                        .font(.title2)
//                        .foregroundColor(.white)
//                        .frame(minWidth: 150)
//                        .padding()
//                        .background(Color.blue)
//                        .clipShape(Capsule())
//                        
//                })
            
            NavigationLink(
                destination: SelectCurrencyView(viewModel: viewModel),
                isActive: $selectCurrencyIdActive,
                label: {
                    Text(currency?.code ?? "Select a currency")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(minWidth: 150)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Capsule())
                })
            
            Spacer()
        }
    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView(viewModel: ExchangeViewModel(), amount: .constant(""), currency: .constant(nil))
    }
}
