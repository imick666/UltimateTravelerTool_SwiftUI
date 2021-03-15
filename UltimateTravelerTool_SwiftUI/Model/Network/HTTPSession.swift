//
//  HTTPSession.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 11/03/2021.
//

import Foundation
import Combine

protocol HTTPSession {
    typealias Output = URLSession.DataTaskPublisher.Output
    typealias Failure = URLSession.DataTaskPublisher.Failure
    
    func request(url: URL) -> AnyPublisher<Output, Failure>
    
}

final class HTTPSessionHelper: HTTPSession {
    
    func request(url: URL) -> AnyPublisher<Output, Failure> {
        print("network call")
        return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

}
