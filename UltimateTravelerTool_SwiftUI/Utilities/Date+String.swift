//
//  Date+String.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 17/03/2021.
//

import Foundation

extension Date {
    
    var day: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
    
    var hours: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        
        return formatter.string(from: self)
    }
    
}
