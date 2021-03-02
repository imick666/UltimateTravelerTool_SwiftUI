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
            ForEach(0 ..< viewModel.numberOfCurrencies) { (index) in
                CurrencyView(viewModel: viewModel, id: index)
                if index != viewModel.numberOfCurrencies - 1 { Divider() }
            }
            
            Spacer()
            
            HStack {
                
                Button(action: {
                    viewModel.lessCurrency()
                }, label: {
                    Text("-")
                })
                .padding()
                .foregroundColor(.secondary)
                .background(Color.gray)
                .clipShape(Circle())
                .padding(.leading)
                
                Spacer()
                
                Button(action: {
                    viewModel.plusCurrency()
                }, label: {
                    Text("+")
                })
                .padding()
                .foregroundColor(.secondary)
                .background(Color.gray)
                .clipShape(Circle())
                .padding(.trailing)
            }
            
        }
        .onTapGesture(perform: {
            self.endEditing()
        })
        
    }
    
}

struct ExchangeView_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeView(viewModel: ExchangeViewModel())
    }
}
