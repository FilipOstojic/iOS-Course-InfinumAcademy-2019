//
//  EpisodeDetailsViewController.swift
//  TVShows
//
//  Created by Infinum Infinum on 28/07/2019.
//  Copyright © 2019 Infinum Infinum. All rights reserved.
//

import UIKit

class EpisodeDetailsViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var episodeImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seasonEpisodeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    
    // MARK: - Properties
    
    var episode: Episode?
    var token: String?
    
    // MARK: - LifeCycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAllProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

// MARK: - Private methods

private extension EpisodeDetailsViewController {
    
    func adjustUITextViewHeight(textView : UITextView) {
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.isEditable = false
    }
    
    func setAllProperties() {
        seasonEpisodeLabel.text = String("S" + episode!.season + " Ep" + episode!.episodeNumber)
        descriptionLabel.text = episode!.description
        titleLabel.text = episode!.title
        setImage()
    }
    
    func setImage() {
        let url = URL(string: "https://api.infinum.academy" + episode!.imageUrl)
        episodeImage.kf.setImage(with: url, placeholder: UIImage(named: "login-logo"))
        episodeImage.contentMode = UIView.ContentMode.scaleAspectFill
    }
}

// MARK: - IBOutlets

extension EpisodeDetailsViewController {
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func commentButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Comments", bundle: nil)
        let commentsViewController = storyboard.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
        commentsViewController.token = token
        commentsViewController.episodeId = episode!.id
        self.navigationController?.pushViewController(commentsViewController, animated: true)
    }
}
