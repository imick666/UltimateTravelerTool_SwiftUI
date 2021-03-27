//
//  WeatherListView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 27/03/2021.
//

import SwiftUI

struct WeatherListView: View {
    
    @ObservedObject var viewModel: WeatherListViewModel
    
    @State var searchIsShown = false
    
    init() {
        self.viewModel = WeatherListViewModel()
    }
    
    var body: some View {
        NavigationView {
            
            List {
                ForEach(viewModel.weathers) { weather in
                    if viewModel.localWeather != nil {
                        WeatherCellView(viewModel: viewModel.localWeather!, isCurrentLocation: true)
                    }
                    
                    WeatherCellView(viewModel: weather)

                }
            }
            .listStyle(PlainListStyle())
            
            .navigationTitle("Weather")
            .toolbar(content: {
                Button(action: {
                    self.searchIsShown.toggle()
                }, label: {
                    Image(systemName: "magnifyingglass")
                })
            })
        }
        .onAppear(perform: {
            viewModel.getUserWeather()
        })
        .sheet(isPresented: $searchIsShown, content: {
            WeatherSearchView(viewModel: WeatherSearchViewModel())
        })
    }
}

struct WeatherListView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherListView()
    }
}
