//
//  IconFakeData.swift
//  UltimateTravelerTool_SwiftUITests
//
//  Created by mickael ruzel on 17/03/2021.
//

import Foundation

final class IconFakeData: FakeData {
    
    var goodData: Data {
        let bundle = Bundle(for: IconFakeData.self)
        let url = bundle.url(forResource: "icon", withExtension: "png")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    var badData: Data {
        return "bad".data(using: .utf8)!
    }
    
}
