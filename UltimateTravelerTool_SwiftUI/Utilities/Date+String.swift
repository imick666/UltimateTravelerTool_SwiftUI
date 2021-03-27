//
//  Date+String.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 17/03/2021.
//

import Foundation

extension Int {
    
    enum ReturnStyle: String {
        case day = "EEEE"
        case hour = "HH"
        case hourMinutes = "HH:mm"
    }
    
    func dateString(timeOffset: Int, returnStyle: ReturnStyle) -> String {

        // For final App
//        let now = Date().addingTimeInterval(Double(timeOffset))
        
        let now = Date(timeIntervalSince1970: 1615917960).addingTimeInterval(Double(timeOffset))
        
        let formatter = DateFormatter()
        formatter.dateFormat = returnStyle.rawValue
        let timeZone = TimeZone(secondsFromGMT: timeOffset)
        formatter.timeZone = timeZone!
        
        let date = Date(timeIntervalSince1970: Double(self))
        
        let interval = Int(date.timeIntervalSince(now))
        
        if interval < 3600 && returnStyle == .hour { return "Now" }
        else if interval < 86400 && returnStyle == .day { return "Today" }
        else {
            switch returnStyle {
            case .day, .hourMinutes: return formatter.string(from: date)
            case.hour: return formatter.string(from: date) + " h"
            }
         }
    }
}
