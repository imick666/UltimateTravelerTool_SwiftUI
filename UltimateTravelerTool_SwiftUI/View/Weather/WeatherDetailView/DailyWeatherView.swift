//
//  DailyWeatherView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 23/03/2021.
//

import SwiftUI

struct DailyWeatherView: View {
    
    @State var weather: [DailyWeatherViewModel]
    
    var body: some View {
        VStack {
            ForEach(weather) { day in
                HStack {
                    Text(day.day)
                        .font(.body)
                        .foregroundColor(.white)
                        .frame(width: 100, alignment: .leading)
                    
                    Spacer()
                    
                    Image(systemName: day.icon)
                        .renderingMode(.original)
                        .font(.system(size: 25))
                    
                    Spacer()
                    
                    HStack {
                        Text(day.maxTemp)
                            .foregroundColor(.white)
                        
                        Text(day.minTemp)
                            .foregroundColor(.gray)
                    }
                    .font(.body)
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
            }
        }
    }
}

struct DailyWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        DailyWeatherView(weather: WeatherViewModel.placeholder.daily)
            .background(Color.blue)
    }
}
