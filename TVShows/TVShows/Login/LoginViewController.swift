//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Infinum on 09/07/2019.
//  Copyright © 2019 Infinum Infinum. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    var counter = 0
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var clickButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLabel()
        initButton()
    }
    
    func initLabel() -> Void {
        counterLabel.text = String(counter)
    }
    
    func initButton() -> Void {
        clickButton.layer.borderColor = #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1)
        clickButton.layer.borderWidth = 2
        clickButton.layer.cornerRadius = 15
        
        clickButton.setImage(UIImage(named: "256.png"), for: .normal)
        clickButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 0)
        
        //clickButton.titleLabel?.text = "CLICK"
        clickButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
    }
    
    @IBAction func buttonClicked(_ sender:UIButton){
        counter += 1
        counterLabel.text = String(counter)
        shake()
        changeColor()
    }
    
    func changeColor() -> Void {
        let redFloat = randomCGFloat()
        let greenFloat = randomCGFloat()
        let blueFloat = randomCGFloat()
        
        counterLabel.backgroundColor = UIColor(red: redFloat,
                                               green: greenFloat,
                                               blue: blueFloat,
                                               alpha: 1.0)
        
        if isColorLight(red: Int(redFloat*255), green: Int(greenFloat*255), blue: Int(blueFloat*255)) {
            counterLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            counterLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    func isColorLight(red:Int, green:Int, blue: Int) -> Bool {
        return ((red * 299) + (green * 587) + (blue * 114)) / 1000 >= 128
    }
    
    func randomCGFloat() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX)
    }
    
    func shake() {
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
