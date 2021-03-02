//
//  View+UIApplication.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 02/03/2021.
//

import SwiftUI

extension View {
    
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
