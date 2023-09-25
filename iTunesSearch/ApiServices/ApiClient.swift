//
//  ApiClient.swift
//  iTunesSearch
//
//  Created by Daniel Gunawan on 24/09/23.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

enum HttpTask {
    case plain
    case queryParameters(parameters: [String: String])
    case bodyParameters(parameters: [String: Any])
}

protocol HttpServiceType {
    var baseUrl: URL? {get}
    var path: String {get}
    var parameters: [String: Any] {get}
    var headers: [String: String]? {get}
    var method: HttpMethod {get}
    var task: HttpTask {get}
}

enum ApiRequestError: Error {
    case unresolvedUrl
    case unableToDecode
    case outOfStock
    case unableToLocateDownloadedFile
}

protocol ServiceClient: AnyObject {
    func request<T: Decodable>(_ request: HttpServiceType, onComplete: @escaping (Result<T, Error>) -> ())
    func download(urlString: String, onComplete: @escaping (Result<URL, Error>) -> ())
}

final class ApiClient: ServiceClient {
    func request<T: Decodable>(_ request: HttpServiceType, onComplete: @escaping (Result<T, Error>) -> ()) {
        guard let baseUrl = request.baseUrl,
              var urlComponent = URLComponents(url: baseUrl.appendingPathComponent(request.path), resolvingAgainstBaseURL: true) else {
            onComplete(.failure(ApiRequestError.unresolvedUrl))
            return
        }
        
        if case .queryParameters(let parameters) = request.task {
            urlComponent.queryItems = parameters.map({ query in
                URLQueryItem(name: query.key, value: query.value)
            })
        }

        var urlRequest = URLRequest(url: urlComponent.url!)
        request.headers?.forEach({ header in
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        })
        urlRequest.httpMethod = request.method.rawValue

        URLSession.shared.dataTask(with: urlRequest) { responseData, urlResponse, error in
            if let error = error {
                onComplete(.failure(error))
                return
            }
            
            if let responseData = responseData,
               let decodedData = try? JSONDecoder().decode(T.self, from: responseData) {
                onComplete(.success(decodedData))
            } else {
                onComplete(.failure(ApiRequestError.unableToDecode))
            }
        }.resume()
    }
    
    func download(urlString: String, onComplete: @escaping (Result<URL, Error>) -> ()) {
        guard let url = URL(string: urlString) else {
            onComplete(.failure(ApiRequestError.unresolvedUrl))
            return
        }
        URLSession.shared.downloadTask(with: url) { fileLocation, urlResponse, error in
            if let error = error {
                onComplete(.failure(error))
                return
            }
            if let fileLocation = fileLocation {
                onComplete(.success(fileLocation))
            } else {
                onComplete(.failure(ApiRequestError.unableToLocateDownloadedFile))
            }
        }.resume()
    }
}
