//
//  RestcountriesFetcher.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 26/02/2021.
//

import Foundation
import Combine

final class RestcountriesFetcher {
    
    // MARK: - Properties
    
    private let httpHelper: HTTPRequestHelper
    
    // MARK: - Init
    
    init(httpHelper: HTTPRequestHelper = HTTPRequestHelper()) {
        self.httpHelper = httpHelper
    }
    
    // MARK: - Methodes
    
    func getCountries() -> AnyPublisher<[RestcountriesResponse], HTTPError> {
        fetchRestCountries()
            .map({ countries -> [RestcountriesResponse] in
                var finalCountries = [RestcountriesResponse]()
                countries.forEach { country in
                    var country = country
                    let currencies = country.currencies.filter( { $0.code != nil && $0.code?.count == 3})
                    var finalCurrencies = [Currency]()
                    currencies.forEach { currency in
                        var currency = currency
                        currency.id = UUID()
                        finalCurrencies.append(currency)
                    }
                    country.currencies = finalCurrencies
                    country.id = UUID()
                    finalCountries.append(country)
                }
                
                return finalCountries.sorted(by: { $0.name < $1.name })
            })
            .eraseToAnyPublisher()
    }
    
    func getCurrencies() -> AnyPublisher<[Currency], HTTPError> {
        fetchRestCountries()
            .map({ countries -> [Currency] in
                return self.sortCurrecnies(countries)
            })
            .eraseToAnyPublisher()
    }
    
    private func sortCurrecnies(_ countries: [RestcountriesResponse]) -> [Currency] {
        var sorted = [Currency]()

        countries.forEach { country in
            let currencies = country.currencies.filter( {$0.code != nil && $0.code?.count == 3 })
            currencies.forEach { currency in
                var currency = currency
                guard !sorted.contains(where: {$0.code == currency.code}) else { return }
                currency.id = UUID()
                sorted.append(currency)
            }
        }

        sorted.sort(by: { $0.name! < $1.name! })
        return sorted
    }
    
    
    private func fetchRestCountries() -> AnyPublisher<[RestcountriesResponse], HTTPError> {
        httpHelper.make(url: getUrl())
    }
    
    private func getUrl() -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "restcountries.eu"
        components.path = "/rest/v2/all"
        
        components.queryItems = [
            URLQueryItem(name: "fields", value: "name;translations;currencies")
        ]
        
        return components.url!
    }
}
