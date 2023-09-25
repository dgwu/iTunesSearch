//
//  LandingPresenter.swift
//  iTunesSearch
//
//  Created by Daniel Gunawan on 24/09/23.
//

import Foundation
import AVFoundation

final class LandingPresenter: NSObject {
    weak var view: LandingPresenterToView?
    var apiClient: ServiceClient = ApiClient()
    
    let songLimitPerPage: Int = 20
    var currentSongPage: Int = 1
    var isEndOfResult = false
    var fetchedSongs = [SongModel]()
    var currentSeachKeyword: String = ""
    var currentPlayingSong: SongModel?
    var audioPlayer: AVAudioPlayer?
    
    private func startNewSearch() {
        apiClient.request(iTunesSearchService.songBy(artistName: currentSeachKeyword,
                                                     limit: songLimitPerPage, offset: .zero)) { [weak self] (result: Result<ITunesSearchResult, Error>) in
            guard let this = self else { return }
            this.currentSongPage = 1
            this.view?.hideEmptyDataState()
            switch result {
            case .success(let response):
                this.isEndOfResult = response.resultCount < this.songLimitPerPage
                if response.resultCount == .zero {
                    this.view?.showEmptyDataState()
                } else {
                    let newSongs = response.results.map({ SongModel(from: $0) })
                    this.fetchedSongs = newSongs
                    this.view?.reloadTableView()
                }
            case .failure(let error):
                this.view?.showGeneralErrorAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func fetchMoreResult() {
        let offset = currentSongPage * songLimitPerPage
        apiClient.request(iTunesSearchService.songBy(artistName: currentSeachKeyword,
                                                     limit: songLimitPerPage, offset: offset)) { [weak self] (result: Result<ITunesSearchResult, Error>) in
            guard let this = self else { return }
            switch result {
            case .success(let response):
                this.currentSongPage += 1
                this.isEndOfResult = response.resultCount < this.songLimitPerPage
                if response.resultCount > .zero {
                    let newSongs = response.results.map({ SongModel(from: $0) })
                    this.fetchedSongs.append(contentsOf: newSongs)
                    this.view?.reloadTableView()
                }
            case .failure(let error):
                this.view?.showGeneralErrorAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func loadSongPreviewToAudioPlayer(_ proposedSong: SongModel, fileLocation: URL) {
        self.audioPlayer?.stop()
        guard fetchedSongs.contains(proposedSong) else { return }
        self.audioPlayer = try? AVAudioPlayer(contentsOf: fileLocation)
        guard let audioPlayer = audioPlayer else {
            view?.showGeneralErrorAlert(message: "Fail to play the preview song")
            return
        }
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        proposedSong.isPlaying = true
        currentPlayingSong = proposedSong
        view?.reloadTableView()
        view?.setMusicControl(isVisible: true, isPlaying: true)
    }
}

extension LandingPresenter: LandingViewToPresenter {
    func viewDidLoad() {
        view?.configureTableView()
        self.startNewSearch()
    }
    
    func didChangeSearchKeyword(keyword: String) {
        if keyword != currentSeachKeyword {
            view?.setMusicControl(isVisible: false, isPlaying: false)
            currentPlayingSong = nil
            audioPlayer?.stop()
            currentSeachKeyword = keyword
            fetchedSongs.removeAll()
            view?.reloadTableView()
            startNewSearch()
        }
    }
    
    func getSongCount() -> Int {
        return self.fetchedSongs.count
    }
    
    func getSongDetail(at index: Int) -> SongModel? {
        guard fetchedSongs.indices.contains(index) else { return nil }
        return fetchedSongs[index]
    }
    
    func didReachedEndOfTable() {
        if !isEndOfResult {
            fetchMoreResult()
        }
    }
    
    func didTapSongDetail(at index: Int) {
        guard fetchedSongs.indices.contains(index) else { return }
        let tappedSong = fetchedSongs[index]
        guard tappedSong != currentPlayingSong else { return }
        audioPlayer?.stop()
        fetchedSongs.forEach { song in
            song.isPlaying = false
        }
        view?.reloadTableView()
        
        guard let previewUrlString = tappedSong.songPreviewUrl else { return }
        apiClient.download(urlString: previewUrlString) { [weak self] (result) in
            guard let this = self else { return }
            
            switch result {
            case .success(let fileLocation):
                this.loadSongPreviewToAudioPlayer(tappedSong, fileLocation: fileLocation)
            case .failure(let error):
                this.view?.setMusicControl(isVisible: false, isPlaying: false)
                this.view?.showGeneralErrorAlert(message: error.localizedDescription)
            }
        }
        
    }
    
    func didTapPlayPauseButton() {
        guard let audioPlayer = audioPlayer else { return }
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        } else {
            audioPlayer.play()
        }
        view?.setMusicControl(isVisible: true, isPlaying: audioPlayer.isPlaying)
    }
}

extension LandingPresenter: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            view?.setMusicControl(isVisible: true, isPlaying: false)
        }
    }
}
