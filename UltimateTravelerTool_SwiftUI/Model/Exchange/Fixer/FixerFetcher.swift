//
//  FixerFetcher.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 26/02/2021.
//

import Foundation
import Combine

final class FixerFetcher {
    
    // MARK: - Properties
    
    private let httpHelper: HTTPRequestHelper
    
    // MARK: - Init
    
    init(httpHelper: HTTPRequestHelper = HTTPRequestHelper()) {
        self.httpHelper = httpHelper
    }
    
    // MARK: - Methodes
    
    func getRates() -> AnyPublisher<[String: Double], HTTPError> {
        fetchFixer()
            .map { $0.rates }
            .eraseToAnyPublisher()
    }
    
    func calculExchange(_ amout: Double, from: Double, to: Double) -> Double {
        let amountInEuro = amout / from
        return amountInEuro * to
    }

    
    private func fetchFixer() -> AnyPublisher<FixerResponse, HTTPError> {
        httpHelper.make(url: getUrl())

    }
    
    private func getUrl() -> URL {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "data.fixer.io"
        components.path = "/api/latest"
        
        components.queryItems = [
            URLQueryItem(name: "access_key", value: APIConfig.fixerKey)
        ]
        
        return components.url!
    }
    
}
