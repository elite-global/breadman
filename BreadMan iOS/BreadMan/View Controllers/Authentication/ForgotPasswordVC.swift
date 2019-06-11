//
//  ForgotPasswordVC.swift
//  BreadMan
//
//  Created by apple on 13/05/19.
//  Copyright © 2019 BreadMan. All rights reserved.
//

import UIKit
import SVProgressHUD

class ForgotPasswordVC: UIViewController {

    // Outlets
    @IBOutlet weak var txtEmail: AppTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    // Buttona Actions
    @IBAction func clickedSendOTP(_ sender: Any) {
        
        if self.txtEmail.isEmpty() {
            self.showAlert(msg: "Enter email")
            return
        }
        
        let response = Validation.shared.validate(values: (ValidationType.email, self.txtEmail.text ?? ""))
        switch response {
        case .success:
            
            self.apiSendOTP()
            
            break
        case .failure(_, let message):
            print(message.localized())
            self.showAlert(msg: message.localized())
        }
    }
    @IBAction func clickedGoSignIn(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    // Api Call
    func apiSendOTP() {
        
        SVProgressHUD.show()
        if ConnectionCheck.isConnectedToNetwork()
        {
            let headers = ["Content-Type":"application/x-www-form-urlencoded", "token":""]
            var param = [String:AnyObject]()
            
            //            param["device_id"] = User.deviceToken as AnyObject?
            //            param["user_id"] = User.user_id as AnyObject?
            param["email"] = self.txtEmail.text as AnyObject?
            //            param["user_id"] = AppDelegate.user_id as AnyObject?
            //            param["poster_id"] = self.strPosterID as AnyObject?
            //            param["cancel_reason"] = self.strCancelReason as AnyObject?
            //            param["cancel_comment"] = self.txtComment.text as AnyObject?
            
            print("parameters: ", param)
            
            ApiManager.requestApi(method: .post, urlString: "forgetpassword", parameters: param, headers: headers, success: { (responseObject) in
                SVProgressHUD.dismiss()
//                print(responseObject)
                
                if responseObject["status"] as? Bool == true {
                    
//                    self.showAlert(msg: "OTP sent. Please check your email!")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
                    vc.strEmail = self.txtEmail.text ?? ""
//                    vc.isForgotPassword = true
//                    vc.strUserId = responseObject["data"]?["id"] as? String ?? ""
                    self.navigationController?.pushViewController(vc
                        , animated: true)
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
                self.apiSendOTP()
            }
        }
    }
}
