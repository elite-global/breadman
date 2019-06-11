//
//  LoginVC.swift
//  BreadMan
//
//  Created by apple on 13/05/19.
//  Copyright © 2019 BreadMan. All rights reserved.
//

protocol DialogSignUpTypeDelegates {
    func moveToSignUp(type: String)
}

import UIKit
import SWRevealViewController
import SVProgressHUD

class LoginVC: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Outlets
    @IBOutlet weak var txtEmail: AppTextField!
    @IBOutlet weak var txtPassword: AppTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    // Button Actions
    @IBAction func clickedLogIn(_ sender: Any) {
        
        if self.txtEmail.isEmpty() {
            self.showAlert(msg: "Enter email")
            return
        }
        if self.txtPassword.isEmpty() {
            self.showAlert(msg: "Enter password")
            return
        }
        
        let response = Validation.shared.validate(values: (ValidationType.email, self.txtEmail.text ?? ""),(ValidationType.password, self.txtPassword.text ?? ""))
        switch response {
        case .success:
            
            self.apiLogIn()
            
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
    
    @IBAction func clickedSignUp(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DialogSignUpVC") as! DialogSignUpVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func clickedForgotPassword(_ sender: Any) {
        
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // APIs Call
    func apiLogIn() {
        
        SVProgressHUD.show()
        if ConnectionCheck.isConnectedToNetwork()
        {
            let headers = ["Content-Type":"application/x-www-form-urlencoded", "token":""]
            var param = [String:AnyObject]()
            
            param["device_id"] = User.deviceToken as AnyObject?
            param["email"] = self.txtEmail.text as AnyObject?
            param["password"] = self.txtPassword.text as AnyObject?
//            param["user_id"] = AppDelegate.user_id as AnyObject?
//            param["poster_id"] = self.strPosterID as AnyObject?
//            param["cancel_reason"] = self.strCancelReason as AnyObject?
//            param["cancel_comment"] = self.txtComment.text as AnyObject?
            
            print("parameters: ", param)
            
            ApiManager.requestApi(method: .post, urlString: "login", parameters: param, headers: headers, success: { (responseObject) in
                
//                print(responseObject)
                
                if responseObject["status"] as? Bool == true {
                    SVProgressHUD.dismiss()
                    
                    DispatchQueue.main.async {
                        let userData: [String:AnyObject] = responseObject["data"] as! [String : AnyObject]
                        Utility.saveDictionary(dict: userData , key: "userData")
                        //                    UserDefaults.standard.set(false, forKey: "isVerified")
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        User.setUserDetails(userDict: userData)
                        if userData["is_active"] as? String == "1" {
                            AppDelegate.appDelegate.changeRootViewControllerToSWRevealViewController()
                        }
                        else {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
                            let nav = self.storyboard?.instantiateViewController(withIdentifier: "logIn") as! UINavigationController
                            nav.viewControllers = [vc]
                            //                        User.isVendor = false
                            UIApplication.shared.windows[0].rootViewController = vc
                        }
                    }
                }
                else {
                    SVProgressHUD.dismiss()
                    UserDefaults.standard.set(false, forKey: "isLoggedIn")
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
                self.apiLogIn()
            }
        }
    }
}
extension LoginVC: DialogSignUpTypeDelegates {
    func moveToSignUp(type: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        vc.strSignUpType = type
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
