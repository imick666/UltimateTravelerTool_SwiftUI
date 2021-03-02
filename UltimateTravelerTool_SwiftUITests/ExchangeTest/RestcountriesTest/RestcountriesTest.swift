//
//  RestcountriesTest.swift
//  UltimateTravelerTool_SwiftUITests
//
//  Created by mickael ruzel on 26/02/2021.
//

import XCTest
@testable import UltimateTravelerTool_SwiftUI

class RestcountriesTest: XCTestCase {

    var urlSession: MokeURLSession?
    let fakeResponse = RestcountriesFakeReponse()
    let expactation = XCTestExpectation(description: "Wait for queue")
    
    func testBadResponse() {
        urlSession = MokeURLSession(data: nil, response: fakeResponse.badResponse, error: nil)
        
        let fetcher = RestcountriesFetcher(httpHelper: HTTPHerlper(session: urlSession!))
        fetcher.getCountries { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expactation.fulfill()
            
            XCTAssertEqual(error , .badResponse)
            
        }
        wait(for: [expactation], timeout: 0.01)
    }
    
    func testError() {
        urlSession = MokeURLSession(data: nil, response: fakeResponse.goodResponse, error: fakeResponse.error)
        
        let fetcher = RestcountriesFetcher(httpHelper: HTTPHerlper(session: urlSession!))
        fetcher.getCountries { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expactation.fulfill()
            
            XCTAssertEqual(error , .badResponse)
            
        }
        wait(for: [expactation], timeout: 0.01)
    }
    
    func testNoData() {
        urlSession = MokeURLSession(data: nil, response: fakeResponse.goodResponse, error: nil)
        
        let fetcher = RestcountriesFetcher(httpHelper: HTTPHerlper(session: urlSession!))
        fetcher.getCountries { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expactation.fulfill()
            
            XCTAssertEqual(error , .noData)
            
        }
        wait(for: [expactation], timeout: 0.01)
    }
    
    func testBadData() {
        urlSession = MokeURLSession(data: fakeResponse.badData, response: fakeResponse.goodResponse, error: nil)
        
        let fetcher = RestcountriesFetcher(httpHelper: HTTPHerlper(session: urlSession!))
        fetcher.getCountries { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expactation.fulfill()
            
            XCTAssertEqual(error , .parsing)
            
        }
        wait(for: [expactation], timeout: 0.01)
    }
    
    func testCountries() {
        urlSession = MokeURLSession(data: fakeResponse.goodData, response: fakeResponse.goodResponse, error: nil)
        
        let fetcher = RestcountriesFetcher(httpHelper: HTTPHerlper(session: urlSession!))
        fetcher.getCountries { (result) in
            guard case .success(let data) = result else {
                guard case .failure(let error) = result else {
                    XCTFail()
                    return
                }
                XCTAssertEqual(error, .noData)
                return
            }
            self.expactation.fulfill()
            XCTAssertNotNil(data)
            XCTAssertTrue(data.contains(where: {$0.currencies.contains(where: { $0.code != nil || $0.code?.count != 3 })}))
            XCTAssertTrue(data.allSatisfy({ $0.id != nil }))
            XCTAssertTrue(data.contains(where: { $0.currencies.allSatisfy({ $0.id != nil})}))
            
        }
        
        wait(for: [expactation], timeout: 0.01)

    }
    
    func testCurrencies() {
        urlSession = MokeURLSession(data: fakeResponse.goodData, response: fakeResponse.goodResponse, error: nil)
        
        let fetcher = RestcountriesFetcher(httpHelper: HTTPHerlper(session: urlSession!))
        fetcher.getCurrencies { (result) in
            guard case .success(let data) = result else {
                guard case .failure(let error) = result else {
                    XCTFail()
                    return
                }
                XCTAssertEqual(error, .noData)
                return
            }
            self.expactation.fulfill()
            XCTAssertNotNil(data)
            XCTAssertTrue(data.contains(where: { $0.code != nil}))
            XCTAssertTrue(data.contains(where: { $0.name != nil}))
            XCTAssertTrue(data.allSatisfy({ $0.id != nil }))
            
        }
        
        wait(for: [expactation], timeout: 0.01)
    }

}
