//
//  TVShowTableViewCell.swift
//  TVShows
//
//  Created by Infinum Infinum on 24/07/2019.
//  Copyright © 2019 Infinum Infinum. All rights reserved.
//

import UIKit

class TVShowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        //resetirat ostalo
    }

}

extension TVShowTableViewCell {
    func configure(with item: Show) {
        titleLabel.text = item.title
        //ostalo pridružit kasnije isto ovdje
    }
}
