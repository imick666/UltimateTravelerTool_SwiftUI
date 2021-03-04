//
//  FixerFetcher.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 26/02/2021.
//

import Foundation
import Combine

final class FixerFetcher {
    
    private let httpHelper: HTTPHerlper
    private var fixerResult: FixerResponse?
    
    init(httpHelper: HTTPHerlper = HTTPHerlper()) {
        self.httpHelper = httpHelper
    }
    
    func calculeExchange(_ amount: Double, from: Currency, to: Currency) -> Future<Double, HTTPError> {
        return Future { (promise) in
            guard self.fixerResult != nil else {
                self.getExchanges { (result) in
                    switch result {
                    case.failure(let error): promise(.failure(error))
                    case.success(let data):
                        self.fixerResult = data
                        _ = self.calculeExchange(amount, from: from, to: to)
                    }
                }
                return
            }
            
            guard let fromRate = self.fixerResult?.rates[from.code!], let toRate = self.fixerResult?.rates[to.code!] else { return }
            let amountInEuro = amount / fromRate
            let exchange = amountInEuro * toRate
            promise(.success(exchange))
        }
    }

    
    private func getExchanges(completionHandler: @escaping (Result<FixerResponse, HTTPError>) -> Void) {
        guard let url = getUrl().url else {
            completionHandler(.failure(.badUrl))
            return
        }
        
        httpHelper.fetch(from: url) { (result) in
            completionHandler(result)
        }
            
    }
    
    private func getUrl() -> URLComponents {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "data.fixer.io"
        components.path = "/api/latest"
        
        components.queryItems = [
            URLQueryItem(name: "access_key", value: APIConfig.fixerKey)
        ]
        
        return components
    }
    
}
