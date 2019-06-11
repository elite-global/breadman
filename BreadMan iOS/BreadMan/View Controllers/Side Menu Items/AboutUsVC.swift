//
//  AboutUsVC.swift
//  BreadMan
//
//  Created by apple on 04/06/19.
//  Copyright © 2019 BreadMan. All rights reserved.
//

import UIKit

class AboutUsVC: UIViewController {

    // Outlets
    @IBOutlet weak var btnSideMenu: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        self.btnSideMenu.addTarget(self.revealViewController(), action: Selector(("revealToggle:")), for: UIControl.Event.touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    
    // Button Actions
    
}
