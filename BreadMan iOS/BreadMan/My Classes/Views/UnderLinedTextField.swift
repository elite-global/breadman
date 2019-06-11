//
//  UnderLinedTextField.swift
//  In Time Sheet
//
//  Created by apple on 21/03/19.
//  Copyright © 2019 Sonu Singh. All rights reserved.
//

import UIKit

class UnderLinedTextField: UITextField {
    
    override func draw(_ rect: CGRect) {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.appThemeColour.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
class AppTextField: UITextField {
    
    override func draw(_ rect: CGRect) {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.masksToBounds = false
        self.textColor = UIColor.white
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightText])
        self.tintColor = UIColor.white
    }
}
