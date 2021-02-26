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
        fetcher.getCurrenciesList { (result) in
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
        fetcher.getCurrenciesList { (result) in
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
        fetcher.getCurrenciesList { (result) in
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
        fetcher.getCurrenciesList { (result) in
            guard case .failure(let error) = result else {
                XCTFail()
                return
            }
            self.expactation.fulfill()
            
            XCTAssertEqual(error , .parsing)
            
        }
        wait(for: [expactation], timeout: 0.01)
    }
    
    func testAllIsGood() {
        urlSession = MokeURLSession(data: fakeResponse.goodData, response: fakeResponse.goodResponse, error: nil)
        
        let fetcher = RestcountriesFetcher(httpHelper: HTTPHerlper(session: urlSession!))
        fetcher.getCurrenciesList { (result) in
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
            
        }
        
        wait(for: [expactation], timeout: 0.01)
        
    }

}
