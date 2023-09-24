//
//  iTunesSearchResult.swift
//  iTunesSearch
//
//  Created by Daniel Gunawan on 24/09/23.
//

import Foundation

// MARK: - ITunesSearchResult
struct ITunesSearchResult: Codable {
    let resultCount: Int
    let results: [ITunesSearchResultItem]
}

// MARK: - Result
struct ITunesSearchResultItem: Codable {
    let wrapperType, kind: String
    let artistId, collectionId, trackId: Int
    let artistName, collectionName, trackName, collectionCensoredName: String
    let trackCensoredName: String
    let previewURL: String?
    let artworkUrl30, artworkUrl60, artworkUrl100: String?
}
