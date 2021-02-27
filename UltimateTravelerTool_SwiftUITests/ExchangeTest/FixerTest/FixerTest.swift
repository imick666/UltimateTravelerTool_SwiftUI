//
//  FixerTest.swift
//  UltimateTravelerTool_SwiftUITests
//
//  Created by mickael ruzel on 26/02/2021.
//

import XCTest
@testable import UltimateTravelerTool_SwiftUI

class FixerTest: XCTestCase {

    let fakeResponse = FixerFakeResponse()
    let expectation = XCTestExpectation(description: "Wait for queue")

    func testBadResponse() {
        let session = MokeURLSession(data: nil, response: fakeResponse.badResponse, error: nil)
        let httpHelper = HTTPHerlper(session: session)
        let fetcher = FixerFetcher(httpHelper: httpHelper)
        
        fetcher.calculExchange(of: 0, from: "EUR", to: "EUR") { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expectation.fulfill()
            XCTAssertEqual(error, .badResponse)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testError() {
        let session = MokeURLSession(data: nil, response: fakeResponse.goodResponse, error: fakeResponse.error)
        let httpHelper = HTTPHerlper(session: session)
        let fetcher = FixerFetcher(httpHelper: httpHelper)
        
        fetcher.calculExchange(of: 0, from: "EUR", to: "EUR") { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expectation.fulfill()
            XCTAssertEqual(error, .badResponse)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testNoData() {
        let session = MokeURLSession(data: nil, response: fakeResponse.goodResponse, error: nil)
        let httpHelper = HTTPHerlper(session: session)
        let fetcher = FixerFetcher(httpHelper: httpHelper)
        
        fetcher.calculExchange(of: 0, from: "EUR", to: "EUR") { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expectation.fulfill()
            XCTAssertEqual(error, .noData)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testBadData() {
        let session = MokeURLSession(data: fakeResponse.badData, response: fakeResponse.goodResponse, error: nil)
        let httpHelper = HTTPHerlper(session: session)
        let fetcher = FixerFetcher(httpHelper: httpHelper)
        
        fetcher.calculExchange(of: 0, from: "EUR", to: "EUR") { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expectation.fulfill()
            XCTAssertEqual(error, .parsing)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testAllGood() {
        let session = MokeURLSession(data: fakeResponse.goodData, response: fakeResponse.goodResponse, error: nil)
        let httpHelper = HTTPHerlper(session: session)
        let fetcher = FixerFetcher(httpHelper: httpHelper)
        
        fetcher.calculExchange(of: 0, from: "EUR", to: "EUR") { (result) in
            guard case .success(let data) = result else {
                XCTFail()
                return
            }
            self.expectation.fulfill()
            XCTAssertEqual(data, 0)
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
