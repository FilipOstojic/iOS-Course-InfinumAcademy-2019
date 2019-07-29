//
//  EpisodeTableViewCell.swift
//  TVShows
//
//  Created by Infinum Infinum on 25/07/2019.
//  Copyright © 2019 Infinum Infinum. All rights reserved.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var seasonEpisodeLabel: UILabel!
    @IBOutlet weak var episodeTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        seasonEpisodeLabel.text = ""
        episodeTitle.text = ""
    }
}

extension EpisodeTableViewCell {
    
    func configure(with item: Episode) {
        seasonEpisodeLabel.text = item.season + item.episodeNumber
        episodeTitle.text = item.title
    }
}
