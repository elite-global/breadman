//
//  RoundedButtons.swift
//  In Time Sheet
//
//  Created by apple on 20/03/19.
//  Copyright © 2019 Sonu Singh. All rights reserved.
//

import UIKit

class RoundedButtons: UIButton {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = 5//self.layer.bounds.size.height/2
        self.backgroundColor = UIColor.white
        self.titleLabel?.textColor = UIColor.appThemeColour
        self.clipsToBounds = true
    }
}
class ProfileButtons: UIButton {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.layer.bounds.size.height/2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.titleLabel?.textColor = UIColor.clear
        self.clipsToBounds = true
    }
}
class ProfileImageVW: UIImageView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.layer.bounds.size.height/2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.clipsToBounds = true
    }
}
extension UIColor {
    static let appThemeColour = UIColor.init(red: 0/255, green: 128/255, blue: 158/255, alpha: 1.0)
    static let appBackColour = UIColor.init(red: 245/255, green: 246/255, blue: 248/255, alpha: 1.0)
}
