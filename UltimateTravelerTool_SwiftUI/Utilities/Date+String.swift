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

        let now = Date()
        let date = Date(timeIntervalSince1970: Double(self))
        
        let calendar = Calendar.current
        let currentDateComponents = calendar.dateComponents(in: TimeZone(secondsFromGMT: timeOffset)!, from: now)
        let dateComponents = calendar.dateComponents(in: TimeZone(secondsFromGMT: timeOffset)!, from: date)
        
        let formatter = DateFormatter()
        formatter.dateFormat = returnStyle.rawValue
        
        if currentDateComponents.hour == dateComponents.hour && returnStyle == .hour { return "Now" }
        else if currentDateComponents.day == dateComponents.day && returnStyle == .day { return "Today" }
        else {
            switch returnStyle {
            case .day, .hourMinutes: return formatter.string(from: date)
            case.hour: return formatter.string(from: date) + " h"
            }
         }
    }
}
