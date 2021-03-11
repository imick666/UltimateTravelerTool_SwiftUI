//
//  CurrencyView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 28/02/2021.
//

import SwiftUI

struct CurrencyView: View {
    
    @ObservedObject var viewModel: ExchangeViewModel
    @State var selectCurrencyIdActive = false
    var id: Int
    @State var isEditing = false
    
    var body: some View {
        VStack(alignment: .center) {
            
            Spacer()
            
            TextField("0.00", text: $viewModel.amounts[id], onEditingChanged: { (changed) in
                isEditing = changed
            })
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .keyboardType(.decimalPad)
            
            NavigationLink(
                destination: SelectCurrencyView(viewModel: viewModel, id: id),
                isActive: $selectCurrencyIdActive,
                label: {
                    Text(viewModel.currencies[id]?.code ?? "Select a currency")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(minWidth: 150)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Capsule())
                })
            
            Spacer()
        }
        .onChange(of: viewModel.amounts[id], perform: { _ in
            guard isEditing else { return }
            viewModel.executeExchange(for: id)
        })
        
    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView(viewModel: ExchangeViewModel(), id: 0)
    }
}
