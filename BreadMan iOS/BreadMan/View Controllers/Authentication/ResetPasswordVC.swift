//
//  ResetPasswordVC.swift
//  BreadMan
//
//  Created by apple on 13/05/19.
//  Copyright © 2019 BreadMan. All rights reserved.
//

import UIKit
import SVProgressHUD

class ResetPasswordVC: UIViewController {

    var strEmail = ""
    
    // Outlets
    @IBOutlet weak var txtOTP: AppTextField!
    @IBOutlet weak var txtPassword: AppTextField!
    @IBOutlet weak var txtConfirmPassword: AppTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        
        // Do any additional setup after loading the view.
    }
    

    // Buttona Actions
    @IBAction func clickedResetBtn(_ sender: Any) {
        
        if self.txtOTP.isEmpty() {
            self.showAlert(msg: "Enter OTP")
            return
        }
        if self.txtPassword.isEmpty() {
            self.showAlert(msg: "Enter password")
            return
        }
        if self.txtConfirmPassword.isEmpty() {
            self.showAlert(msg: "Enter confirm password")
            return
        }
        if self.txtPassword.text != self.txtConfirmPassword.text {
            self.showAlert(msg: "Password mismatched")
            return
        }
        
//        let response = Validation.shared.validate(values: (ValidationType.password, self.txtPassword.text ?? ""),(ValidationType.password, self.txtConfirmPassword.text ?? ""))
//        switch response {
//        case .success:
//
            self.apiResetPassword()
            
//            break
//        case .failure(_, let message):
//            print(message.localized())
//            self.showAlert(msg: message.localized())
//        }
    }
    @IBAction func clickedResendOTP(_ sender: Any) {
        
        self.apiResendOTP()
    }
    @IBAction func clickedGoSignIn(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // Api Call
    func apiResetPassword() {
        
        SVProgressHUD.show()
        if ConnectionCheck.isConnectedToNetwork()
        {
            let headers = ["Content-Type":"application/x-www-form-urlencoded", "token":""]
            var param = [String:AnyObject]()
            
            param["email"] = self.strEmail as AnyObject?
            param["otp"] = self.txtOTP.text as AnyObject?
            param["new_password"] = self.txtPassword.text as AnyObject?
            
            print("parameters: ", param)
            
            ApiManager.requestApi(method: .post, urlString: "resetpassword", parameters: param, headers: headers, success: { (responseObject) in
                
//                print(responseObject)
                
                if responseObject["status"] as! Bool == true {
                    SVProgressHUD.dismiss()
                    self.navigationController?.popToRootViewController(animated: false)
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    SVProgressHUD.dismiss()
                    if responseObject["error"] as? String != "" {
                        self.showAlert(msg: responseObject["error"] as! String)
                    }
                    else {
                        self.showAlert(msg: responseObject["message"] as! String)
                    }
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
                self.apiResetPassword()
            }
        }
    }
    // Resend Otp
    func apiResendOTP() {
        
        SVProgressHUD.show()
        if ConnectionCheck.isConnectedToNetwork()
        {
            let headers = ["Content-Type":"application/x-www-form-urlencoded", "token":""]
            var param = [String:AnyObject]()
            
            param["email"] = self.strEmail as AnyObject?
            
            print("parameters: ", param)
            
            ApiManager.requestApi(method: .post, urlString: "forgetpassword", parameters: param, headers: headers, success: { (responseObject) in
                
                print(responseObject)
                
                if responseObject["status"] as! Bool == true {
                    SVProgressHUD.dismiss()
                    self.showAlert(msg: "OTP sent. Please check your email!")
                }
                else {
                    SVProgressHUD.dismiss()
                    if responseObject["error"] as? String != "" {
                        self.showAlert(msg: responseObject["error"] as! String)
                    }
                    else {
                        self.showAlert(msg: responseObject["message"] as! String)
                    }
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
                self.apiResendOTP()
            }
        }
    }
}
