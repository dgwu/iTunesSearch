//
//  LandingModel.swift
//  iTunesSearch
//
//  Created by Daniel Gunawan on 24/09/23.
//

struct SongModel {
    let songTitle, artistName, albumName: String
    let artworkUrl: String?
    let songPreviewUrl: String?
    var isPlaying: Bool = false
    
    init(songTitle: String, artistName: String, albumName: String, artworkUrl: String?, songPreviewUrl: String?, isPlaying: Bool = false) {
        self.songTitle = songTitle
        self.artistName = artistName
        self.albumName = albumName
        self.artworkUrl = artworkUrl
        self.songPreviewUrl = songPreviewUrl
        self.isPlaying = isPlaying
    }
    
    init(from resultItem: ITunesSearchResultItem) {
        self.songTitle = resultItem.trackName
        self.artistName = resultItem.artistName
        self.albumName = resultItem.collectionName
        self.artworkUrl = resultItem.artworkUrl60 ?? resultItem.artworkUrl30
        self.songPreviewUrl = resultItem.previewURL
        self.isPlaying = false
    }
}
