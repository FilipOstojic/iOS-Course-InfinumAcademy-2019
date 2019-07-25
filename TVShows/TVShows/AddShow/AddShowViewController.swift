//
//  AddShowViewController.swift
//  TVShows
//
//  Created by Infinum Infinum on 25/07/2019.
//  Copyright © 2019 Infinum Infinum. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class AddShowViewController: UIViewController {
    
    
    @IBOutlet weak var episodeTitleTextView: UITextField!
    @IBOutlet weak var seasonNumberTextView: UITextField!
    @IBOutlet weak var episodeNumberTextView: UITextField!
    @IBOutlet weak var episodeDescriptionTextView: UITextField!
    
    
    var token: String = ""
    var showId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScreen()
    }
}

extension AddShowViewController {
    func setScreen() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(didSelectCancel)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add",
            style: .plain,
            target: self,
            action: #selector(didSelectAddShow)
        )
        
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 0.4588235294, blue: 0.5490196078, alpha: 1)
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 0.4588235294, blue: 0.5490196078, alpha: 1)
        
        episodeTitleTextView.tintColor = #colorLiteral(red: 1, green: 0.4588235294, blue: 0.5490196078, alpha: 1)
        seasonNumberTextView.tintColor = #colorLiteral(red: 1, green: 0.4588235294, blue: 0.5490196078, alpha: 1)
        episodeNumberTextView.tintColor = #colorLiteral(red: 1, green: 0.4588235294, blue: 0.5490196078, alpha: 1)
        episodeDescriptionTextView.tintColor = #colorLiteral(red: 1, green: 0.4588235294, blue: 0.5490196078, alpha: 1)
        
    }
    
    @objc func didSelectCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didSelectAddShow() {
        SVProgressHUD.show()
        let headers = ["Authorization": token]
        let body: [String:String] = createRequestBody()
        
        Alamofire
            .request("https://api.infinum.academy/api/episodes/",
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
                    self?.didSelectCancel()
                case .failure( _):
                    SVProgressHUD.showError(withStatus: "Failure")
                }
        }
    }
    
    func createRequestBody() -> [String:String] {
        var tempBody: [String:String] = [:]
        
        tempBody["showId"] = showId
        tempBody["mediaId"] = ""
        tempBody["title"] = episodeTitleTextView.text!
        tempBody["description"] = episodeDescriptionTextView.text!
        tempBody["episodeNumber"] = episodeNumberTextView.text!
        tempBody["season"] = seasonNumberTextView.text!
        
        return tempBody
    }
}
