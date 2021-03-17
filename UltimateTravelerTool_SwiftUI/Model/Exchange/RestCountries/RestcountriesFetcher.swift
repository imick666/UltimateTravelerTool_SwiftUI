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
    private var countries = [RestcountriesResponse]()
    
    // MARK: - Init
    
    init(httpHelper: HTTPRequestHelper = HTTPRequestHelper()) {
        self.httpHelper = httpHelper
        
    }
    
    // MARK: - Methodes
    
    func getCountries(searchTerms: String) -> AnyPublisher<[RestcountriesResponse], HTTPError> {
        guard !countries.isEmpty else {
            return fetchRestCountries()
                .map { self.assignID(for: $0) }
                .map { countries -> [RestcountriesResponse] in
                    self.countries = countries
                    return searchTerms.isEmpty ? countries : countries.filter( { $0.name.lowercased().hasPrefix(searchTerms.lowercased()) })
                }
                .eraseToAnyPublisher()
        }
        
        let result = searchTerms.isEmpty ? countries :  countries.filter( { $0.name.lowercased().hasPrefix(searchTerms.lowercased())})
        return Just(result)
            .setFailureType(to: HTTPError.self)
            .eraseToAnyPublisher()
    }
    
    func getCurrencies(searchTerms: String) -> AnyPublisher<[Currency], HTTPError> {
        
        guard !countries.isEmpty else {
            return fetchRestCountries()
                .map { self.assignID(for: $0) }
                .map { self.sortCurrecnies($0) }
                .map { searchTerms.isEmpty ? $0 : $0.filter( { $0.name!.lowercased().hasPrefix(searchTerms.lowercased()) }) }
                .eraseToAnyPublisher()
        }
        
        return Just( searchTerms.isEmpty ? sortCurrecnies(countries) : sortCurrecnies(countries).filter( {$0.name!.lowercased().hasPrefix(searchTerms.lowercased()) } ))
            .setFailureType(to: HTTPError.self)
            .eraseToAnyPublisher()
    }
    
    private func assignID(for countries: [RestcountriesResponse]) -> [RestcountriesResponse] {
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
        httpHelper.fetchJson(url: getUrl())
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
