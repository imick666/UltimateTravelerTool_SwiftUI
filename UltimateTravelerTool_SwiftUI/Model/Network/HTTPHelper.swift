//
//  HTTPHelper.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 26/02/2021.
//

import Foundation
import Combine

final class HTTPHerlper {
    
    private let session: URLSession
    private var publishers = Set<AnyCancellable>()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch<T: Decodable>(from url: URL, completionHandler: @escaping (Result<T, HTTPError>) -> Void) {
        session.dataTask(with: url) { (data, response, error) in
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(.failure(HTTPError.badResponse))
                return
            }
            guard error == nil else {
                completionHandler(.failure(HTTPError.badResponse))
                return
            }
            guard let data = data else {
                completionHandler(.failure(.noData))
                return
            }
            do {
                let dataResponse = try JSONDecoder().decode(T.self, from: data)
                completionHandler(.success(dataResponse))
            } catch {
                completionHandler(.failure(.parsing))
            }
        }.resume()
    }
}
