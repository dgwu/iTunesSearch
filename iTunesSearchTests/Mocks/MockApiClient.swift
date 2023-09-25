//
//  MockApiClient.swift
//  iTunesSearchTests
//
//  Created by Daniel Gunawan on 25/09/23.
//

import Foundation
@testable import iTunesSearch

final class MockApiClient: ServiceClient {
    var responseStub: Result<Decodable, Error>?
    
    func request<T>(_ request: iTunesSearch.HttpServiceType, onComplete: @escaping (Result<T, Error>) -> ()) where T : Decodable {
        guard let responseStub = responseStub else { return }
        switch responseStub {
        case .success(let responseData):
            if let castedResponse = responseData as? T {
                onComplete(.success(castedResponse))
            } else {
                onComplete(.failure(ApiRequestError.unableToDecode))
            }
        case .failure(let error):
            onComplete(.failure(error))
        }
    }
    
    func download(urlString: String, onComplete: @escaping (Result<URL, Error>) -> ()) {}
}
