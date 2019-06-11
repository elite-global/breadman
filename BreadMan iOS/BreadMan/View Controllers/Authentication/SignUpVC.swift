//
//  SignUpVC.swift
//  BreadMan
//
//  Created by apple on 13/05/19.
//  Copyright © 2019 BreadMan. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignUpVC: UIViewController {

    var strSignUpType = "C U S T O M E R"
    
    // Outlets
    @IBOutlet weak var txtEmail: AppTextField!
    @IBOutlet weak var txtPassword: AppTextField!
    @IBOutlet weak var lblSignupType: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        self.lblSignupType.text = self.strSignUpType
        
        // Do any additional setup after loading the view.
    }

    // Buttona Actions
    @IBAction func clickedSignUp(_ sender: Any) {
        
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
            
            self.apiSignUp()
            
            break
        case .failure(_, let message):
            print(message.localized())
            self.showAlert(msg: message.localized())
        }
    }
    @IBAction func clickedLogIn(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // Api Call
    func apiSignUp() {
        
        SVProgressHUD.show()
        if ConnectionCheck.isConnectedToNetwork()
        {
            let headers = ["Content-Type":"application/x-www-form-urlencoded", "token":""]
            var param = [String:AnyObject]()
            
            if strSignUpType == "C U S T O M E R" {
                param["user_type"] = "customer" as AnyObject?
            }
            else {
                param["user_type"] = "supplier" as AnyObject?
            }
            param["device_id"] = User.deviceToken as AnyObject?
            param["email"] = self.txtEmail.text as AnyObject?
            param["password"] = self.txtPassword.text as AnyObject?
            //            param["user_id"] = AppDelegate.user_id as AnyObject?
            //            param["poster_id"] = self.strPosterID as AnyObject?
            //            param["cancel_reason"] = self.strCancelReason as AnyObject?
            //            param["cancel_comment"] = self.txtComment.text as AnyObject?
            
            print("parameters: ", param)
            
            ApiManager.requestApi(method: .post, urlString: "register", parameters: param, headers: headers, success: { (responseObject) in
                
//                print(responseObject)
                
                if responseObject["status"] as? Bool == true {
                    
                    SVProgressHUD.dismiss()
                    DispatchQueue.main.async {
                        let userData: [String:AnyObject] = responseObject["data"] as! [String : AnyObject]
                        Utility.saveDictionary(dict: userData , key: "userData")
                        UserDefaults.standard.set(false, forKey: "isVerified")
                        User.setUserDetails(userDict: userData)
                        UserDefaults.standard.set(false, forKey: "isLoggedIn")
                    }
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
                    self.navigationController?.pushViewController(vc
                        , animated: true)
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
                self.apiSignUp()
            }
        }
    }
}
extension SignUpVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.txtEmail {
            return range.location < 9
        }
        return true
    }
}
