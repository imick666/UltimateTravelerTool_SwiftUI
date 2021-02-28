//
//  RestcountriesFetcher.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 26/02/2021.
//

import Foundation
import Combine

final class RestcountriesFetcher {
    
    private let httpHelper: HTTPHerlper
    
    init(httpHelper: HTTPHerlper = HTTPHerlper()) {
        self.httpHelper = httpHelper
    }
    
    func getCurrenciesList(completionHandler: @escaping (Result<[RestcountriesResponse], HTTPError>) -> Void) {
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
        components.scheme = "https"
        components.host = "restcountries.eu"
        components.path = "/rest/v2/all"
        
        components.queryItems = [
            URLQueryItem(name: "fields", value: "name;translations;currencies")
        ]
        
        return components
    }
}
