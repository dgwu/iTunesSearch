// 
//  LandingProtocols.swift
//  iTunesSearch
//
//  Created by Daniel Gunawan on 24/09/23.
//

import UIKit

// MARK: View -
protocol LandingPresenterToView: AnyObject {
    var presenter: LandingViewToPresenter? { get set }
    
    func configureTableView()
    func reloadTableView()
    func showEmptyDataState()
    func hideEmptyDataState()
    func showApiErrorAlert(message: String)
}

// MARK: Presenter -
protocol LandingViewToPresenter: AnyObject {
    var view: LandingPresenterToView? { get set }
    
    func viewDidLoad()
    func didChangeSearchKeyword(keyword: String)
    func getSongCount() -> Int
    func getSongDetail(at index: Int) -> SongModel
    func didReachedEndOfTable()
    func didTapSongDetail(at index: Int)
}
