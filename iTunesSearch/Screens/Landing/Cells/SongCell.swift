//
//  SongCell.swift
//  iTunesSearch
//
//  Created by Daniel Gunawan on 24/09/23.
//

import UIKit

class SongCell: UITableViewCell {
    @IBOutlet weak var artworkImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    
    @IBOutlet weak var playingIndicatorImageView: UIImageView!
    
    var currentSongId: UUID?
    let placeholderImg = UIImage(systemName: "ellipsis")?.withTintColor(.lightGray)
    let playingIndicatorImg = UIImage(systemName: "waveform.path")?.withTintColor(.lightGray)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displaySong(detail: SongModel) {
        self.currentSongId = detail.id
        self.titleLabel.text = detail.songTitle
        self.artistNameLabel.text = detail.artistName
        self.albumNameLabel.text = detail.albumName
        
        self.artworkImageView.image = placeholderImg
        self.playingIndicatorImageView.image = playingIndicatorImg
        self.playingIndicatorImageView.isHidden = !detail.isPlaying
        
        fetchImage(for: detail)
    }
    
    func fetchImage(for song: SongModel) {
        if let cacheData = song.cachedImageData, let cachedImage = UIImage(data: cacheData) {
            self.artworkImageView.image = cachedImage
        } else if let artworkUrlString = song.artworkUrl,
                  let artworkUrl = URL(string: artworkUrlString) {
            DispatchQueue.global(qos: .background).async { [weak self] in
                if let imageData = try? Data(contentsOf: artworkUrl) {
                    if let fetchedImage = UIImage(data: imageData), song.id == self?.currentSongId {
                        song.cachedImageData = imageData
                        DispatchQueue.main.async {
                            self?.artworkImageView.image = fetchedImage
                        }
                    }
                }
            }
        }
        
    }
}
