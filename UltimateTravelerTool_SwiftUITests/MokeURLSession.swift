//
//  MokeURLSession.swift
//  UltimateTravelerTool_SwiftUITests
//
//  Created by mickael ruzel on 26/02/2021.
//

import Foundation

class MokeURLSession: URLSession {
    
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = MokeDataTask(data: data, response: response, error: error, completionHandler: completionHandler)
        return task
        
    }
}

class MokeDataTask: URLSessionDataTask {
    
    var fakeData: Data?
    var fakeResponse: URLResponse?
    var fakeError: Error?
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    
    init(data: Data?, response: URLResponse?, error: Error?, completionHandler: ((Data?, URLResponse?, Error?) -> Void)?) {
        self.fakeData = data
        self.fakeResponse = response
        self.fakeError = error
        self.completionHandler = completionHandler
    }
    
    override func resume() {
        completionHandler?(fakeData, fakeResponse, fakeError)
    }
    
    override func cancel() { }
}
