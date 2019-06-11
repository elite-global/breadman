//
//  CustomerProfileVC.swift
//  BreadMan
//
//  Created by apple on 13/05/19.
//  Copyright © 2019 BreadMan. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SVProgressHUD
import Alamofire
import SDWebImage

class CustomerProfileVC: UIViewController {

    let picker = UIImagePickerController()
    var strProfileOldURL = ""
    
    // Outlets
    @IBOutlet weak var btnProfile: ProfileButtons!
    @IBOutlet weak var btnSideMenu: UIButton!
    @IBOutlet weak var txtFirstName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtLastName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMobileNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var txtAddress: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.picker.delegate = self
        
        self.navigationController?.isNavigationBarHidden = false
        self.btnSideMenu.addTarget(self.revealViewController(), action: Selector(("revealToggle:")), for: UIControl.Event.touchUpInside)
        
//        if User.isVendor {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RenderProfileVC") as! RenderProfileVC
//            let navigation = storyboard?.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
//            navigation.viewControllers = [vc]
//            self.revealViewController().pushFrontViewController(navigation, animated: false)
//        }
        
        self.txtEmail.text = User.email
        if User.firstName != "" {
            self.txtFirstName.text = User.firstName
            self.txtLastName.text = User.lastName
            self.txtEmail.text = User.email
            self.txtEmail.isUserInteractionEnabled = false
            self.txtAddress.text = User.address
            self.txtMobileNumber.text = User.phone
            self.strProfileOldURL = User.profile
            if User.profile != "" {
                self.btnProfile.sd_setImage(with: URL (string: User.profile), for: .normal, completed: nil)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    // Button Actions
    @IBAction func clickedSettings(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func clickedProfilePic(_ sender: Any) {
        self.getImage()
    }
    @IBAction func clickedSave(_ sender: Any) {
        
        if User.firstName == self.txtFirstName.text && User.lastName == self.txtLastName.text && User.phone == self.txtMobileNumber.text && User.address == self.txtAddress.text && self.strProfileOldURL == User.profile {
            
            self.showAlert(msg: "Saved!")
            return
        }
        
        if self.txtFirstName.isEmpty() {
            self.showAlert(msg: "Enter first name")
            return
        }
        if self.txtLastName.isEmpty() {
            self.showAlert(msg: "Enter last name")
            return
        }
        if self.txtEmail.isEmpty() {
            self.showAlert(msg: "Enter email")
            return
        }
        if self.txtMobileNumber.isEmpty() {
            self.showAlert(msg: "Enter mobile nmuber")
            return
        }
        if self.txtAddress.isEmpty() {
            self.showAlert(msg: "Enter address")
            return
        }
        
        let response = Validation.shared.validate(values: (ValidationType.email, self.txtEmail.text ?? ""),(ValidationType.phoneNo, self.txtMobileNumber.text ?? ""))
        switch response {
        case .success:
            
            
            self.apiUpdateProfile()
            
            break
        case .failure(_, let message):
            print(message.localized())
            self.showAlert(msg: message.localized())
        }
    }
    
    // Api Call
    func apiUpdateProfile() {
        if ConnectionCheck.isConnectedToNetwork()
        {
            SVProgressHUD.show()
            
            let headers = ["Content-Type":"multipart/form-data"] // "application/x-www-form-urlencoded"
           
            var param = [String:AnyObject]()
            param["user_id"] = User.user_id as AnyObject?
            param["first_name"] = self.txtFirstName.text! as AnyObject?
            param["last_name"] = self.txtLastName.text! as AnyObject?
            param["phone"] = self.txtMobileNumber.text! as AnyObject?
            param["email"] = self.txtEmail.text! as AnyObject?
            param["address"] = self.txtAddress.text! as AnyObject?
            
            print("parameters: ", param)
            
            let profileImage = self.btnProfile.imageView?.image
            
            let url = "\(AppDelegate.baseURL)updateProfileCustomer"
            let imageData = profileImage?.jpegData(compressionQuality: 0.5) ?? Data()
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "profile",fileName: "profile", mimeType: "image/jpeg")
                
                for (key, value) in param {
                    multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                } //Optional for extra parameters
            }, to: url, headers:headers)
            { (result) in
                switch result {
                case .success(let upload,_,_ ):
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
//                        print(progress)
                    })
                    upload.responseJSON
                        { response in
                            
                            if response.result.value != nil
                            {
                                let dict :NSDictionary = response.result.value! as! NSDictionary
//                                                                print(dict)
                                
                                if dict.value(forKey: "status") as? Bool == true
                                {
                                    let userData: [String:AnyObject] = dict["data"] as! [String : AnyObject]
                                  
                                    Utility.saveDictionary(dict: userData , key: "userData")
                                    UserDefaults.standard.set(true, forKey: "isVerified")
                                    User.setUserDetails(userDict: userData)
                                    SVProgressHUD.dismiss()
                                    self.showAlert(msg: dict["message"] as? String ?? "Saved!")
                                }
                                else {
                                    SVProgressHUD.dismiss()
                                    if dict["error"] as? String != "" {
                                        self.showAlert(msg: dict["error"] as! String)
                                    }
                                    else {
                                        self.showAlert(msg: dict["message"] as! String)
                                    }
                                }
                            }
                    }
                case .failure( _):
                    SVProgressHUD.dismiss()
                    break
                }
            }
        }
        else {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                SVProgressHUD.dismiss()
                self.showNetworkAlert(apiToCall: "action")
                self.apiUpdateProfile()
            }
        }
    }
}
extension CustomerProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func getImage()
    {
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        //  let image = UIImage(named: "down_arrow")
        
        let firstAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { action -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                //self.picker.allowsEditing = true
                self.picker.sourceType = UIImagePickerController.SourceType.camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker,animated: true,completion: nil)
            }
            else {
                self.noCamera()
            }
        }
        let secondAction: UIAlertAction = UIAlertAction(title: "Gallery", style: .default) { action -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
            {
                //self.picker.allowsEditing = true
                self.picker.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker,animated: true,completion: nil)
            }
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad )
        {
            actionSheetController.popoverPresentationController?.sourceView = self.view
            actionSheetController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            actionSheetController.popoverPresentationController?.permittedArrowDirections = []
            self.present(actionSheetController, animated: true, completion: nil)
            // actionSheetController.popoverPresentationController?.sourceView = self.view
        }
        else {
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    // no camera avilable action
    func noCamera()
    {
        self.showAlert(msg: "Sorry this device has no camera")
    }
    
    // Image Picker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
//        if let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as? NSURL {
//
//            self.btnProfile.setImage(chosenImage, for: .normal)
//        }
//        else  {
            self.strProfileOldURL = ""
            self.btnProfile.setImage(chosenImage, for: .normal)
//        }
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
}
