//
//  WeatherCell.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 16/03/2021.
//

import SwiftUI

struct WeatherCell: View {
    
    @ObservedObject var viewModel: WeatherCellViewModel
    
    private var currentWather: CurrentWeatherViewModel {
        return viewModel.weather.current
    }
    
    var body: some View {
        NavigationLink(
            destination: WeatherDetailView(viewModel: WeatherDetailViewModel(weather: WeatherViewModel.placeholder)),
            label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text("hello World!")
                            .font(.title2)
                            .foregroundColor(.black)
                        Text(currentWather.description)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    HStack {
                        Text(currentWather.temp)
                        Image(systemName: currentWather.iconName)
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(height: 50)
                            
                    }
                    .padding(.trailing)
                }
            })
    }
}

struct WeatherCell_Previews: PreviewProvider {
    static var previews: some View {
        WeatherCell(viewModel: WeatherCellViewModel(weather: WeatherViewModel.placeholder))
            .previewLayout(.sizeThatFits)
    }
}
