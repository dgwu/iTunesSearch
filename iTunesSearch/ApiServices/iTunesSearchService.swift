//
//  iTunesSearchService.swift
//  iTunesSearch
//
//  Created by Daniel Gunawan on 24/09/23.
//

import Foundation
enum iTunesSearchService {
    case songBy(artistName: String, limit: Int, offset: Int)
}

extension iTunesSearchService: HttpServiceType {
    var baseUrl: URL? {
        return URL(string: "https://itunes.apple.com/search")
    }
    
    var path: String {
        switch self {
        case .songBy:
            return ""
        }
    }
    
    var parameters: [String : Any] {
        switch self {
        case .songBy(let artistName, let limit, let offset):
            return ["term": artistName,
                    "attribute": "artistTerm",
                    "entity": "song",
                    "limit": limit,
                    "offset": offset]
        }
    }
    
    var headers: [String : String]? {
        nil
    }
    
    var method: HttpMethod {
        .get
    }
    
    var task: HttpTask {
        switch self {
        case .songBy:
            return .queryParameters(parameters: self.parameters.mapValues({ (value) -> String in
                return "\(value)"
            }))
        }
    }
}
