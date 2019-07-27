//
//  HomeViewController.swift
//  TVShows
//
//  Created by Infinum Infinum on 16/07/2019.
//  Copyright © 2019 Infinum Infinum. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import Kingfisher

final class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    
    // MARK: - Properties
    
    var token: String = ""
    var shows: [Show] = []
    
    // MARK: - LifeCycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getShows()
        setupTableView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension HomeViewController {
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        UserDefaults.standard.setRemeberMe(value: false)
        navigationController?.popToRootViewController(animated: true)
    }
    
}

// MARK: API call to get all TVShows

extension HomeViewController {
    
    func getShows() {
        SVProgressHUD.show()
        let headers = ["Authorization": token]

        Alamofire
            .request("https://api.infinum.academy/api/shows",
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<[Show]>) in
                switch response.result {
                case .success(let showsResponse):
                    SVProgressHUD.dismiss()
                    self?.shows = showsResponse
                    self?.tableView.reloadData()
                case .failure( _):
                    SVProgressHUD.showError(withStatus: "Failure")
                }
            }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func navigateToShowDetails(showID: String, userToken: String, url: String) {
        let storyboard = UIStoryboard(name: "ShowDetails", bundle: nil)
        let showDetailsViewController = storyboard.instantiateViewController(withIdentifier: "ShowDetailsViewController") as! ShowDetailsViewController
        showDetailsViewController.showId = showID
        showDetailsViewController.token = userToken
        showDetailsViewController.imageUrl = url
        self.navigationController?.pushViewController(showDetailsViewController, animated: true)
    }
}


// MARK: - Delegate

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let show = shows[indexPath.row]
        navigateToShowDetails(showID: show.id, userToken: token, url: show.imageUrl)
    }
}

// MARK: - DataSource

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TVShowTableViewCell.self), for: indexPath) as! TVShowTableViewCell

        cell.configure(with: shows[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (action, indexPath) in
            self?.shows.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
        
        return [delete]
    }
}
