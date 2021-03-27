//
//  WeatherSearchView.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 27/03/2021.
//

import SwiftUI

struct WeatherSearchView: View {
    
    @ObservedObject var viewModel: WeatherSearchViewModel
    
    var body: some View {
        SearchBar(searchTerms: $viewModel.serachTerms)
        
        if !viewModel.result.isEmpty {
            List(viewModel.result, id: \.self) { suggestion in
                VStack(alignment: .leading) {
                    Text(suggestion.title)
                    Text(suggestion.subtitle)
                        .foregroundColor(.secondary)
                }
            }
        } else {
            Spacer()
            
            Text("No Resut")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

struct WeatherSearchView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherSearchView(viewModel: WeatherSearchViewModel())
    }
}
