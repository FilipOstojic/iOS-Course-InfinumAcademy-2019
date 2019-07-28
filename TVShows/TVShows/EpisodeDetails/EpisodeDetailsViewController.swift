//
//  EpisodeDetailsViewController.swift
//  TVShows
//
//  Created by Infinum Infinum on 28/07/2019.
//  Copyright © 2019 Infinum Infinum. All rights reserved.
//

import UIKit

class EpisodeDetailsViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var episodeImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seasonEpisodeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    
    
    var episode: Episode?
    var token: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAllProperties()
    }
}


extension EpisodeDetailsViewController {
    
    func adjustUITextViewHeight(textView : UITextView) {
        textView.translatesAutoresizingMaskIntoConstraints = true
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.isEditable = false
    }
    
    func setAllProperties() {
        seasonEpisodeLabel.text = String("S" + episode!.season + " Ep" + episode!.episodeNumber)
        descriptionLabel.text = episode!.description
        titleLabel.text = episode!.title
    }
}


extension EpisodeDetailsViewController {
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func commentButtonTapped(_ sender: UIButton) {
        
    }
}
