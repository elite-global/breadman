//
//  ChangePasswordVC.swift
//  BreadMan
//
//  Created by apple on 31/05/19.
//  Copyright © 2019 BreadMan. All rights reserved.
//

import UIKit
import SVProgressHUD

class ChangePasswordVC: UIViewController {

    // Outlets
    @IBOutlet weak var txtOldPassword: AppTextField!
    @IBOutlet weak var txtNewPassword: AppTextField!
    @IBOutlet weak var txtConfirmPassword: AppTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Button Actions
    @IBAction func clickedBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func clickedChangePassword(_ sender: Any) {
        
        if self.txtOldPassword.isEmpty() {
            self.showAlert(msg: "Enter old password")
            return
        }
        if self.txtNewPassword.isEmpty() {
            self.showAlert(msg: "Enter new password")
            return
        }
        if self.txtConfirmPassword.isEmpty() {
            self.showAlert(msg: "Enter confirm password")
            return
        }
        if self.txtNewPassword.text != self.txtConfirmPassword.text {
            self.showAlert(msg: "Password mismatched")
            return
        }
        // Call Api
        self.apiChangePassword()
    }
    
    // Api
    func apiChangePassword() {
        
        SVProgressHUD.show()
        if ConnectionCheck.isConnectedToNetwork()
        {
            let headers = ["Content-Type":"application/x-www-form-urlencoded", "token":""]
            var param = [String:AnyObject]()
            
            param["user_id"] = User.user_id as AnyObject?
            param["old_password"] = self.txtOldPassword.text as AnyObject?
            param["new_password"] = self.txtNewPassword.text as AnyObject?
            
//            print("parameters: ", param)
            
            ApiManager.requestApi(method: .post, urlString: "changePassword", parameters: param, headers: headers, success: { (responseObject) in
                
                                print(responseObject)
                
                if responseObject["status"] as? Bool == true {
                    SVProgressHUD.dismiss()
                    
//                    DispatchQueue.main.async {
                        self.showAlert(msg: responseObject["message"] as! String)
                        self.navigationController?.popViewController(animated: true)
//                    }
                }
                else {
                    SVProgressHUD.dismiss()
                    self.showAlert(msg: responseObject["message"] as! String)
                }
                
            }) { (error) -> Void in
                SVProgressHUD.dismiss()
                self.showAlert(msg: error.localizedDescription)
            }
        }
        else {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                SVProgressHUD.dismiss()
                self.showNetworkAlert(apiToCall: "action")
                self.apiChangePassword()
            }
        }
    }
}
