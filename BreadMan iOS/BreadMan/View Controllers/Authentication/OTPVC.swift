//
//  OTPVC.swift
//  BreadMan
//
//  Created by apple on 22/05/19.
//  Copyright © 2019 BreadMan. All rights reserved.
//

import UIKit
import SVProgressHUD

class OTPVC: UIViewController {

    var strEmail = ""
    var strUserId = ""
    var isForgotPassword = false
    
    // Outlets
    @IBOutlet weak var txtOTP: AppTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.showAlert(msg: "OTP sent. Please check your email!")
    }
    // Button Actions
    @IBAction func clickedResendOTP(_ sender: Any) {
        self.apiResendOTP()
    }
    @IBAction func clickedVerify(_ sender: Any) {
        
        if self.txtOTP.isEmpty() {
            self.showAlert(msg: "Enter OTP")
            return
        }
        
        let response = Validation.shared.validate(values: (ValidationType.otp, self.txtOTP.text ?? ""))
        switch response {
        case .success:
            
            self.apiVerifyOTP(otp: self.txtOTP.text ?? "")
            
            //            if self.txtEmail.text == "vendor@gmail.com" {
            //                User.isVendor = true
            //            }
            //            else {
            //                User.isVendor = false
            //            }
            //            self.appDelegate.changeRootViewControllerToSWRevealViewController()
            
            break
        case .failure(_, let message):
            print(message.localized())
            self.showAlert(msg: message.localized())
        }
    }
    @IBAction func clickedLogin(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // Api Call
    func apiVerifyOTP(otp: String) {
        
        SVProgressHUD.show()
        if ConnectionCheck.isConnectedToNetwork()
        {
            let headers = ["Content-Type":"application/x-www-form-urlencoded", "token":""]
            var param = [String:AnyObject]()
            
            if self.isForgotPassword == true {
                param["user_id"] = self.strUserId as AnyObject?
            }
            else {
                param["user_id"] = User.user_id as AnyObject?
            }
            param["otp"] = self.txtOTP.text as AnyObject?
            
            print("parameters: ", param)
            
            ApiManager.requestApi(method: .post, urlString: "otpVerification", parameters: param, headers: headers, success: { (responseObject) in
                
//                print(responseObject)
                
                if responseObject["status"] as? Bool == true {
                   SVProgressHUD.dismiss()
                    if self.isForgotPassword == false {
                        User.isVerified = true
                        UserDefaults.standard.set(true, forKey: "isVerified")
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        AppDelegate.appDelegate.changeRootViewControllerToSWRevealViewController()
                    }
                    else {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
                        self.navigationController?.pushViewController(vc
                            , animated: true)
                    }
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
                self.apiVerifyOTP(otp: self.strEmail)
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
           
            if self.isForgotPassword == true {
                param["email"] = self.strEmail as AnyObject?
            }
            else {
                param["email"] = User.email as AnyObject?
            }
            
            print("parameters: ", param)
            
            ApiManager.requestApi(method: .post, urlString: "forgetpassword", parameters: param, headers: headers, success: { (responseObject) in
                SVProgressHUD.dismiss()
                print(responseObject)
                
                if responseObject["status"] as? Bool == true {
                    
                    self.showAlert(msg: "OTP sent. Please check your email!")
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
                self.apiResendOTP()
            }
        }
    }
}
