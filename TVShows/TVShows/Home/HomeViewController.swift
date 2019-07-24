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

final class HomeViewController: UIViewController {
    
    var token: String = ""
    var shows: [Show] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getShows()
        setupTableView()
    }
}

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
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
    }
}

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = shows[indexPath.row]
        print("Selected Item: \(item)")
    }
}

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
