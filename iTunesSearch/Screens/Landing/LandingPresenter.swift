//
//  LandingPresenter.swift
//  iTunesSearch
//
//  Created by Daniel Gunawan on 24/09/23.
//

import Foundation

final class LandingPresenter {
    weak var view: LandingPresenterToView?
    var apiClient = ApiClient()
    
    let songLimitPerPage: Int = 20
    var currentSongPage: Int = 1
    var isEndOfResult = false
    var fetchedSongs = [SongModel]()
    var currentSeachKeyword: String = ""
    var currentPlayingSong: SongModel?
    
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
                this.view?.showApiErrorAlert(message: error.localizedDescription)
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
                print("dg: \(#file) \(#function), success, total \(this.fetchedSongs.count)")
            case .failure(let error): // FIXME: add handler
                break
            }
        }
    }
}

extension LandingPresenter: LandingViewToPresenter {
    func viewDidLoad() {
        view?.configureTableView()
        self.startNewSearch()
    }
    
    func didChangeSearchKeyword(keyword: String) {
        if keyword != currentSeachKeyword {
            currentSeachKeyword = keyword
            fetchedSongs.removeAll()
            view?.reloadTableView()
            startNewSearch()
            view?.setMusicControl(isVisible: false, isPlaying: false)
        }
    }
    
    func getSongCount() -> Int {
        return self.fetchedSongs.count
    }
    
    func getSongDetail(at index: Int) -> SongModel {
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
        
        currentPlayingSong?.isPlaying = false
        tappedSong.isPlaying = true
        currentPlayingSong = tappedSong
        view?.reloadTableView()
        view?.setMusicControl(isVisible: true, isPlaying: true)
    }
    
    func didTapPlayPauseButton() { // FIXME: add implementation
        
    }
}
