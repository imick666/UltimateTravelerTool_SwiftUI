//
//  WeatherTest.swift
//  UltimateTravelerTool_SwiftUITests
//
//  Created by mickael ruzel on 16/03/2021.
//

import XCTest
import Combine
@testable import UltimateTravelerTool_SwiftUI

class WeatherTest: XCTestCase {
    
    var httpRequest: HTTPRequestHelper!
    var fetcher: WeatherFetcher!
    let expectation = XCTestExpectation(description: "wait for queue")
    var subscriptions = Set<AnyCancellable>()
    
    override func tearDown() {
        subscriptions = []
    }
    
    func testBadResponse() {
        let session = MokeHTTPSession(data: WeatherFakeData(), responseType: .badResponse)
        httpRequest = HTTPRequestHelper(session: session)
        fetcher = WeatherFetcher(httpHelper: httpRequest)
        
        fetcher.getWeather(for: (lat: "00", lon: "00"))
            .sink { completion in
                guard case .failure(let error) = completion else {
                    XCTFail()
                    return
                }
                self.expectation.fulfill()
                XCTAssertEqual(error, .badResponse)
                
            } receiveValue: { _ in }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testError() {
        let session = MokeHTTPSession(data: WeatherFakeData(), responseType: .error)
        httpRequest = HTTPRequestHelper(session: session)
        fetcher = WeatherFetcher(httpHelper: httpRequest)
        
        fetcher.getWeather(for: (lat: "00", lon: "00"))
            .sink { completion in
                guard case .failure(let error) = completion else {
                    XCTFail()
                    return
                }
                self.expectation.fulfill()
                XCTAssertEqual(error, .otherError)
                
            } receiveValue: { _ in }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testBadData() {
        let session = MokeHTTPSession(data: WeatherFakeData(), responseType: .badData)
        httpRequest = HTTPRequestHelper(session: session)
        fetcher = WeatherFetcher(httpHelper: httpRequest)
        
        fetcher.getWeather(for: (lat: "00", lon: "00"))
            .sink { completion in
                guard case .failure(let error) = completion else {
                    XCTFail()
                    return
                }
                self.expectation.fulfill()
                XCTAssertEqual(error, .parsing)
                
            } receiveValue: { _ in }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGoodData() {
        let session = MokeHTTPSession(data: WeatherFakeData(), responseType: .goddData)
        httpRequest = HTTPRequestHelper(session: session)
        fetcher = WeatherFetcher(httpHelper: httpRequest)
        
        fetcher.getWeather(for: (lat: "00", lon: "00"))
            .sink { completion in
                guard case .finished = completion else {
                    XCTFail()
                    return
                }
                self.expectation.fulfill()
            } receiveValue: { value in
                XCTAssertNotNil(value)
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 0.01)
    }

}
