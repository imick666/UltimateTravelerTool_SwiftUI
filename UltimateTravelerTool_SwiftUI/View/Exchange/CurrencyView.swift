//
//  CurrencyView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 27/02/2021.
//

import SwiftUI

struct CurrencyView: View {

    var currency: Currency?
    @State var amount = ""
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            TextField("0.00", text: $amount)
                .padding()
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .font(.largeTitle)
                .keyboardType(.decimalPad)
            
            NavigationLink(
                destination: SelectCurrencyView(),
                label: {
                    Text(currency?.code ?? "Select a currency")
                        .foregroundColor(.white)
                        .font(.title)
                })
                .frame(minWidth: 150)
                .padding()
                .background(Color.blue)
                .clipShape(Capsule())
            
            Spacer()
        }

    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView(currency: nil)
            .previewLayout(.sizeThatFits)
    }
}
