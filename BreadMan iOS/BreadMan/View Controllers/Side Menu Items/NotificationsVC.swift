//
//  NotificationsVC.swift
//  BreadMan
//
//  Created by apple on 01/06/19.
//  Copyright © 2019 BreadMan. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol NotificationPageDelegates {
    func removeAcceptedNotificationFromList()
}

class NotificationsVC: UIViewController {

    var strTitle = "Notifications"
    var strNoData = "No data available"
    var aryNotifications: [[String:String]] = [["type":"customer add request"], ["type":"customer add request"], ["type":"customer add request"], ["type":"customer add request"], ["type":"customer add request"]]
    
    // Outlets
    @IBOutlet weak var btnSideMenu: UIButton!
    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var tableVW: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        self.btnSideMenu.addTarget(self.revealViewController(), action: Selector(("revealToggle:")), for: UIControl.Event.touchUpInside)
        
        self.lblNoData.text = self.strNoData
        self.tableVW.tableFooterView = UIView()
        
        self.apiGetNotifications()
        
        // Do any additional setup after loading the view.
    }
    
    // Button Actions
    
    // Api
    func apiGetNotifications() {
        
        SVProgressHUD.show()
        if ConnectionCheck.isConnectedToNetwork()
        {
            let headers = ["Content-Type":"application/x-www-form-urlencoded", "token":""]
            var param = [String:AnyObject]()
            
            param["user_id"] = User.user_id as AnyObject?
//            param["old_password"] = self.txtOldPassword.text as AnyObject?
//            param["new_password"] = self.txtNewPassword.text as AnyObject?
            
            //            print("parameters: ", param)
            
            ApiManager.requestApi(method: .post, urlString: "getUserNotifications", parameters: param, headers: headers, success: { (responseObject) in
                
                print(responseObject)
                
                if responseObject["status"] as? Bool == true {
                    SVProgressHUD.dismiss()
                    
                    //                    DispatchQueue.main.async {
//                    self.showAlert(msg: responseObject["message"] as! String)
//                    self.navigationController?.popViewController(animated: true)
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
                self.apiGetNotifications()
            }
        }
    }
}
extension NotificationsVC: NotificationPageDelegates, UITableViewDelegate, UITableViewDataSource {
   
    func removeAcceptedNotificationFromList() {
        
        self.aryNotifications.remove(at: self.tableVW.indexPathForSelectedRow!.row)
        self.tableVW.reloadData()
        self.showAlert(msg: "Request accepted")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.aryNotifications.count == 0 {
            self.viewNoData.isHidden = false
            return 0
        }
        self.viewNoData.isHidden = true
        return self.aryNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableCell") as! NotificationsTableCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.aryNotifications[indexPath.row]["type"] == "customer add request" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DialogAddCustomerVC") as! DialogAddCustomerVC
            vc.modalPresentationStyle = .overCurrentContext
            vc.delegate = self
            self.present(vc, animated: false, completion: nil)
        }
    }
    
}
