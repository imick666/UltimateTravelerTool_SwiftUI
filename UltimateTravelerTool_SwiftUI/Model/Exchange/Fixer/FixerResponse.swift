//
//  FixerResponse.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 26/02/2021.
//

import Foundation

struct FixerResponse: Codable {
    
    typealias rates = [String: Double]
    
    let success: Bool
    let timestamp: Int
    let base, date: String
    let rates: [String: Double]
}
