//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Infinum on 09/07/2019.
//  Copyright © 2019 Infinum Infinum. All rights reserved.
//

import Foundation
import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - outlets
    
    @IBOutlet private weak var checkBtn: UIButton!
    @IBOutlet private weak var loginBtn: UIButton!
    @IBOutlet private weak var registerBtn: UIButton!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    // MARK: - properties
    
    private var checked = false
    
    // MARK: - lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCursorColor()
    }
    
    // MARK: - actions
    
    @IBAction private func checkChange(_ sender: UIButton) {
        
        if !checked {
            sender.setImage(UIImage(named: "ic-checkbox-filled"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "ic-checkbox-empty"), for: .normal)
        }
        
        checked = checked ? false : true;
    }
    
    // MARK: - private methods
    
    private func setCursorColor() -> Void {
        usernameTextField.tintColor = #colorLiteral(red: 1, green: 0.4588235294, blue: 0.5490196078, alpha: 1)
        passwordTextField.tintColor = #colorLiteral(red: 1, green: 0.4588235294, blue: 0.5490196078, alpha: 1)
    }
    
}
