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
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var episodeTitleTextView: UITextField!
    @IBOutlet weak var seasonNumberTextView: UITextField!
    @IBOutlet weak var episodeNumberTextView: UITextField!
    @IBOutlet weak var episodeDescriptionTextView: UITextField!
    @IBOutlet weak var cameraButton: UIButton!
    
    // MARK: - Properties
    
    var token: String = ""
    var showId: String = ""
    let imagePickerController = UIImagePickerController()
    var uploadedImage: UIImage?
    
    // MARK: - LifeCycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScreen()
        configureImagePicker()
    }
}

private extension AddShowViewController {
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
        uploadImageOnAPI()
    }
    
    func uploadImageOnAPI() {
        SVProgressHUD.show()
        let headers = ["Authorization": token]
        let imageByteData = uploadedImage!.pngData()
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageByteData!, withName: "file", fileName: "image.png", mimeType: "image/png")
            }, to: "https://api.infinum.academy/api/media",
               method: .post,
               headers: headers)
        { [weak self] result in
            switch result {
            case .success(let uploadRequest, _, _):
                self?.processUploadRequest(uploadRequest)
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    func processUploadRequest(_ uploadRequest: UploadRequest) {
        uploadRequest
            .responseDecodableObject(keyPath: "data") { [weak self] (response: DataResponse<Media>) in
                
                guard let self = self else { return }
                
                switch response.result {
                case .success(let media):
                    self.uploadNewEpisode(mediaID: media.id)
                case .failure( _):
                    SVProgressHUD.showError(withStatus: "Adding episode failed")
                }
        }
    }
    
    func uploadNewEpisode(mediaID: String) {
        SVProgressHUD.show()
        let headers = ["Authorization": token]
        let body: [String:String] = createRequestBody(mediaID)
        
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
                    self?.showAlert(title: "Error", message: "The operation can not be completed")
                }
        }
    }
    
    func createRequestBody(_ mediaID: String) -> [String:String] {
        var tempBody: [String:String] = [:]
        
        tempBody["showId"] = showId
        tempBody["mediaId"] = mediaID
        tempBody["title"] = episodeTitleTextView.text!
        tempBody["description"] = episodeDescriptionTextView.text!
        tempBody["episodeNumber"] = episodeNumberTextView.text!
        tempBody["season"] = seasonNumberTextView.text!
        
        return tempBody
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func configureImagePicker() {
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
    }
}

// MARK: - IBActions

private extension AddShowViewController {
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        self.present(imagePickerController, animated: true, completion: nil)
    }
}

// MARK: - Picker Delegate

extension AddShowViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            uploadedImage = image
            cameraButton.setImage(image, for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Delegate

extension AddShowViewController: UINavigationControllerDelegate {
    
}
