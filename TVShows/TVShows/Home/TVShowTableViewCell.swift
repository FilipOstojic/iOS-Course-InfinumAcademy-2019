//
//  TVShowTableViewCell.swift
//  TVShows
//
//  Created by Infinum Infinum on 24/07/2019.
//  Copyright © 2019 Infinum Infinum. All rights reserved.
//

import UIKit

class TVShowTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    
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
        //resetirat ostalo kasnije
    }

}

extension TVShowTableViewCell {
    
    func configure(with item: Show) {
        titleLabel.text = item.title
        //ostalo pridružit kasnije
    }
    
}
