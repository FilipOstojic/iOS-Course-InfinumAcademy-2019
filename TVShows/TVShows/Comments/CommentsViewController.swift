//
//  CommentsViewController.swift
//  TVShows
//
//  Created by Infinum Infinum on 28/07/2019.
//  Copyright © 2019 Infinum Infinum. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class CommentsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var comments: [Comment] = []
    var token: String = ""
    var episodeId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchComments()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension CommentsViewController {
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension CommentsViewController {
    
    func fetchComments() {
        SVProgressHUD.show()
        let headers = ["Authorization": token]
        
        Alamofire
            .request("https://api.infinum.academy/api/episodes/\(episodeId)/comments",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<[Comment]>) in
                switch response.result {
                case .success(let commentsResponse):
                    SVProgressHUD.dismiss()
                    self?.comments = commentsResponse
                    self?.tableView.reloadData()
                case .failure( _):
                    SVProgressHUD.showError(withStatus: "Failure")
                }
        }
    }
}

// MARK: - Delegate

extension CommentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - DataSource

extension CommentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentsTableViewCell.self), for: indexPath) as! CommentsTableViewCell
        
        cell.configure(with: comments[indexPath.row])
        
        return cell
    }
}

