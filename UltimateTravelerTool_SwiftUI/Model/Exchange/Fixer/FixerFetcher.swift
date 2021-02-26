//
//  FixerFetcher.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 26/02/2021.
//

import Foundation

final class FixerFetcher {
    
    private let httpHelper: HTTPHerlper
    
    init(httpHelper: HTTPHerlper = HTTPHerlper()) {
        self.httpHelper = httpHelper
    }
    
    private var rateList: FixerResponse?
    
    func calculExchange(of amount: Double, from: String, to: String) -> Double {
        guard let fromRate = rateList?.rates[from],
              let toRate = rateList?.rates[to] else { return 0 }
        
        let amountInEuro = amount / fromRate
        
        return amountInEuro * toRate
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
        components.path = "api/latest"
        
        components.queryItems = [
            URLQueryItem(name: "access_key", value: APIConfig.fixerKey)
        ]
        
        return components
    }
    
}
