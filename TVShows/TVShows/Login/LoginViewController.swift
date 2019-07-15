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
    
    private var counter = 0;
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var clickButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLabel()
        initButton()
    }
    
    private func initLabel() -> Void {
        counterLabel.text = String(counter)
    }
    
    private func initButton() -> Void {
        clickButton.layer.borderColor = #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1)
        clickButton.layer.borderWidth = 2
        clickButton.layer.cornerRadius = 15
    }
    
    @IBAction private func buttonClicked(_ sender:UIButton){
        counter += 1
        counterLabel.text = String(counter)
        shake()
        changeColor()
    }
    
    private func changeColor() -> Void {
        let redFloat = CGFloat.random(in: 0 ... 1)
        let greenFloat = CGFloat.random(in: 0 ... 1)
        let blueFloat = CGFloat.random(in: 0 ... 1)
        
        counterLabel.backgroundColor = UIColor(
            red: redFloat,
            green: greenFloat,
            blue: blueFloat,
            alpha: 1.0
        )
        
        if (counterLabel.backgroundColor?.isLight())! {
            counterLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            counterLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    private func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: clickButton.center.x - 5, y: clickButton.center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: clickButton.center.x + 5, y: clickButton.center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        clickButton.layer.add(shake, forKey: "position")
    }
    
}

extension UIColor {
    
    func isLight() -> Bool {
        guard
            let components = cgColor.components
            else {
                return false
        }
        
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        return brightness > 0.5
    }
    
}

