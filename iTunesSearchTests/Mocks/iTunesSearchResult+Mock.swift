//
//  iTunesSearchResult+Mock.swift
//  iTunesSearchTests
//
//  Created by Daniel Gunawan on 25/09/23.
//

import Foundation
@testable import iTunesSearch

extension ITunesSearchResultItem {
    static func generateMockItem(count: Int) -> [ITunesSearchResultItem] {
        var mockItems = [ITunesSearchResultItem]()
        for index in 0..<count {
            mockItems.append(ITunesSearchResultItem(wrapperType: "track",
                                                    kind: "song",
                                                    artistId: index,
                                                    collectionId: index,
                                                    trackId: index,
                                                    artistName: "name_\(index)",
                                                    collectionName: "collection_\(index)",
                                                    trackName: "track_\(index)",
                                                    collectionCensoredName: "",
                                                    trackCensoredName: "",
                                                    previewUrl: "https://www.google.com",
                                                    artworkUrl30: "https://www.google.com",
                                                    artworkUrl60: "https://www.google.com", artworkUrl100: nil))
        }
        return mockItems
    }
}
