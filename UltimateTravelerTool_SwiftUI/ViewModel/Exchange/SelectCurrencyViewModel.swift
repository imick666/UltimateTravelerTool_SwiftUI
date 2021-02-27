//
//  SelectCurrencyViewModel.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 27/02/2021.
//

import SwiftUI

final class SelectCurrencyViewModel: ObservableObject {
    
    @Published var countries = [RestcountriesResponse]()
    @Published var currencies = [Currency]()
    
    private var fetcher = RestcountriesFetcher()
    private var fetchedCoutrnies = [RestcountriesResponse]() {
        didSet {
            getCurrenciesByCode()
            getCurrenciesByCountries()
        }
    }
    
    init() {
        print("init")
        fetchCountries()
    }
    
    private func getCurrenciesByCountries() {
        var finalSort = [RestcountriesResponse]()
        finalSort = fetchedCoutrnies.sorted(by: { $0.name < $1.name })
        
        
        countries = finalSort
    }
    
    private func getCurrenciesByCode() {
        fetchedCoutrnies.forEach { country in
            for currency in country.currencies where (!currencies.contains(where: { currency.code == $0.code })) {
                currencies.append(currency)
            }
        }
        currencies.sort(by: { $0.name! < $1.name! })
    }
    
    private func fetchCountries() {
        guard fetchedCoutrnies.isEmpty else {
            return
        }
        
        fetcher.getCurrenciesList { [unowned self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(_):
                    self.fetchedCoutrnies = []
                    print("error in call")
                case .success(let data):
                    var finalData = [RestcountriesResponse]()
                    for country in data {
                        var country = country
                        country.id = UUID()
                        finalData.append(country)
                    }
                    
                    for (countryIndex, country) in finalData.enumerated() {
                        for (currencyIndex, currency) in country.currencies.enumerated() {
                            var currency = currency
                            guard currency.code != nil, currency.code != "(none)" else {
                                finalData[countryIndex].currencies.remove(at: currencyIndex)
                                break
                            }
                            currency.id = UUID()
                            finalData[countryIndex].currencies[currencyIndex] = currency
                        }
                    }
                    self.fetchedCoutrnies = finalData
                }
            }
        }
    }
    
}
