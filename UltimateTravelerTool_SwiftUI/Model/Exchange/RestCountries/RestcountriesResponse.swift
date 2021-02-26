//
//  RestcountriesResponse.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 26/02/2021.
//

import Foundation

// MARK: - RestcountriesResponseElement
struct RestcountriesResponse: Codable {
    let currencies: [Currency]
    let translations: Translations
    let name: String
}

// MARK: - Currency
struct Currency: Codable {
    let code, name, symbol: String?
}

// MARK: - Translations
struct Translations: Codable {
    let br, pt: String
    let nl, hr: String?
    let fa: String
    let de, es, fr, ja: String?
    let it: String?
}


