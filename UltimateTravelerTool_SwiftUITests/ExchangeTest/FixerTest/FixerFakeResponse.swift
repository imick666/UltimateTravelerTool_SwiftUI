//
//  FixerFakeResponse.swift
//  UltimateTravelerTool_SwiftUITests
//
//  Created by mickael ruzel on 26/02/2021.
//

import Foundation
import Combine
@testable import UltimateTravelerTool_SwiftUI

final class FixerFakeResponse: FakeData {
    
    var goodData: Data {
        let bundle = Bundle(for: FixerFakeResponse.self)
        let url = bundle.url(forResource: "Fixer", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    var badData: Data {
        let data = "hello".data(using: .utf8)
        return try! JSONEncoder().encode(data)
    }
}
