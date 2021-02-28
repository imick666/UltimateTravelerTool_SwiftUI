//
//  ContentView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 23/02/2021.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedTab = 0
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                ExchangeView(viewModel: ExchangeViewModel())
                    .tabItem {
                        Text("Exchange")
                    }.tag(0)
                Text("Weather View")
                    .tabItem {
                        Text("Weather")
                    }.tag(1)
                Text("Translate View")
                    .tabItem {
                        Text("Translate")
                    }.tag(2)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
