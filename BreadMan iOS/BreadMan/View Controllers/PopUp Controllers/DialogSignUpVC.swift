//
//  DialogSignUpVC.swift
//  BreadMan
//
//  Created by apple on 13/05/19.
//  Copyright © 2019 BreadMan. All rights reserved.
//

import UIKit

class DialogSignUpVC: UIViewController {

    var delegate: DialogSignUpTypeDelegates?
    
    // Outlets
    @IBOutlet weak var viewMain: RoundCornersView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch? = touches.first
        
        if touch?.view != self.viewMain {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    // Button Actions
    @IBAction func clickedCustomer(_ sender: Any) {
        self.dismiss(animated: false, completion: {
            User.isVendor = false
            self.delegate?.moveToSignUp(type: "C U S T O M E R")
        })
    }
    @IBAction func clickedRender(_ sender: Any) {
        self.dismiss(animated: false, completion: {
            User.isVendor = true
            self.delegate?.moveToSignUp(type: "S U P P L I E R / V E N D O R")
        })
    }
    
}
