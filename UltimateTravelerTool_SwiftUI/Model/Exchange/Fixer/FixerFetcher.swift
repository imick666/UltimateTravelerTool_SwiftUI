//
//  FixerFetcher.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 26/02/2021.
//

import Foundation

final class FixerFetcher {
    
    private let httpHelper: HTTPHerlper
    private let formatter = NumberFormatter()
    
    init(httpHelper: HTTPHerlper = HTTPHerlper()) {
        self.httpHelper = httpHelper
    }
    
    private var rateList: FixerResponse?
    
    func calculExchange(of amount: Double, from: String, to: String, completionHandler: @escaping (Result<Double, HTTPError>) -> Void) {
        getExchanges { (result) in
            switch result {
            case .failure(let error): completionHandler(.failure(error))
            case .success(let data): self.rateList = data
            }
        }
        
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        
        guard let fromRate = rateList?.rates[from],
              let toRate = rateList?.rates[to] else { return }
        
        let amountInEuro = amount / fromRate

        
        completionHandler(.success(amountInEuro * toRate))
    }
    
    private func getExchanges(completionHandler: @escaping (Result<FixerResponse, HTTPError>) -> Void) {
        guard rateList == nil else {
            completionHandler(.success(rateList!))
            return
        }
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
