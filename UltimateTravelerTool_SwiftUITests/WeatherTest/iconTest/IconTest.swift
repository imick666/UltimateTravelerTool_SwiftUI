//
//  IconTest.swift
//  UltimateTravelerTool_SwiftUITests
//
//  Created by mickael ruzel on 17/03/2021.
//

import XCTest
import Combine
@testable import UltimateTravelerTool_SwiftUI

class IconTest: XCTestCase {

    var session: HTTPSession!
    var request: HTTPRequestHelper!
    var fetcher: WeatherFetcher!
    var expectation = XCTestExpectation(description: "wait for queue")
    
    var subscriptions = Set<AnyCancellable>()
    
    override func tearDown() {
        subscriptions = []
    }
    
    func testBadResponse() {
        session = MokeHTTPSession(data: IconFakeData(), responseType: .badResponse)
        request = HTTPRequestHelper(session: session)
        fetcher = WeatherFetcher(httpHelper: request)
        
        fetcher.getIcon(for: "")
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
    
    func testerror() {
        session = MokeHTTPSession(data: IconFakeData(), responseType: .error)
        request = HTTPRequestHelper(session: session)
        fetcher = WeatherFetcher(httpHelper: request)
        
        fetcher.getIcon(for: "")
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
        session = MokeHTTPSession(data: IconFakeData(), responseType: .badData)
        request = HTTPRequestHelper(session: session)
        fetcher = WeatherFetcher(httpHelper: request)
        
        fetcher.getIcon(for: "")
            .tryMap { data -> UIImage in
                guard let image = UIImage(data: data) else { throw HTTPError.parsing }
                return image
            }
            .mapError { error -> HTTPError in
                switch error {
                case is HTTPError: return error as! HTTPError
                default: return HTTPError.otherError
                }
            }
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
        session = MokeHTTPSession(data: IconFakeData(), responseType: .goddData)
        request = HTTPRequestHelper(session: session)
        fetcher = WeatherFetcher(httpHelper: request)
        
        fetcher.getIcon(for: "")
            .tryMap { data -> UIImage in
                guard let image = UIImage(data: data) else { throw HTTPError.parsing }
                return image
            }
            .mapError { error -> HTTPError in
                switch error {
                case is HTTPError: return error as! HTTPError
                default: return HTTPError.otherError
                }
            }
            .sink { completion in
                guard case .finished = completion else {
                    XCTFail()
                    return
                }
                self.expectation.fulfill()
            } receiveValue: { data in
                var waitData: Data {
                    let bundle = Bundle(for: IconFakeData.self)
                    let url = bundle.url(forResource: "icon", withExtension: "png")!
                    let data = try! Data(contentsOf: url)
                    return UIImage(data: data)!.pngData()!
                }
                
                XCTAssertNotNil(data)
                XCTAssertEqual(data.pngData()!, waitData)
            }
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 0.01)
    }

}
