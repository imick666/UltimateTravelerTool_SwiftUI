//
//  WeatherDteailView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 16/03/2021.
//

import SwiftUI

struct WeatherDetailView: View {
    
    @ObservedObject var viewModel: WeatherDetailViewModel
    
    @State var currentHeight: CGFloat = 250
    @State var curretnOpacity: Double = 1
    @State var currentIsMinimized = false
    @State var currentYOffset: CGFloat = 0
    
    private var hourly: [HourlyWeatherViewModel] {
        return viewModel.hourly
    }
    private var current: CurrentWeatherViewModel {
        return viewModel.current
    }
    private var daily: [DailyWeatherViewModel] {
        return viewModel.daily
    }
    
    var body: some View {
        GeometryReader(content: { geo in
            VStack {
                
                CurrentWeatherView(weather: current, height: $currentHeight, opacity: $curretnOpacity, isMinimized: $currentIsMinimized, yOffset: $currentYOffset)

                Divider()
                    .frame(height: 1)
                    .background(Color.white)
                
                HourlyWeatherView(weather: hourly)
                
                Divider()
                    .frame(height: 1)
                    .background(Color.white)
                
                ScrollView(.vertical, showsIndicators: false, content: {
                    DailyWeatherView(weather: daily)
                    
                })
                .disabled(!currentIsMinimized)
                
                Spacer()
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.blue.ignoresSafeArea())
            .gesture(DragGesture()
                        .onChanged({ value in
                            let translationHeight = value.translation.height
                            if currentIsMinimized && translationHeight.isLess(than: 0) { return }
                            withAnimation(.linear, {
                                self.currentHeight = currentIsMinimized ? 50 + translationHeight : 250 + translationHeight
                                self.curretnOpacity = currentIsMinimized ? Double(0 + (translationHeight / 200)) : Double( 1 + (translationHeight / 200))
                                self.currentYOffset = currentIsMinimized ? 75 - (translationHeight * 0.4) : 0 - (translationHeight * 0.4)
                                
                            })
                        })
                        .onEnded({ value in
                            withAnimation(.linear, {
                                if self.currentHeight < 250 {
                                    self.currentHeight = 50
                                    self.curretnOpacity = 0
                                    self.currentYOffset = 50
                                    self.currentIsMinimized = true
                                }
                                if self.currentHeight > 250 {
                                    self.currentHeight = 250
                                    self.curretnOpacity = 1
                                    self.currentYOffset = 0
                                    self.currentIsMinimized = false
                                }

                            })
                            
                        })
                    )
        })
    }
}

struct WeatherDteailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WeatherDetailView(viewModel: WeatherDetailViewModel(weather: WeatherViewModel.placeholder))
        }
    }
}
