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
    @IBOutlet weak var inputCommentTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet var inputBarBottomConstraint: NSLayoutConstraint!
    
    var comments: [Comment] = []
    var token: String = ""
    var episodeId: String = ""
    let refresher = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchComments()
        setupTableView()
//        showEmptyState()
        addKeyboardEventsHandlers()
        setUpRefresheControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
//    func showEmptyState() {
//        if comments.count == 0 {
//            let imageView = UIImageView()
//            imageView.image = UIImage(named: "img-placeholder-comments")
//            tableView.backgroundView = imageView
//        }
//    }
    
    private func addKeyboardEventsHandlers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func setUpRefresheControl() {
        refresher.tintColor = #colorLiteral(red: 1, green: 0.4588235294, blue: 0.5490196078, alpha: 1)
        refresher.addTarget(self, action: #selector(updateTableView), for: .valueChanged)
        tableView.refreshControl = refresher
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        var userInfo = notification.userInfo!
        var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        inputBarBottomConstraint.constant = keyboardFrame.size.height
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        var userInfo = notification.userInfo!
        var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        inputBarBottomConstraint.constant = 0
    }
    
    @objc func updateTableView() {
        fetchComments()
        let delay = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: delay) { [weak self] in
            self?.refresher.endRefreshing()
        }
    }
    
}

extension CommentsViewController {
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func postButtonTapped(_ sender: UIButton) {
        SVProgressHUD.show()
        let headers = ["Authorization": token]
        let body: [String:String] = [ "text": inputCommentTextField.text!,
                                      "episodeId": episodeId ]
        
        Alamofire
            .request("https://api.infinum.academy/api/comments/",
                     method: .post,
                     parameters: body,
                     encoding: JSONEncoding.default,
                     headers: headers
            )
            .validate()
            .responseData() { [weak self] response in
                switch response.result {
                case .success( _):
                    SVProgressHUD.dismiss()
                    self?.inputCommentTextField.text = ""
                    self?.fetchComments()
                case .failure( _):
                    SVProgressHUD.showError(withStatus: "Failure")
                }
        }
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

