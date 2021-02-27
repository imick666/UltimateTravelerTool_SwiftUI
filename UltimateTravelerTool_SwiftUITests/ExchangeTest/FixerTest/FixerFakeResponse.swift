//
//  FixerFakeResponse.swift
//  UltimateTravelerTool_SwiftUITests
//
//  Created by mickael ruzel on 26/02/2021.
//

import Foundation

final class FixerFakeResponse {
    
    var badResponse: HTTPURLResponse? {
        return HTTPURLResponse(url: URL(string: "ggogle.fr")!, statusCode: 500, httpVersion: nil, headerFields: nil)
    }
    
    var goodResponse: HTTPURLResponse? {
        return HTTPURLResponse(url: URL(string: "ggogle.fr")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    }
    
    final class FakeError: Error { }
    
    var error = FakeError()
    
    var goodData: Data? {
        let bundle = Bundle(for: FixerFakeResponse.self)
        let url = bundle.url(forResource: "Fixer", withExtension: "json")!
        return try? Data(contentsOf: url)
    }
    
    var badData: Data? {
        let data = "hello".data(using: .utf8)
        return try? JSONEncoder().encode(data)
    }
    
}
