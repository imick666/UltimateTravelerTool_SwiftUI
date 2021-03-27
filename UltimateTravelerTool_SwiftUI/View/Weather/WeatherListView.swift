//
//  WeatherListView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 27/03/2021.
//

import SwiftUI

struct WeatherListView: View {
    
    @ObservedObject var viewModel: WeatherListViewModel
    
    init() {
        self.viewModel = WeatherListViewModel()
    }
    
    var body: some View {
        NavigationView {
            
            List {
                ForEach(viewModel.weathers) { weather in
                    if viewModel.locaWeather != nil {
                        WeatherCellView(viewModel: viewModel.locaWeather!)
                    }
                    
                    WeatherCellView(viewModel: weather)

                }
            }
            .listStyle(PlainListStyle())
            
            .navigationTitle("Weather")
            .toolbar(content: {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "magnifyingglass")
                })
            })
        }
        .onAppear(perform: {
            viewModel.getUserWeather()
        })
    }
}

struct WeatherListView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherListView()
    }
}
