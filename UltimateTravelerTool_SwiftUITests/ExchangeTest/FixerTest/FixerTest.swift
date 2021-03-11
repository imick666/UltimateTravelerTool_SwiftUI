//
//  FixerTest.swift
//  UltimateTravelerTool_SwiftUITests
//
//  Created by mickael ruzel on 26/02/2021.
//

import XCTest
import Combine
@testable import UltimateTravelerTool_SwiftUI

class FixerTest: XCTestCase {
    
    // MARK: - Properties

    let expectation = XCTestExpectation(description: "Wait for queue")
    var mokeHttpSession: MokeHTTPSession!
    var httpRequest: HTTPRequestHelper {
        return HTTPRequestHelper(session: mokeHttpSession)
    }
    var fixerFetcher: FixerFetcher {
        return FixerFetcher(httpHelper: httpRequest)
    }

    // MARK: - Tests

    func testBadData() {
        mokeHttpSession = MokeHTTPSession(data: FixerFakeResponse(), responseType: .badData)

        
        _ = fixerFetcher.getRates()
            .sink(receiveCompletion: { error in
                XCTAssertEqual(error, .failure(.parsing))
                self.expectation.fulfill()
            }, receiveValue: { _ in })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testBadResponse() {
        mokeHttpSession = MokeHTTPSession(data: FixerFakeResponse(), responseType: .badResponse)
        
        _ = fixerFetcher.getRates()
            .sink(receiveCompletion: { (completion) in
                guard case .failure(let error) = completion else {
                    XCTFail()
                    return
                }
                self.expectation.fulfill()
                XCTAssertEqual(error, .badResponse)
            }, receiveValue: { _ in })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testAllGood() {
        mokeHttpSession = MokeHTTPSession(data: FixerFakeResponse(), responseType: .goddData)
        
        _ = fixerFetcher.getRates()
            .sink(receiveCompletion: { completion in
                guard case .finished = completion else {
                    XCTFail()
                    return
                }
                self.expectation.fulfill()
            }, receiveValue: { value in
                XCTAssertNotNil(value)
            })
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testError() {
        mokeHttpSession = MokeHTTPSession(data: FixerFakeResponse(), responseType: .error)
        
        _ = fixerFetcher.getRates()
            .sink(receiveCompletion: { (completion) in
                guard case .failure(let error) = completion else {
                    XCTFail()
                    return
                }
                self.expectation.fulfill()
                XCTAssertEqual(error, .otherError)
            }, receiveValue: { _ in })
        wait(for: [expectation], timeout: 0.01)
    }
    
}
