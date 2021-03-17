//
//  WeatherCell.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 16/03/2021.
//

import SwiftUI

struct WeatherCell: View {
    
    @ObservedObject var viewModel: WeatherCellViewModel
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text("hello World!")
                Spacer()
                Text(viewModel.weather.current.description)
            }
            .padding(.leading)
            
            Spacer()
            
            HStack {
                Text(viewModel.weather.current.temp)
                viewModel.weather.current.icon
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
            }
            .padding(.trailing)
        }
        
    }
}

struct WeatherCell_Previews: PreviewProvider {
    static var previews: some View {
        WeatherCell(viewModel: WeatherCellViewModel(weather: WeatherViewModel.placeholder))
            .previewLayout(.sizeThatFits)
            .frame(height: 50)
    }
}
