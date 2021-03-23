//
//  HourlyWeatherView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 23/03/2021.
//

import SwiftUI

struct HourlyWeatherView: View {
    
    @State var weather: [HourlyWeatherViewModel]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(weather) { hour in
                    VStack {
                        Text(hour.hour)
                            .font(.body)
                        
                        Spacer()
                        
                        Image(systemName: hour.iconName)
                            .renderingMode(.original)
                            .font(.system(size: 30))

                        
                        Spacer()
                        
                        Text(hour.temp)
                            .font(.body)
                    }
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.white)
                    .frame(height: 100)
                    .padding(.horizontal)

                }

            }
        }
    }
}

struct HourlyWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyWeatherView(weather: WeatherViewModel.placeholder.hourly)
            .background(Color.blue)
    }
}
