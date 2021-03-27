//
//  Double+String.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 26/03/2021.
//

import Foundation

extension Double {
    var roundedTemp: String {
        let formatter = NumberFormatter()
        formatter.allowsFloats = false
        return (formatter.string(for: self) ?? "--") + "°"
    }
    
}
