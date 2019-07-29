//
//  CommentsTableViewCell.swift
//  TVShows
//
//  Created by Infinum Infinum on 28/07/2019.
//  Copyright © 2019 Infinum Infinum. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentTextLabel: UILabel!
    
    // MARK: - LifeCycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userImage.image = nil
        usernameLabel.text = ""
        commentTextLabel.text = ""
    }
}

// MARK: - Cell configuration

extension CommentsTableViewCell {
    
    func configure(with item: Comment) {
        userImage.image = getRandomImage()
        usernameLabel.text = UserDefaults.standard.getUsername()
        commentTextLabel.text = item.text
    }
    
    func getRandomImage() -> UIImage {
        let number = Int.random(in: 1 ... 3)
        return UIImage(named: "img-placeholder-user\(number)")!
    }
}
