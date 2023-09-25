//
//  MockLandingView.swift
//  iTunesSearchTests
//
//  Created by Daniel Gunawan on 25/09/23.
//

import UIKit
@testable import iTunesSearch

final class MockLandingView: LandingPresenterToView {
    var presenter: LandingViewToPresenter?
    
    var isTableViewConfigured = false
    func configureTableView() {
        isTableViewConfigured = true
    }
    
    var isReloadTableViewCalled = false
    var reloadTableViewCallCount: Int = .zero
    func reloadTableView() {
        isReloadTableViewCalled = true
        reloadTableViewCallCount += 1
    }
    
    var isEmptyStateShowing = false
    func showEmptyDataState() {
        isEmptyStateShowing = true
    }
    
    func hideEmptyDataState() {
        isEmptyStateShowing = false
    }
    
    var currentErrorMessage = ""
    func showGeneralErrorAlert(message: String) {
        currentErrorMessage = message
    }
    
    var musicControlIsVisible = false
    var musicControlIsPlaying = false
    func setMusicControl(isVisible: Bool, isPlaying: Bool) {
        musicControlIsVisible = isVisible
        musicControlIsPlaying = isPlaying
    }
}
