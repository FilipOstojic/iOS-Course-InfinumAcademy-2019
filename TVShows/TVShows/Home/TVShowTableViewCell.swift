//
//  TVShowTableViewCell.swift
//  TVShows
//
//  Created by Infinum Infinum on 24/07/2019.
//  Copyright © 2019 Infinum Infinum. All rights reserved.
//

import UIKit
import Kingfisher

class TVShowTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    // MARK: - LifeCycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        thumbnail.image = UIImage(named: "login-logo")
    }

}

extension TVShowTableViewCell {
    
    func configure(with item: Show) {
        titleLabel.text = item.title
        let url = URL(string: "https://api.infinum.academy" + item.imageUrl)
        thumbnail.kf.setImage(with: url, placeholder: UIImage(named: "login-logo"))
    }
    
}
