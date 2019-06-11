//
//  HomeVC.swift
//  BreadMan
//
//  Created by apple on 26/05/19.
//  Copyright © 2019 BreadMan. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    var strTitle = "Home Page"
    
    // Outlets
    @IBOutlet weak var btnSideMenu: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.strTitle
        self.navigationController?.isNavigationBarHidden = false
        self.btnSideMenu.addTarget(self.revealViewController(), action: Selector(("revealToggle:")), for: UIControl.Event.touchUpInside)
        
        if User.isVendor {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RenderProfileVC") as! RenderProfileVC
            let navigation = storyboard?.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
            navigation.viewControllers = [vc]
            self.revealViewController().pushFrontViewController(navigation, animated: false)
        }
        
        // Do any additional setup after loading the view.
    }
    
    // Button Actions
   
}
