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
    private var rates: FixerResponse?
    
    // MARK: - Init
    
    init(httpHelper: HTTPRequestHelper = HTTPRequestHelper()) {
        self.httpHelper = httpHelper
    }
    
    // MARK: - Methodes
    
    func executeExchange(_ amount: Double, from: Currency, to: Currency) -> AnyPublisher<Double, HTTPError> {
        guard rates != nil else {
            return fetchFixer()
                .map {
                    self.rates = $0
                    return self.calculExchangeX(amount, from: from, to: to)
                }
                .eraseToAnyPublisher()
        }
        
        return Just(calculExchangeX(amount, from: from, to: to))
            .setFailureType(to: HTTPError.self)
            .eraseToAnyPublisher()
    }
    
    private func calculExchangeX(_ amout: Double, from: Currency, to: Currency) -> Double {
        let fromRate = rates?.rates[from.code!]
        let toRate = rates?.rates[to.code!]
        
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
