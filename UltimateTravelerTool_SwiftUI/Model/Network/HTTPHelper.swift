//
//  HTTPHelper.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 26/02/2021.
//

import Foundation
import Combine


final class HTTPRequestHelper {
    
    private let session: HTTPSession
    
    init(session: HTTPSession = HTTPSessionHelper()) {
        self.session = session
    }
    
    func make<T: Decodable>(url: URL) -> AnyPublisher<T, HTTPError> {
        session.request(url: url)
            .tryMap {
                guard let response = $0.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw HTTPError.badResponse
                }
                
                return $0.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                switch error {
                case is HTTPError: return error as! HTTPError
                case is DecodingError: return HTTPError.parsing
                default: return HTTPError.otherError
                }
            }
            .eraseToAnyPublisher()
    }
}
