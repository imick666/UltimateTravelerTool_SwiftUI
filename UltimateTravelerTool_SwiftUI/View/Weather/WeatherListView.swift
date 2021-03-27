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
            List(viewModel.weathers) { weather in
                WeatherCellView(viewModel: weather)
            }
            
            .navigationTitle("Weather")
            .toolbar(content: {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "magnifyingglass")
                })
            })
        }
    }
}

struct WeatherListView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherListView()
    }
}
