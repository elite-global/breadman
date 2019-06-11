//
//  DialogAddSupplierVC.swift
//  BreadMan
//
//  Created by apple on 31/05/19.
//  Copyright © 2019 BreadMan. All rights reserved.
//

import UIKit

class DialogAddSupplierVC: UIViewController {

    var delegate: DialogAddSupplierDelegates?
    
    // Outlets
    @IBOutlet weak var viewMain: RoundCornersView!
    @IBOutlet weak var txtSupplierId: AppTextField!
    
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
    @IBAction func clickedAdd(_ sender: Any) {
        
        if self.txtSupplierId.isEmpty() {
            self.showAlert(msg: "Enter supplier id")
            return
        }
        else if self.txtSupplierId.text?.count ?? 0 < 6 {
            self.showAlert(msg: "Enter valid supplier id")
            return
        }
        
        let a = self.txtSupplierId.text!
        let startIndex = 2 // random for this example
        let endIndex = a.count
        
        let start = String.Index(utf16Offset: startIndex, in: a)
        let end = String.Index(utf16Offset: endIndex, in: a)
        
        let substring = String(a[start..<end])
        if substring != "9898" {
            self.showAlert(msg: "Enter valid supplier id")
            return
        }
        
        if let endIndex = a.range(of: "9898")?.lowerBound {
            print(a[..<endIndex])
            self.dismiss(animated: false, completion: {
                self.delegate?.addSupplier(id: "\(a[..<endIndex])")
            })
        }
//        self.dismiss(animated: false, completion: {
//            self.delegate?.addSupplier(id: a[0..<endIndex])
//        })
    }
}
