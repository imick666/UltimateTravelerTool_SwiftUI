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
    
    private var fetchResult = [RestcountriesResponse]()
    
    init(httpHelper: HTTPHerlper = HTTPHerlper()) {
        self.httpHelper = httpHelper
    }
    
    
    
    func getCountries(completionHandler: @escaping (Result<[RestcountriesResponse], HTTPError>) -> Void) {
        fetchRestcountries { (result) in
            switch result {
            case .failure(let error): completionHandler(.failure(error))
            case .success(let data):
                self.fetchResult = self.cleanFetchResult(data)
                completionHandler(.success(self.sortCountries(self.fetchResult)))
            }
        }
    }
    
    func getCurrencies(completionHandler: @escaping (Result<[Currency], HTTPError>) -> Void) {
        fetchRestcountries { result in
            switch result {
            case .failure(let error): completionHandler(.failure(error))
            case .success(let data):
                self.fetchResult = self.cleanFetchResult(data)
                completionHandler(.success(self.sortCurrecnies(self.fetchResult)))
            }
        }
    }
    
    private func sortCountries(_ countries: [RestcountriesResponse]) -> [RestcountriesResponse] {
        return fetchResult.sorted(by: { $0.name < $1.name })
    }
    
    private func sortCurrecnies(_ countries: [RestcountriesResponse]) -> [Currency] {
        var sorted = [Currency]()
        
        countries.forEach { country in
            country.currencies.forEach({ sorted.append($0) })
        }
        
        return sorted.sorted(by: { $0.code != $1.code }).sorted(by: { $0.name! < $1.name! })
    }
    
    private func cleanFetchResult(_ fetchResult: [RestcountriesResponse]) -> [RestcountriesResponse] {
        
        var sorted = [RestcountriesResponse]()
        
        fetchResult.forEach { country in
            var country = country
            country.id = UUID()
            var currencies = country.currencies.filter({ ($0.code != nil && $0.code?.count == 3) && $0.name != nil })
            for (index, currency) in currencies.enumerated() {
                var currency = currency
                currency.id = UUID()
                currencies[index] = currency
            }
            
            country.currencies = currencies.sorted(by: { $0.name! < $1.name! })
            sorted.append(country)
        }
        
        return sorted
    }
    
    private func fetchRestcountries(completionHandler: @escaping (Result<[RestcountriesResponse], HTTPError>) -> Void) {
        guard fetchResult.isEmpty else { return }
        
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
