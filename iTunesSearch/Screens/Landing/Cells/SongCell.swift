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
        self.titleLabel.text = detail.songTitle
        self.artistNameLabel.text = detail.artistName
        self.albumNameLabel.text = detail.albumName
        
        self.artworkImageView.image = placeholderImg
        self.playingIndicatorImageView.image = playingIndicatorImg
        self.playingIndicatorImageView.isHidden = !detail.isPlaying
    }
}
