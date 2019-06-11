//
//  AlertView.swift
//  In Time Sheet
//
//  Created by apple on 20/03/19.
//  Copyright © 2019 Sonu Singh. All rights reserved.
//

import UIKit

class BorderCornersView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.clipsToBounds = true
    }
}
class RoundCornersView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
}
class ShadowView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 5
    }
}
