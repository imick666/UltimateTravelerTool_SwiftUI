//
//  FixerFetcher.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 26/02/2021.
//

import Foundation

final class FixerFetcher {
    
    private let httpHelper: HTTPHerlper
    private var fixerResult: FixerResponse?
    
    init(httpHelper: HTTPHerlper = HTTPHerlper()) {
        self.httpHelper = httpHelper
        
    }
    
    func calculeExchange(_ amount: Double, from: Currency, to: Currency, completionHandler: @escaping (Result<Double, HTTPError>) -> Void ) {
        guard fixerResult != nil else {
            getExchanges { (result) in
                switch result {
                case .failure(let error): completionHandler(.failure(error))
                case .success(let data):
                    self.fixerResult = data
                    self.calculeExchange(amount, from: from, to: to, completionHandler: completionHandler)
                }
            }
            return
        }
        
        guard let fromRate = fixerResult?.rates[from.code!], let toRate = fixerResult?.rates[to.code!] else { return }
        let amountInEuro = amount / fromRate
        let exchange = amountInEuro * toRate
        completionHandler(.success(exchange))
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
