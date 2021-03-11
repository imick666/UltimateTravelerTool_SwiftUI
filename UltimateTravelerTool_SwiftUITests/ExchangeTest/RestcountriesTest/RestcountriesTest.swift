//
//  RestcountriesTest.swift
//  UltimateTravelerTool_SwiftUITests
//
//  Created by mickael ruzel on 26/02/2021.
//

import XCTest
@testable import UltimateTravelerTool_SwiftUI
import Combine

class RestcountriesTest: XCTestCase {

    // MARK: - Properties
    
    var urlSession: MokeHTTPSession!
    var HTTPRequest: HTTPRequestHelper {
        return HTTPRequestHelper(session: urlSession)
    }
    var countriesFetcher: RestcountriesFetcher {
        return RestcountriesFetcher(httpHelper: HTTPRequest)
    }
    var datas = RestcountriesFakeReponse()
    let expactation = XCTestExpectation(description: "Wait for queue")
    
    // MARK: - Tests
    
    func testBadResponse() {
        urlSession = MokeHTTPSession(data: datas, responseType: .badResponse)
        
        _ = countriesFetcher.getCountries()
            .sink { (completion) in
                guard case .failure(let error) = completion else {
                    XCTFail()
                    return
                }
                self.expactation.fulfill()
                XCTAssertEqual(error, .badResponse)
            } receiveValue: { _ in }

        wait(for: [expactation], timeout: 0.01)
    }
    
    func testError() {
        urlSession = MokeHTTPSession(data: datas, responseType: .error)

        _ = countriesFetcher.getCountries()
            .sink { completion in
                guard case .failure(let error) = completion else {
                    XCTFail()
                    return
                }
                self.expactation.fulfill()
                XCTAssertEqual(error, .otherError)
            } receiveValue: { _ in }
        
        wait(for: [expactation], timeout: 0.01)
    }
//
    func testBadData() {
        urlSession = MokeHTTPSession(data: datas, responseType: .badData)

        _ = countriesFetcher.getCountries()
            .sink(receiveCompletion: { completion in
                guard case .failure(let error) = completion else {
                    XCTFail()
                    return
                }
                self.expactation.fulfill()
                XCTAssertEqual(error, .parsing)
            }, receiveValue: { _ in })
        
        wait(for: [expactation], timeout: 0.01)
    }

    func testCountries() {
        urlSession = MokeHTTPSession(data: datas, responseType: .goddData)
        
        _ = countriesFetcher.getCountries()
            .sink(receiveCompletion: { completion in
                guard case .finished = completion else {
                    XCTFail()
                    return
                }
                self.expactation.fulfill()
            }, receiveValue: { data in
                XCTAssertNotNil(data)
                XCTAssertTrue(data.contains(where: {$0.currencies.contains(where: { $0.code != nil || $0.code?.count != 3 })}))
                XCTAssertTrue(data.allSatisfy({ $0.id != nil }))
                XCTAssertTrue(data.contains(where: { $0.currencies.allSatisfy({ $0.id != nil})}))
            })

        wait(for: [expactation], timeout: 0.01)

    }

    func testCurrencies() {
        urlSession = MokeHTTPSession(data: datas, responseType: .goddData)
        
        _ = countriesFetcher.getCurrencies()
            .sink(receiveCompletion: { completion in
                guard case .finished = completion else {
                    XCTFail()
                    return
                }
                self.expactation.fulfill()
            }, receiveValue: { data in
                XCTAssertNotNil(data)
                XCTAssertTrue(data.contains(where: { $0.code != nil}))
                XCTAssertTrue(data.contains(where: { $0.name != nil}))
                XCTAssertTrue(data.allSatisfy({ $0.id != nil }))
            })

        wait(for: [expactation], timeout: 0.01)
    }

}
