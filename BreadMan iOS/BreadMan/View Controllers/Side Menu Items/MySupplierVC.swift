//
//  MySupplierVC.swift
//  BreadMan
//
//  Created by apple on 31/05/19.
//  Copyright © 2019 BreadMan. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol DialogAddSupplierDelegates {
    func addSupplier(id: String)
}
class MySupplierVC: UIViewController {

    // Outlets
    @IBOutlet weak var lblSupplierId: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblAvgQuantity: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var imageVW: ProfileImageVW!
    @IBOutlet weak var lblAcceptRequest: UILabel!
    @IBOutlet weak var btnSideMenu: UIButton!
    @IBOutlet weak var viewAddSupplier: UIView!
    @IBOutlet weak var tableVWSupplierDetails: UITableView!
    @IBOutlet weak var topConstraintsConnectSupplier: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        self.btnSideMenu.addTarget(self.revealViewController(), action: Selector(("revealToggle:")), for: UIControl.Event.touchUpInside)
        
        self.imageVW.layer.cornerRadius = self.imageVW.layer.bounds.height/2
        self.imageVW.clipsToBounds = true
        
        if User.mySupplier_first_name != "" {
            self.lblName.text = "\(User.mySupplier_first_name) \(User.mySupplier_last_name)"
            self.lblPhone.text = "\(User.mySupplier_phone)"
            self.lblEmail.text = "\(User.mySupplier_email)"
            self.lblAddress.text = "\(User.mySupplier_address) \nPincode: \(User.mySupplier_pincode)"
            self.lblRate.text = "Rs \(User.mySupplier_rate)/-"
            self.lblAvgQuantity.text = "\(User.mySupplier_daily_quantity) Kg"
            self.imageVW.sd_setImage(with: URL (string: User.mySupplier_profile), completed: nil)
            self.viewAddSupplier.isHidden = true
            self.tableVWSupplierDetails.isHidden = false
        }
        // Do any additional setup after loading the view.
    }
    
    // Button Actions
    @IBAction func clickedRemove(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "mySupplierDetails")
        self.viewAddSupplier.isHidden = false
        self.tableVWSupplierDetails.isHidden = true
    }
    @IBAction func clickedAddSupplier(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DialogAddSupplierVC") as! DialogAddSupplierVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.present(vc, animated: false, completion: nil)
    }
    
    // Api
    func apiConnectWithSupplier(id: String) {
        
        SVProgressHUD.show()
        if ConnectionCheck.isConnectedToNetwork()
        {
            let headers = ["Content-Type":"application/x-www-form-urlencoded", "token":""]
            var param = [String:AnyObject]()
            
            param["user_id"] = User.user_id as AnyObject?
            param["supplier_id"] = id as AnyObject?
            
            print("parameters: ", param)
            
            ApiManager.requestApi(method: .post, urlString: "connectsupplier", parameters: param, headers: headers, success: { (responseObject) in
                
                                print(responseObject)
                
                if responseObject["status"] as? Bool == true {
                    
//                    DispatchQueue.main.async {
//                    let userData: [String:AnyObject] = responseObject["data"]?["supplier_details"] as! [String : AnyObject]
//                    Utility.saveDictionary(dict: userData , key: "mySupplierDetails")
//                    print(userData)
//                    User.setMySupplierDetails(supplierDict: userData)
//                        // My Supplier Details
//                    self.lblSupplierId.text = "Supplier id: #\(userData["vender_id"] ?? "" as AnyObject)"
//                    self.lblName.text = "\(userData["first_name"] ?? "" as AnyObject) \(userData["last_name"] ?? "" as AnyObject)"
//                    self.lblEmail.text = "\(userData["email"] ?? "" as AnyObject)"
//                    self.lblPhone.text = "\(userData["phone"] as? String ?? "")"
//                    self.lblAddress.text = "\(userData["address"] as? String ?? "" + "\nPincode: \(userData["pincode"] as? String ?? "")")"
//                    self.lblRate.text = "Rs \(userData["rate_per_kg"] as? String ?? "")/-"
//                    self.lblAvgQuantity.text = "\(userData["daily_avg_quantity"] as? String ?? "") Kg"
//                    self.imageVW.sd_setImage(with: URL (string: userData["profile"] as? String ?? ""), completed: nil)
                    
                    self.viewAddSupplier.isHidden = true
                    self.tableVWSupplierDetails.isHidden = false
//                    }
                    SVProgressHUD.dismiss()
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
                self.apiConnectWithSupplier(id: id)
            }
        }
    }
}
extension MySupplierVC: DialogAddSupplierDelegates {
    
    func addSupplier(id: String) {
        
        self.apiConnectWithSupplier(id: id)
    }
}
