//
//  WeaherCellView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 27/03/2021.
//

import SwiftUI

struct WeatherCellView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    
    @State private var sheetIsPresented = false
    var body: some View {
        Button(action: { self.sheetIsPresented.toggle()}) {
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.city)
                        .font(.headline)
                    Text(viewModel.current.description)
                        .font((.subheadline))
                        .foregroundColor(.secondary)
                }
                .padding(.leading)
                
                Spacer()
                
                HStack {
                    Text(viewModel.current.temp)
                        .font(.headline)
                        .fontWeight(.medium)
                    Image(systemName: viewModel.current.iconName)
                        .renderingMode(.original)
                        .font(.system(size: 30))
                }
                .padding(.trailing)
            }
        }
        .padding(.vertical, 8)
        .sheet(isPresented: $sheetIsPresented, content: {
            WeatherDetailView(viewModel: viewModel)
        })
    }
}

struct WeaherCellView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherCellView(viewModel: WeatherViewModel.placeholder)
            .previewLayout(.sizeThatFits)
    }
}
