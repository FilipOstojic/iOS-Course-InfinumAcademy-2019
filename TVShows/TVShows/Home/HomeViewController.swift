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

class HomeViewController: UIViewController {
    
    var token: String = ""
    private var shows: [Show] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getShows()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

private extension HomeViewController {
    
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
                case .failure( _):
                    SVProgressHUD.showError(withStatus: "Failure")
                }
        
            }
    
    }
}
