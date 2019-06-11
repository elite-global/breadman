//
//  User.swift
//  BreadMan
//
//  Created by apple on 20/05/19.
//  Copyright © 2019 BreadMan. All rights reserved.
//

import UIKit

class User: NSObject {

//    static let mediaBaseURL = ""
//    static let baseURL = ""
//
    static var user_id = ""
    static var deviceToken = ""

    static var isVendor = false
    static var isVerified = false
    
    // User data
    static var profile = ""
    static var vendorId = ""
    static var firstName = ""
    static var lastName = ""
    static var email = ""
    static var phone = ""
    static var address = ""
    static var pincode = ""
    static var ratePerKG = ""
    static var dailyAvgQuantity = ""
    // My Supplier
    static var customer_supplierId = ""
    static var mySupplier_first_name = ""
    static var mySupplier_last_name = ""
    static var mySupplier_phone = ""
    static var mySupplier_address = ""
    static var mySupplier_pincode = ""
    static var mySupplier_rate = ""
    static var mySupplier_daily_quantity = ""
    static var mySupplier_profile = ""
    static var mySupplier_email = ""
    
    static func setUserDetails(userDict: [String: AnyObject]) {
        var dataDict = userDict
        if userDict.isEmpty == true && UserDefaults.standard.value(forKey: "userData") != nil {
            dataDict = Utility.getDictionary(key: "userData")
        }
        
        if dataDict["user_type"] as? String == "customer" {
            
            User.user_id = "\(dataDict["id"]  as AnyObject)"
            User.firstName = dataDict["first_name"] as? String ?? ""
            User.lastName = dataDict["last_name"] as? String ?? ""
            User.email = dataDict["email"] as? String ?? ""
            User.phone = dataDict["phone"] as? String ?? ""
            User.address = dataDict["address"] as? String ?? ""
            User.profile = dataDict["profile"] as? String ?? ""
            User.vendorId = dataDict["vendor_id"] as? String ?? ""
            self.isVendor = false
            if dataDict["is_active"] as? String ?? "" == "0" {
               User.isVerified = false
            }
            else {
                User.isVerified = true
            }
            
            // My Supplier Details
            User.mySupplier_first_name = dataDict["supplier_details"]?["first_name"]  as? String ?? ""
            User.mySupplier_last_name = dataDict["supplier_details"]?["last_name"]  as? String ?? ""
            User.mySupplier_phone = dataDict["supplier_details"]?["phone"]  as? String ?? ""
            User.mySupplier_address = dataDict["supplier_details"]?["address"]  as? String ?? ""
            User.mySupplier_pincode = dataDict["supplier_details"]?["pincode"]  as? String ?? ""
            User.mySupplier_rate = dataDict["supplier_details"]?["rate_per_kg"]  as? String ?? ""
            User.mySupplier_daily_quantity = dataDict["supplier_details"]?["daily_avg_quantity"]  as? String ?? ""
            User.mySupplier_profile = dataDict["supplier_details"]?["profile"]  as? String ?? ""
        }
        else {
            User.user_id = "\(dataDict["id"]  as AnyObject)"
            User.firstName = dataDict["first_name"] as? String ?? ""
            User.lastName = dataDict["last_name"] as? String ?? ""
            User.email = dataDict["email"] as? String ?? ""
            User.phone = dataDict["phone"] as? String ?? ""
            User.address = dataDict["address"] as? String ?? ""
            User.pincode = dataDict["pincode"] as? String ?? ""
            User.ratePerKG = dataDict["rate_per_kg"] as? String ?? ""
            User.profile = dataDict["profile"] as? String ?? ""
            User.vendorId = dataDict["vendor_id"] as? String ?? ""
            User.dailyAvgQuantity = dataDict["daily_avg_quantity"] as? String ?? ""
            self.isVendor = true
            if dataDict["is_active"] as? String ?? "" == "0" {
                User.isVerified = false
            }
            else {
                User.isVerified = true
            }
        }
    }
    
    // My Supplier Details
    static func setMySupplierDetails(supplierDict: [String: AnyObject]) {
      
        var dataDict = supplierDict
        if supplierDict.isEmpty == true && UserDefaults.standard.value(forKey: "mySupplierDetails") != nil {
            dataDict = Utility.getDictionary(key: "mySupplierDetails")
        }
        
        // My Supplier Details
        User.mySupplier_first_name = dataDict["first_name"]  as? String ?? ""
        User.mySupplier_last_name = dataDict["last_name"]  as? String ?? ""
        User.mySupplier_phone = dataDict["phone"]  as? String ?? ""
        User.mySupplier_address = dataDict["address"]  as? String ?? ""
        User.mySupplier_pincode = dataDict["pincode"]  as? String ?? ""
        User.mySupplier_rate = dataDict["rate_per_kg"]  as? String ?? ""
        User.mySupplier_daily_quantity = dataDict["daily_avg_quantity"]  as? String ?? ""
        User.mySupplier_profile = dataDict["profile"]  as? String ?? ""
        User.mySupplier_email = dataDict["email"]  as? String ?? ""
        
    }
}
