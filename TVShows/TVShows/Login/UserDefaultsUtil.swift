//
//  UserDefaultsUtil.swift
//  TVShows
//
//  Created by Infinum Infinum on 28/07/2019.
//  Copyright © 2019 Infinum Infinum. All rights reserved.
//

import Foundation
import UIKit

extension UserDefaults {
    
    func setRemeberMe(value: Bool) {
        set(value, forKey: "remeberMe")
        synchronize()
    }
    
    func getRemeberMe() -> Bool {
        return bool(forKey: "remeberMe")
    }
    
    func setUsername(value: String) {
        set(value, forKey: "username")
        synchronize()
    }
    
    func getUsername() -> String {
        return string(forKey: "username")!
    }
    
    func setPassword(password: String) {
        set(password, forKey: "password")
        synchronize()
    }
    
    func getPassword() -> String {
        return string(forKey: "password")!
    }
}
