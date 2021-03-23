//
//  CurrentWeatherView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 23/03/2021.
//

import SwiftUI

struct CurrentWeatherView: View {
    @State var weather: CurrentWeatherViewModel
    @Binding var height: CGFloat
    @Binding var opacity: Double
    @Binding var isMinimized: Bool
    @Binding var yOffset: CGFloat
    
    var body: some View {
        
        VStack {
            Text("Montpellier")
                .font(.largeTitle)
            Text(weather.description)
                .font(.body)

            VStack {
                Text(weather.temp)
                    .font(.system(size: 70))
                    .fontWeight(.thin)
                
                HStack {
                    Text("Max. \(weather.maxTemp)")
                    Text("Min. \(weather.minTemp)")
                }
                .font(.body)
            }
            .opacity(opacity)
            
        }
        .foregroundColor(.white)
        .frame(height: height)
        .offset(x: 0, y: yOffset)
        
    }
}

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView(weather: WeatherViewModel.placeholder.current, height: .constant(250), opacity: .constant(1), isMinimized: .constant(false), yOffset: .constant(0))
            .background(Color.blue)
    }
}
