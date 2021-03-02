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
    
    func getExchanges(completionHandler: @escaping (Result<FixerResponse, HTTPError>) -> Void) {
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
