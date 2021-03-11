//
//  MokeURLSession.swift
//  UltimateTravelerTool_SwiftUITests
//
//  Created by mickael ruzel on 26/02/2021.
//

import Foundation
@testable import UltimateTravelerTool_SwiftUI
import Combine

protocol FakeData {
    var goodData: Data { get }
    var badData: Data { get }
}

final class MokeHTTPSession: HTTPSession {
    
    enum ResponseType {
        case badResponse, error, badData, goddData
    }
    
    // MARK: - Properties
    
    private var data: FakeData
    private var response: URLResponse {
        switch responseType {
        case .badResponse: return badResponse
        default: return goodResponse
        }
    }
    private var error = URLError(.unknown)
    private var responseType: ResponseType
    
    private var badResponse: HTTPURLResponse {
        return HTTPURLResponse(url: URL(string: "https://www.google.fr")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    }
    
    private var goodResponse: HTTPURLResponse {
        return HTTPURLResponse(url: URL(string: "https://www.google.fr")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    // MARK: Init
    
    init(data: FakeData, responseType: ResponseType) {
        self.responseType = responseType
        self.data = data
    }
    
    // MARK: - Methodes
    
    func request(url: URL) -> AnyPublisher<Output, Failure> {
        switch responseType {
        case.badResponse:
            return Just((Data(), response))
                .setFailureType(to: URLError.self)
                .eraseToAnyPublisher()
        case .error:
            return Fail.init(outputType: Output.self, failure: error)
                .eraseToAnyPublisher()
        case .badData:
            return Just((data.badData, response))
                .setFailureType(to: URLError.self)
                .eraseToAnyPublisher()
        case .goddData:
            return Just((data.goodData, response))
                .setFailureType(to: URLError.self)
                .eraseToAnyPublisher()
        }
    }
}
