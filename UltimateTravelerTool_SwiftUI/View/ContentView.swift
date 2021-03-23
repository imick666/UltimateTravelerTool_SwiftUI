//
//  ContentView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 23/02/2021.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedTab = 0
    @State var title = ""
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                ExchangeView(viewModel: ExchangeViewModel())
                    .tabItem {
                        Text("Exchange")
                    }.tag(0)
                    .navigationBarHidden(true)
                WeatherListView(viewModel: WeatherListViewModel())
                    .tabItem {
                        Text("Weather")
                    }.tag(1)
                Text("Translate View")
                    .tabItem {
                        Text("Translate")
                    }.tag(2)
            }
            .onChange(of: selectedTab, perform: { value in
                switch value {
                case 1: self.title = "Weather"
                default: self.title = ""
                }
            })
            .navigationTitle(title)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
