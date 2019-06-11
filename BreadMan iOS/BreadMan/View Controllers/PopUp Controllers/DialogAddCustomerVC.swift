//
//  DialogAddCustomerVC.swift
//  BreadMan
//
//  Created by apple on 01/06/19.
//  Copyright © 2019 BreadMan. All rights reserved.
//

import UIKit

class DialogAddCustomerVC: UIViewController {
    
    var delegate: NotificationPageDelegates?
    
    // Outlets
    @IBOutlet weak var viewMain: UIView!
    
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
    @IBAction func clickedAccept(_ sender: Any) {
        
        self.dismiss(animated: false, completion: {
            self.delegate?.removeAcceptedNotificationFromList()
        })
    }
}
