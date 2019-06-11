//
//  MyExtensions.swift
//  BreadMan
//
//  Created by apple on 21/05/19.
//  Copyright © 2019 BreadMan. All rights reserved.
//

import UIKit

class MyExtensions: NSObject {
  
}


enum Alert {        //for failure and success results
    case success
    case failure
    case error
}
//for success or failure of validation with alert message
enum Valid {
    case success
    case failure(Alert, AlertMessages)
}
enum ValidationType {
    case otp
    case email
    case stringWithFirstLetterCaps
    case phoneNo
    case alphabeticString
    case password
}
enum RegEx: String {
    case otp = "[0-9]{2,4}"
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" // Email
    case password = "^.{6,8}$" // Password length 6-8
    case alphabeticStringWithSpace = "^[a-zA-Z ]*$" // e.g. hello sandeep
    case alphabeticStringFirstLetterCaps = "^[A-Z]+[a-zA-Z]*$" // SandsHell
    case phoneNo = "[0-9]{10,14}" // PhoneNo 10-14 Digits        //Change RegEx according to your Requirement
}

enum AlertMessages: String {
    case inValidOTP = "Invalid OTP"
    case inValidEmail = "Invalid Email"
    case invalidFirstLetterCaps = "First Letter should be capital"
    case inValidPhone = "Invalid Phone"
    case invalidAlphabeticString = "Invalid String"
    case inValidPSW = "Password must have at least 6 characters"
    
    case emptyOTP = "Empty OTP"
    case emptyPhone = "Empty Phone"
    case emptyEmail = "Empty Email"
    case emptyFirstLetterCaps = "Empty Name"
    case emptyAlphabeticString = "Empty String"
    case emptyPSW = "Empty Password"
    
    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

class Validation: NSObject {
    
    public static let shared = Validation()
    
    func validate(values: (type: ValidationType, inputValue: String)...) -> Valid {
        for valueToBeChecked in values {
            switch valueToBeChecked.type {
            case .otp:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .otp, .emptyOTP, .inValidOTP)) {
                    return tempValue
                }
            case .email:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .email, .emptyEmail, .inValidEmail)) {
                    return tempValue
                }
            case .stringWithFirstLetterCaps:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .alphabeticStringFirstLetterCaps, .emptyFirstLetterCaps, .invalidFirstLetterCaps)) {
                    return tempValue
                }
            case .phoneNo:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .phoneNo, .emptyPhone, .inValidPhone)) {
                    return tempValue
                }
            case .alphabeticString:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .alphabeticStringWithSpace, .emptyAlphabeticString, .invalidAlphabeticString)) {
                    return tempValue
                }
            case .password:
                if let tempValue = isValidString((valueToBeChecked.inputValue, .password, .emptyPSW, .inValidPSW)) {
                    return tempValue
                }
            }
        }
        return .success
    }
    
    func isValidString(_ input: (text: String, regex: RegEx, emptyAlert: AlertMessages, invalidAlert: AlertMessages)) -> Valid? {
        if input.text.isEmpty {
            return .failure(.error, input.emptyAlert)
        } else if isValidRegEx(input.text, input.regex) != true {
            return .failure(.error, input.invalidAlert)
        }
        return nil
    }
    
    func isValidRegEx(_ testStr: String, _ regex: RegEx) -> Bool {
        let stringTest = NSPredicate(format:"SELF MATCHES %@", regex.rawValue)
        let result = stringTest.evaluate(with: testStr)
        return result
    }
}
extension UITextField {
    
    func isEmpty() -> Bool
    {
        if (self.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        {
            return true
            
        }else{
            return false
        }
    }
}
extension UIViewController {
    
    func showAlert(msg: String) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
            window.resignKey()
            window.isHidden = true
            window.removeFromSuperview()
            window.windowLevel = UIWindow.Level.alert - 1
            window.setNeedsLayout()
        }
        alert.addAction(okAction)
        window.windowLevel = UIWindow.Level.alert + 1
        window.makeKeyAndVisible()
        window.rootViewController?.present(alert, animated: true, completion: nil)
//        self.present(alert, animated: true)
    }
    func showNetworkAlert(apiToCall: String) {
        let showAlert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        showAlert.addAction(action)
        showAlert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { action in
            // your actions here...
        }))
        
        self.present(showAlert, animated: true, completion: nil)
    }
    func showLogoutAlert() {
        let alert = UIAlertController(title: "Logout?", message: "Are you sure to logout?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            //  print("Handle Ok logic here")
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            //     print("Handle Cancel Logic here")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
