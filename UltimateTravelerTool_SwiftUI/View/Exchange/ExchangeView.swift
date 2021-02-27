//
//  ExchangeView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 27/02/2021.
//

import SwiftUI

struct ExchangeView: View {
    
    @StateObject var exchangeViewModel = ExchangeViewModel()
    
    var body: some View {
        VStack {
            
            CurrencyView()
            
            ZStack {
                Divider()
            }
            
            
            CurrencyView()
        }
    }
}

struct ExchangeView_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeView()
    }
}
