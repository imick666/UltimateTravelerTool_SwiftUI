//
//  HTTPError.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 26/02/2021.
//

import Foundation

enum HTTPError: Error {
    case badResponse
    case badUrl
    case noData
    case parsing
}
