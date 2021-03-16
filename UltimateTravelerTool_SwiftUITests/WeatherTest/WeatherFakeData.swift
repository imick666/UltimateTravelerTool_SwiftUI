//
//  WeatherFakeData.swift
//  UltimateTravelerTool_SwiftUITests
//
//  Created by mickael ruzel on 16/03/2021.
//

import Foundation

final class WeatherFakeData: FakeData {
    var goodData: Data {
        let bundel = Bundle(for: WeatherFakeData.self)
        let url = bundel.url(forResource: "Weather", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    var badData: Data {
        return "badData".data(using: .utf8)!
    }
}
