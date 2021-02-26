//
//  RestcountriesFakeResponse.swift
//  UltimateTravelerTool_SwiftUITests
//
//  Created by mickael ruzel on 26/02/2021.
//

import Foundation

final class RestcountriesFakeReponse {
    
    var badResponse: HTTPURLResponse? {
        return HTTPURLResponse(url: URL(string: "google.fr")!, statusCode: 500, httpVersion: nil, headerFields: nil)
    }
    
    var goodResponse: HTTPURLResponse? {
        return HTTPURLResponse(url: URL(string: "google.fr")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    }
    
    private final class FakeError: Error { }
    
    var error: Error {
        return FakeError()
    }
    
    var goodData: Data? {
        let bundle = Bundle(for: RestcountriesFakeReponse.self)
        let url = bundle.url(forResource: "Restcountries", withExtension: "json")!
        return try? Data(contentsOf: url)
    }
    
    var badData: Data? {
        let data = "hello".data(using: .utf8)
        let json = try? JSONEncoder().encode(data)
        return json
    }
    
}
