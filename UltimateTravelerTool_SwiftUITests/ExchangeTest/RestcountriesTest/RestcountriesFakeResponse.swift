//
//  RestcountriesFakeResponse.swift
//  UltimateTravelerTool_SwiftUITests
//
//  Created by mickael ruzel on 26/02/2021.
//

import Foundation

final class RestcountriesFakeReponse: FakeData {
    
    
    var goodData: Data {
        let bundle = Bundle(for: RestcountriesFakeReponse.self)
        let url = bundle.url(forResource: "Restcountries", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    var badData: Data {
        let data = "hello".data(using: .utf8)
        let json = try! JSONEncoder().encode(data)
        return json
    }
    
}
