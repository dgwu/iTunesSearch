//
//  LandingView.swift
//  iTunesSearch
//
//  Created by Daniel Gunawan on 24/09/23.
//

import UIKit

final class LandingView: UIViewController {
    var presenter: LandingViewToPresenter?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var songTableView: UITableView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    
    @IBOutlet weak var musicControlPlayPauseImageView: UIImageView!
    @IBOutlet weak var musicControlContainer: UIView!
    
    let playIcon = UIImage(systemName: "play.circle")
    let pauseIcon = UIImage(systemName: "pause.circle")
    
    init() {
        super.init(nibName: String(describing: LandingView.self), bundle: Bundle(for: LandingView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func didTapPlayPauseButton(_ sender: Any) {
        presenter?.didTapPlayPauseButton()
    }
}

extension LandingView: LandingPresenterToView {
    func configureTableView() {
        let songCell = UINib(nibName: String(describing: SongCell.self), bundle: nil)
        songTableView.separatorStyle = .none
        songTableView.register(songCell, forCellReuseIdentifier: String(describing: SongCell.self))
        
        songTableView.rowHeight = UITableView.automaticDimension
        songTableView.estimatedRowHeight = UITableView.automaticDimension
        songTableView.dataSource = self
        songTableView.delegate = self
        songTableView.separatorStyle = .none
        songTableView.showsVerticalScrollIndicator = false
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.songTableView.reloadData()
        }
    }
    
    func showEmptyDataState() {
        DispatchQueue.main.async {
            self.emptyStateLabel.text = "Empty Data. Kindly update your search keyword."
            self.emptyStateLabel.isHidden = false
        }
    }
    
    func hideEmptyDataState() {
        DispatchQueue.main.async {
            self.emptyStateLabel.isHidden = true
        }
    }
    
    func showApiErrorAlert(message: String) {
        DispatchQueue.main.async {
            self.showAlert(message: message, onClose: nil)
        }
    }
    
    func setMusicControl(isVisible: Bool, isPlaying: Bool) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.musicControlContainer.isHidden = !isVisible
                self.musicControlPlayPauseImageView.tintColor = .gray
                self.musicControlPlayPauseImageView.image = isPlaying ? self.pauseIcon : self.playIcon
            }
        }
    }
}

extension LandingView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter?.didChangeSearchKeyword(keyword: searchBar.text ?? "")
    }
}

extension LandingView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getSongCount() ?? .zero
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let songCell = tableView.dequeueReusableCell(withIdentifier: String(describing: SongCell.self), for: indexPath) as? SongCell,
           let songDetail = presenter?.getSongDetail(at: indexPath.row) {
            songCell.displaySong(detail: songDetail)
            return songCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == presenter?.getSongCount() ?? .zero {
            presenter?.didReachedEndOfTable()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didTapSongDetail(at: indexPath.row)
    }
}
