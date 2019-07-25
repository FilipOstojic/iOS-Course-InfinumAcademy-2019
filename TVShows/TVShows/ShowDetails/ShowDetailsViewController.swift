//
//  ShowDetailsViewController.swift
//  TVShows
//
//  Created by Infinum Infinum on 24/07/2019.
//  Copyright © 2019 Infinum Infinum. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class ShowDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var numberOfEpisodesLabel: UILabel!
    @IBOutlet weak var addNewEpisodeButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var showId:String = ""
    var token:String = ""
    var episodes: [Episode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        setShowDetails()
    }
}


extension ShowDetailsViewController {
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension ShowDetailsViewController {
    
    func setShowDetails() {
        SVProgressHUD.show()
        let headers = ["Authorization": token]
        
        Alamofire
            .request("https://api.infinum.academy/api/shows/\(showId)",
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<ShowDetails>) in
                switch response.result {
                case .success(let response):
                    SVProgressHUD.dismiss()
                    self?.descriptionTextView.text = response.description
                    self?.titleLabel.text = response.title
                    self?.getEpisodes()
                case .failure( _):
                    SVProgressHUD.showError(withStatus: "Failure")
                }
        }
    }
    
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}


extension ShowDetailsViewController {
    
    func getEpisodes() {
        SVProgressHUD.show()
        let headers = ["Authorization": token]
        
        Alamofire
            .request("https://api.infinum.academy/api/shows/\(showId)/episodes",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<[Episode]>) in
                switch response.result {
                case .success(let listOfEpisodes):
                    SVProgressHUD.dismiss()
                    self?.numberOfEpisodesLabel.text = String(listOfEpisodes.count)
                    self?.episodes = listOfEpisodes
                case .failure( _):
                    SVProgressHUD.showError(withStatus: "Failure")
                }
        }
    }
}

