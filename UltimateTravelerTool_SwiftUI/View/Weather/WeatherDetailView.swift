//
//  WeatherDetailView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 27/03/2021.
//

import SwiftUI

struct WeatherDetailView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: WeatherViewModel
    
    private var current: CurrentWeatherViewData {
        return viewModel.current
    }
    private var hourly: [HourlyWeatherViewData] {
        return viewModel.hourly
    }
    private var daily: [DailyWeatherViewData] {
        return viewModel.daily
    }
    
    private var currentWeatherView: some View {
        VStack {
            Text(viewModel.city)
                .font(.title)
            Text(current.description)
                .font(.body)
            Text(current.temp)
                .font(.system(size: 70))
                .fontWeight(.thin)
                .padding()
            HStack {
                Text("Min. \(current.minTemp)")
                Text("Max. \(current.maxTemp)")
            }
            .font(.body)
        }
    }
    
    private var hourlyWeatherView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(hourly) { hour in
                    VStack {
                        Text(hour.hour)
                        Image(systemName: hour.iconImage)
                            .renderingMode(.original)
                            .font(.system(size: 30))
                            .frame(height: 20)
                            .padding(.vertical)
                        Text(hour.temp)
                    }
                    .padding(.horizontal)
                    
                }
            }
        }
    }
    
    private var dailyWeatherView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                ForEach(viewModel.daily) { day in
                    HStack {
                        Text(day.day)
                            .frame(width: 100)
                            .multilineTextAlignment(.leading)
                            
                        Spacer()
                        
                        Image(systemName: day.iconImage)
                            .renderingMode(.original)
                            .font(.system(size: 25))
                        
                        Spacer()
                        
                        HStack {
                            Text(day.minTemp)
                                .frame(width: 35)
                            Text(day.maxTemp)
                                .frame(width: 35)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
            }
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            currentWeatherView
            
            Divider()
                .background(Color.white)
            
            hourlyWeatherView
            
            Divider()
                .background(Color.white)
            
            dailyWeatherView
            
        }
        .padding(.top)
        .background(Color.blue.ignoresSafeArea())
        .foregroundColor(.white)
        
    }
}

// MARK: - Preview

struct WeatherDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailView(viewModel: WeatherViewModel.placeholder)
    }
}
