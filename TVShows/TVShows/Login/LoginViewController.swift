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
    
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var checkButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameLine: UIView!
    @IBOutlet weak var passwordLine: UIView!
    
    // MARK: - properties
    
    private var loginUser: LoginData?
    private var remeberMe: Bool = false
    
    // MARK: - lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCursorColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        resetTextViews()
        remeberMeNavigation()
    }
    
}

// MARK: - IBActions

private extension LoginViewController {
    
    @IBAction private func checkChange(_ sender: UIButton) {
        checkButton.isSelected.toggle()
        remeberMe.toggle()
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            !inputsAreEmpty()
        else {
//            showAlert(title: "Registration error",  message: "\nPlease enter username and password")
            usernameTextField.shake()
            passwordTextField.shake()
            return
        }
        
        registerUserWith(email: username, password: password)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            !inputsAreEmpty()
        else {
//            showAlert(title: "Login error",  message: "\nPlease enter username and password")
            usernameTextField.shake()
            passwordTextField.shake()
            return
        }
        
        loginUserWith(email: username, password: password)
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
        let email = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if email.isEmpty || password.isEmpty {
            setLineColor(color: .red)
            return true
        }
        return false
    }
    
    func setLineColor(color: UIColor) {
        usernameLine.backgroundColor = color
        passwordLine.backgroundColor = color
    }
    
    func navigateToHome() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeViewController.token = loginUser!.token
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func resetTextViews() {
        usernameTextField.text = ""
        passwordTextField.text = ""
        checkButton.isSelected = false
        remeberMe = false
    }
    
    func remeberMeNavigation() {
        if UserDefaults.standard.getRemeberMe() {
            usernameTextField.text = UserDefaults.standard.getUsername()
            passwordTextField.text = UserDefaults.standard.getPassword()
            checkButton.isSelected = UserDefaults.standard.getRemeberMe()
            remeberMe = UserDefaults.standard.getRemeberMe()
            loginButtonTapped(loginButton)
        }
    }
    
    func setUserDefaults() {
        UserDefaults.standard.setRemeberMe(value: remeberMe)
        UserDefaults.standard.setPassword(password: passwordTextField.text!)
        UserDefaults.standard.setUsername(value: usernameTextField.text!)
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
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<User>) in
                
                switch response.result {
                case .success( _):
                    self?.loginUserWith(email: email, password: password)
                case .failure( _):
                    self?.setLineColor(color: .red)
                    SVProgressHUD.showError(withStatus: "Failure")
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
        
        Alamofire
            .request(
                "https://api.infinum.academy/api/users/sessions",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<LoginData>) in
                switch response.result {
                case .success(let loginToken):
                    SVProgressHUD.showSuccess(withStatus: "Success")
                    self?.loginUser = loginToken
                    self?.setUserDefaults()
                    self?.navigateToHome()
                case .failure( _):
                    self?.setLineColor(color: .red)
                    SVProgressHUD.showError(withStatus: "Failure")
                }
        }
    }
}

// MARK: - Animations

private extension UITextField {
    
    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
}


