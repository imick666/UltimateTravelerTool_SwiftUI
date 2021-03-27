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
                
                if viewModel.localWeather != nil {
                    WeatherCellView(viewModel: viewModel.localWeather!, isCurrentLocation: true)
                }
                
                ForEach(viewModel.weathers) { weather in
                    WeatherCellView(viewModel: weather)
                }
                .onDelete(perform: { indexSet in
                    viewModel.weathers.remove(atOffsets: indexSet)
                })
                
            }
            
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
            WeatherSearchView(viewModel: WeatherSearchViewModel(localSearchService: viewModel.localSearchService))
        })
    }
}

struct WeatherListView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherListView()
    }
}
