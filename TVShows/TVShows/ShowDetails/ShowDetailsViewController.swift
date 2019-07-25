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
    
    @IBOutlet weak var tebleView: UITableView!
    
    var showId: String = ""
    var token: String = ""
    var episodes: [Episode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        setUpTableView()
        setShowDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setShowDetails()
    }
}


extension ShowDetailsViewController {
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AddShow", bundle: nil)
        let addShowViewController = storyboard.instantiateViewController(withIdentifier: "AddShowViewController") as! AddShowViewController
        addShowViewController.token = self.token
        addShowViewController.showId = self.showId
        let navigationController = UINavigationController(rootViewController: addShowViewController)
        present(navigationController, animated: true)
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
    
    func setUpTableView() {
        tebleView.delegate = self
        tebleView.dataSource = self
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
                    self?.tebleView.reloadData()
                    
                case .failure( _):
                    SVProgressHUD.showError(withStatus: "Failure")
                }
        }
    }
}

// MARK: - Delegate

extension ShowDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - DataSource

extension ShowDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EpisodeTableViewCell.self), for: indexPath) as! EpisodeTableViewCell
        
        cell.configure(with: episodes[indexPath.row])
        
        return cell
    }

}
