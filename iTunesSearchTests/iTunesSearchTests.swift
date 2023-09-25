//
//  iTunesSearchTests.swift
//  iTunesSearchTests
//
//  Created by Daniel Gunawan on 24/09/23.
//

import XCTest
@testable import iTunesSearch

final class iTunesSearchTests: XCTestCase {
    var sut: LandingPresenter!
    var mockView: MockLandingView!
    var mockApiClient: MockApiClient!
    
    override func setUp() {
        super.setUp()
        
        self.mockView = MockLandingView()
        self.mockApiClient = MockApiClient()
        self.sut = LandingPresenter()

        self.sut.view = self.mockView
        self.sut.apiClient = self.mockApiClient
    }

    func testScreenInitiationWithEmptyData() {
        // given
        XCTAssertEqual(mockView.isTableViewConfigured, false)
        let mockResponse = ITunesSearchResult(resultCount: .zero, results: [])
        mockApiClient.responseStub = .success(mockResponse)
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(mockView.isTableViewConfigured)
        XCTAssertTrue(mockView.isEmptyStateShowing)
    }

    func testScreenInitiationWithData() {
        // given
        XCTAssertEqual(mockView.isTableViewConfigured, false)
        let mockResponse = ITunesSearchResult(resultCount: 20, results: ITunesSearchResultItem.generateMockItem(count: 20))
        mockApiClient.responseStub = .success(mockResponse)
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(mockView.isTableViewConfigured)
        XCTAssertFalse(mockView.isEmptyStateShowing)
        XCTAssertTrue(mockView.isReloadTableViewCalled)
        XCTAssertEqual(sut.fetchedSongs.count, 20)
    }
    
    func testScreenInitiationWithDataThenCheckSequence() {
        // given
        XCTAssertEqual(mockView.isTableViewConfigured, false)
        let mockResponse = ITunesSearchResult(resultCount: 20, results: ITunesSearchResultItem.generateMockItem(count: 20))
        mockApiClient.responseStub = .success(mockResponse)
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.getSongDetail(at: 19)?.songTitle, "track_19")
    }

    func testScreenInitiationWithDataThenLoadMore() {
        // given
        XCTAssertEqual(mockView.isTableViewConfigured, false)
        let mockResponse = ITunesSearchResult(resultCount: 20, results: ITunesSearchResultItem.generateMockItem(count: 20))
        mockApiClient.responseStub = .success(mockResponse)
        
        // when
        sut.viewDidLoad()
        let mockResponse2 = ITunesSearchResult(resultCount: 5, results: ITunesSearchResultItem.generateMockItem(count: 5))
        mockApiClient.responseStub = .success(mockResponse2)
        sut.didReachedEndOfTable()
        
        // then
        XCTAssertEqual(sut.currentSongPage, 2)
        XCTAssertEqual(sut.fetchedSongs.count, 25)
        XCTAssertEqual(mockView.reloadTableViewCallCount, 2)
    }
    
    
    func testScreenInitiationWithDataThenChangeKeyword() {
        // given
        XCTAssertEqual(mockView.isTableViewConfigured, false)
        sut.currentSeachKeyword = "hello"
        let mockResponse = ITunesSearchResult(resultCount: 20, results: ITunesSearchResultItem.generateMockItem(count: 20))
        mockApiClient.responseStub = .success(mockResponse)
        sut.viewDidLoad()
        
        // when
        let mockResponse2 = ITunesSearchResult(resultCount: 5, results: ITunesSearchResultItem.generateMockItem(count: 5))
        mockApiClient.responseStub = .success(mockResponse2)
        sut.didChangeSearchKeyword(keyword: "world")
        
        // then
        XCTAssertEqual(sut.fetchedSongs.count, 5)
    }
    
    func testScreenInitiationWithDataThenChangeKeywordButSameString() {
        // given
        XCTAssertEqual(mockView.isTableViewConfigured, false)
        sut.currentSeachKeyword = "hello"
        let mockResponse = ITunesSearchResult(resultCount: 20, results: ITunesSearchResultItem.generateMockItem(count: 20))
        mockApiClient.responseStub = .success(mockResponse)
        sut.viewDidLoad()
        
        // when
        let mockResponse2 = ITunesSearchResult(resultCount: 5, results: ITunesSearchResultItem.generateMockItem(count: 5))
        mockApiClient.responseStub = .success(mockResponse2)
        sut.didChangeSearchKeyword(keyword: "hello")
        
        // then
        XCTAssertEqual(sut.fetchedSongs.count, 20)
    }

    func testScreenInitiationWithDataLessThanLimit() {
        // given
        XCTAssertEqual(mockView.isTableViewConfigured, false)
        let mockResponse = ITunesSearchResult(resultCount: 10, results: ITunesSearchResultItem.generateMockItem(count: 10))
        mockApiClient.responseStub = .success(mockResponse)
        
        // when
        sut.viewDidLoad()
        sut.didReachedEndOfTable()
        
        // then
        XCTAssertEqual(sut.currentSongPage, 1)
        XCTAssertEqual(sut.fetchedSongs.count, 10)
        XCTAssertEqual(mockView.reloadTableViewCallCount, 1)
    }
    
    func testScreenInitiationWithApiError() {
        // given
        XCTAssertEqual(mockView.isTableViewConfigured, false)
        mockApiClient.responseStub = .failure(ApiRequestError.unableToDecode)
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(mockView.isTableViewConfigured)
        XCTAssertFalse(mockView.isEmptyStateShowing)
        XCTAssertEqual(sut.fetchedSongs.count, .zero)
        XCTAssertEqual(mockView.currentErrorMessage, ApiRequestError.unableToDecode.localizedDescription)
    }
}
