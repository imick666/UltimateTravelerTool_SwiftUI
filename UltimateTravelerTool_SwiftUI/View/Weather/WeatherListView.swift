//
//  WeatherView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 16/03/2021.
//

import SwiftUI

struct WeatherListView: View {
    
    @ObservedObject var viewModel: WeatherListViewModel
    
    var body: some View {
        List{
            ForEach(viewModel.weathers) { weather in
                WeatherCell(viewModel: WeatherCellViewModel(weather: weather))
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherListView(viewModel: WeatherListViewModel())
    }
}
