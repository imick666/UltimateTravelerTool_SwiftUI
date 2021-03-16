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
    private var rates = [String: Double]()
    
    // MARK: - Init
    
    init(httpHelper: HTTPRequestHelper = HTTPRequestHelper()) {
        self.httpHelper = httpHelper
    }
    
    // MARK: - Methodes
    
    func executeExchange(_ amount: Double, from: Currency, to: Currency) -> AnyPublisher<Double, HTTPError> {
        guard !rates.isEmpty else {
            print("rates are empty")
            return fetchFixer()
                .map {
                    self.rates = $0.rates
                    return self.calculExchange(amount, from: from, to: to)
                }
                .eraseToAnyPublisher()
        }
        
        return Just(calculExchange(amount, from: from, to: to))
            .setFailureType(to: HTTPError.self)
            .eraseToAnyPublisher()
    }
    
    private func calculExchange(_ amout: Double, from: Currency, to: Currency) -> Double {
        let fromRate = rates[from.code!]
        let toRate = rates[to.code!]
        
        let amountInEuro = amout / fromRate!
        
        return amountInEuro * toRate!
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
