//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Infinum on 09/07/2019.
//  Copyright © 2019 Infinum Infinum. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

final class LoginViewController: UIViewController {
    
    // MARK: - outlets
    
    @IBOutlet private weak var checkBtn: UIButton!
    @IBOutlet private weak var loginBtn: UIButton!
    @IBOutlet private weak var registerBtn: UIButton!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var usernameLine: UIView!
    @IBOutlet weak var passwordLine: UIView!
    
    // MARK: - properties
    
    private var checked = false
    
    // MARK: - lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCursorColor()
        resetErrorLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
}

// MARK: - IBActions

private extension LoginViewController {
    
    @IBAction private func checkChange(_ sender: UIButton) {
        if !checked {
            sender.setImage(UIImage(named: "ic-checkbox-filled"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "ic-checkbox-empty"), for: .normal)
        }
        checked.toggle()
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        if inputsAreEmpty() {
            return
        }
        
        guard let email = usernameTextField.text, let password = passwordTextField.text else {
            self.errorMessage(message: "Username or password type fail.")
            return
        }
        
        registerUserWith(email: email, password: password)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if inputsAreEmpty() {
            return
        }
        
        guard let email = usernameTextField.text, let password = passwordTextField.text else {
            self.errorMessage(message: "Username or password type fail.")
            return
        }
        
        loginUserWith(email: email, password: password)
    }
    
    @IBAction func usernameValueChanged(_ sender: UITextField) {
        setLineColor(color: .darkGray)
    }
    
    @IBAction func passwordValueChanged(_ sender: UITextField) {
        setLineColor(color: .darkGray)
    }
}

// MARK: - private methods

private extension LoginViewController {
    
    func setCursorColor() -> Void {
        usernameTextField.tintColor = #colorLiteral(red: 1, green: 0.4588235294, blue: 0.5490196078, alpha: 1)
        passwordTextField.tintColor = #colorLiteral(red: 1, green: 0.4588235294, blue: 0.5490196078, alpha: 1)
    }
    
    func inputsAreEmpty() -> Bool {
        let email:String = usernameTextField.text ?? ""
        let password:String = passwordTextField.text ?? ""
        
        if email.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == "" {
            errorMessage(message: "Fields should not be empty.")
            setLineColor(color: .red)
            return true
        }
        
        if password.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == "" {
            errorMessage(message: "Fields should not be empty.")
            setLineColor(color: .red)
            return true
        }
        return false
    }
    
    func errorMessage(message: String) -> Void {
        errorLabel.text = message
    }
    
    func resetErrorLabel() -> Void {
        errorLabel.text = ""
        setLineColor(color: .darkGray)
    }
    
    func setLineColor(color: UIColor) {
        usernameLine.backgroundColor = color
        passwordLine.backgroundColor = color
    }
    
    func navigateToHome() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
}

// MARK: - Register + automatic JSON parsing

private extension LoginViewController {
    
    func registerUserWith(email: String, password: String) {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        Alamofire
            .request(
                "https://api.infinum.academy/api/users",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { (response: DataResponse<User>) in
                switch response.result {
                case .success( _):
                    self.loginUserWith(email: email, password: password)
                case .failure( _):
                    SVProgressHUD.showError(withStatus: "Failure")
                    self.errorMessage(message: "Can not reach server.")
                }
        }
    }
}

// MARK: - Login + automatic JSON parsing

private extension LoginViewController {

    func loginUserWith(email: String, password: String) {
        SVProgressHUD.show()
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        loginBtn.isEnabled = false
        Alamofire
            .request(
                "https://api.infinum.academy/api/users/sessions",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { (response: DataResponse<LoginData>) in
                switch response.result {
                case .success( _):
                    SVProgressHUD.showSuccess(withStatus: "Success")
                    self.navigateToHome()
                case .failure( _):
                    self.errorMessage(message: "Wrong username and/or password.")
                    SVProgressHUD.showError(withStatus: "Failure")
                }
                self.loginBtn.isEnabled = true
        }
    }

}
