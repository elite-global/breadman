//
//  SideMenuVC.swift
//  BreadMan
//
//  Created by apple on 20/05/19.
//  Copyright © 2019 BreadMan. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController {

    let arySideMenuItems = ["Home","My supplier","My orders","Received orders","Notifications","About us","Contact us","Signout"]
    let arySupplierItems = ["Home","My customers","Pending requests","Pending orders","Delivered orders","About us","Contact us","Signout"]
    
    // Outlets
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tableVW: UITableView!
    @IBOutlet weak var btnProfile: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
//        print(User.profile)
        lblName.text = User.firstName + " " + User.lastName
        if User.profile != "" {
            self.btnProfile.sd_setImage(with: URL (string: User.profile), for: .normal, completed: nil)
        }
    }

    // Button Actions
    @IBAction func clickedProfileBtn(_ sender: Any) {
        if User.isVendor {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RenderProfileVC") as! RenderProfileVC
            let navigation = storyboard?.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
            navigation.viewControllers = [vc]
            self.revealViewController().pushFrontViewController(navigation, animated: true)
        }
        else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomerProfileVC") as! CustomerProfileVC
            let navigation = storyboard?.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
            navigation.viewControllers = [vc]
            self.revealViewController().pushFrontViewController(navigation, animated: true)
        }
    }
}
extension SideMenuVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if User.isVendor {
            return self.arySupplierItems.count
        }
        return self.arySideMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableCell") as! SideMenuTableCell
        
        if User.isVendor {
            cell.lblTitle.text = self.arySupplierItems[indexPath.row]
        }
        else {
            cell.lblTitle.text = self.arySideMenuItems[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        if User.isVendor {
            if indexPath.row == 0
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                vc.strTitle = "Home"
                let navigation = storyboard?.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                navigation.viewControllers = [vc]
                self.revealViewController().pushFrontViewController(navigation, animated: true)
            }
            else if indexPath.row == 1
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                vc.strTitle = "My customers"
                let navigation = storyboard?.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                navigation.viewControllers = [vc]
                self.revealViewController().pushFrontViewController(navigation, animated: true)
            }
            else if indexPath.row == 2
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
                vc.strTitle = "Pending requests"
                vc.strNoData = "No pending requests"
                let navigation = storyboard?.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                navigation.viewControllers = [vc]
                self.revealViewController().pushFrontViewController(navigation, animated: true)
            }
            else if indexPath.row == 3
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                vc.strTitle = "Pending orders"
                let navigation = storyboard?.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                navigation.viewControllers = [vc]
                self.revealViewController().pushFrontViewController(navigation, animated: true)
            }
            else if indexPath.row == 4
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                vc.strTitle = "Delivered orders"
                let navigation = storyboard?.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                navigation.viewControllers = [vc]
                self.revealViewController().pushFrontViewController(navigation, animated: true)
            }
            else if indexPath.row == 5
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
                //                vc.strTitle = "About us"
                let navigation = storyboard?.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                navigation.viewControllers = [vc]
                self.revealViewController().pushFrontViewController(navigation, animated: true)
            }
            else if indexPath.row == 6
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
                //                vc.strTitle = "Contact us"
                let navigation = storyboard?.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                navigation.viewControllers = [vc]
                self.revealViewController().pushFrontViewController(navigation, animated: true)
            }
            else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "logIn") as! UINavigationController
                User.isVendor = false
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
                UserDefaults.standard.removeObject(forKey: "userData")
                UserDefaults.standard.set(false, forKey: "isVerified")
                UIApplication.shared.windows[0].rootViewController = vc
            }
        }
        else {
            if indexPath.row == 0
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                vc.strTitle = "Home"
                let navigation = storyboard?.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                navigation.viewControllers = [vc]
                self.revealViewController().pushFrontViewController(navigation, animated: true)
            }
            else if indexPath.row == 1
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MySupplierVC") as! MySupplierVC
                let navigation = storyboard?.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                navigation.viewControllers = [vc]
                self.revealViewController().pushFrontViewController(navigation, animated: true)
            }
            else if indexPath.row == 2
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                vc.strTitle = "My orders"
                let navigation = storyboard?.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                navigation.viewControllers = [vc]
                self.revealViewController().pushFrontViewController(navigation, animated: true)
            }
            else if indexPath.row == 3
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                vc.strTitle = "Received orders"
                let navigation = storyboard?.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                navigation.viewControllers = [vc]
                self.revealViewController().pushFrontViewController(navigation, animated: true)
            }
            else if indexPath.row == 4
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
                vc.strTitle = "Notifications"
                vc.strNoData = "No pending notification"
                let navigation = storyboard?.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                navigation.viewControllers = [vc]
                self.revealViewController().pushFrontViewController(navigation, animated: true)
            }
            else if indexPath.row == 5
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
//                vc.strTitle = "About us"
                let navigation = storyboard?.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                navigation.viewControllers = [vc]
                self.revealViewController().pushFrontViewController(navigation, animated: true)
            }
            else if indexPath.row == 6
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
//                vc.strTitle = "Contact us"
                let navigation = storyboard?.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
                navigation.viewControllers = [vc]
                self.revealViewController().pushFrontViewController(navigation, animated: true)
            }
            else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "logIn") as! UINavigationController
                User.isVendor = false
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
                UserDefaults.standard.removeObject(forKey: "userData")
                UserDefaults.standard.set(false, forKey: "isVerified")
                UIApplication.shared.windows[0].rootViewController = vc
            }
        }
    }
}
