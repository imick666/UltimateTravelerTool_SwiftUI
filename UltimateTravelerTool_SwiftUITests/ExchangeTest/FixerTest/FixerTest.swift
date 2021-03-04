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

    let fakeResponse = FixerFakeResponse()
    let expectation = XCTestExpectation(description: "Wait for queue")
    let currency = Currency(id: nil, code: "EUR", name: nil, symbol: nil)
    var tokens = Set<AnyCancellable>()

    func testBadResponse() {
        let session = MokeURLSession(data: nil, response: fakeResponse.badResponse, error: nil)
        let httpHelper = HTTPHerlper(session: session)
        let fetcher = FixerFetcher(httpHelper: httpHelper)
        
        fetcher.calculeExchange(2, from: currency, to: currency)
            .sink { (completion) in
                switch completion {
                case .finished: XCTFail()
                case .failure(let error):
                    self.expectation.fulfill()
                    XCTAssertEqual(error, .badResponse)
                }
            } receiveValue: { (_) in
                
            }
            .store(in: &tokens)
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testError() {
        let session = MokeURLSession(data: nil, response: fakeResponse.goodResponse, error: fakeResponse.error)
        let httpHelper = HTTPHerlper(session: session)
        let fetcher = FixerFetcher(httpHelper: httpHelper)
        
        fetcher.calculeExchange(0, from: currency, to: currency)
            .sink { (completion) in
                guard case .failure(let error) = completion else {
                    XCTFail()
                    return
                }
                self.expectation.fulfill()
                XCTAssertEqual(error, .badResponse)
            } receiveValue: { (_) in
                
            }
            .store(in: &tokens)

        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testNoData() {
        let session = MokeURLSession(data: nil, response: fakeResponse.goodResponse, error: nil)
        let httpHelper = HTTPHerlper(session: session)
        let fetcher = FixerFetcher(httpHelper: httpHelper)
        
        fetcher.calculeExchange(0, from: currency, to: currency)
            .sink { (completion) in
                guard case .failure(let error) = completion else {
                    XCTFail()
                    return
                }
                self.expectation.fulfill()
                XCTAssertEqual(error, .noData)
            } receiveValue: { (_) in
                
            }
            .store(in: &tokens)
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testBadData() {
        let session = MokeURLSession(data: fakeResponse.badData, response: fakeResponse.goodResponse, error: nil)
        let httpHelper = HTTPHerlper(session: session)
        let fetcher = FixerFetcher(httpHelper: httpHelper)
        
        fetcher.calculeExchange(0, from: currency, to: currency)
            .sink { (completion) in
                guard case .failure(let error) = completion else {
                    XCTFail()
                    return
                }
                self.expectation.fulfill()
                XCTAssertEqual(error, .parsing)
            } receiveValue: { (_) in
                
            }
            .store(in: &tokens)
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testAllGood() {
        let session = MokeURLSession(data: fakeResponse.goodData, response: fakeResponse.goodResponse, error: nil)
        let httpHelper = HTTPHerlper(session: session)
        let fetcher = FixerFetcher(httpHelper: httpHelper)
        
        fetcher.calculeExchange(0, from: currency, to: currency)
            .sink { (completion) in
                
                guard case .failure(_) = completion else {
                    XCTFail()
                    return
                }
                self.expectation.fulfill()
            } receiveValue: { (data) in
                
                XCTAssertEqual(data, 0)
            }
            .store(in: &tokens)
        
        wait(for: [expectation], timeout: 0.01)
    }
}
