//
//  SearchBar.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 12/03/2021.
//

import SwiftUI


struct SearchBar: UIViewRepresentable {
    final class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var searchTerms: String
        
        init(searchTerms: Binding<String>) {
            self._searchTerms = searchTerms
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            searchTerms = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    typealias UIViewType = UISearchBar
    
    @Binding var searchTerms: String
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "search currency"
        
        return searchBar
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(searchTerms: $searchTerms)
    }

    
    func updateUIView(_ uiView: UISearchBar, context: Context) { }
    
    
    
    
}
