//
//  Utility.swift
//  MyEstatePoint
//
//  Created by Sunil Zalavadiya on 03/02/16.
//  Copyright © 2016 Sunil Zalavadiya. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
//import KYDrawerController
//import Toast
import SkyFloatingLabelTextField
//import libPhoneNumber_iOS



let enableLog = false


func log(message: String, function: String = #function, file: String = #file, line: Int = #line)
{
    if(enableLog)
    {
        print("-----------START-------------")
        let url = NSURL(fileURLWithPath: file)
        print("Message = \"\(message)\" \n\n(File: \(url.lastPathComponent), Function: \(function), Line: \(line))")
        print("-----------END-------------\n")
    }
}

//fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l < r
//  case (nil, _?):
//    return true
//  default:
//    return false
//  }
//}
//
//fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l >= r
//  default:
//    return !(lhs < rhs)
//  }
//}
//
//fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l <= r
//  default:
//    return !(rhs < lhs)
//  }
//}


class Utility: NSObject
{
    
    static func saveDictionary(dict: [String:AnyObject], key: String){
        let preferences = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: dict)
        preferences.set(encodedData, forKey: key)
        // Checking the preference is saved or not
        //        didSave(preferences: preferences)
    }
    
    static func getDictionary(key: String) -> [String:AnyObject] {
        let preferences = UserDefaults.standard
        if preferences.object(forKey: key) != nil{
            let decoded = preferences.object(forKey: key)  as! Data
            let decodedDict = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [String:AnyObject]
            
            return decodedDict
        } else {
            let emptyDict = [String:AnyObject]()
            return emptyDict
        }
    }
    
//    class func isLocationServiceEnable() -> Bool
//    {
//        var locationOn:Bool = false
//        
//        if(CLLocationManager.locationServicesEnabled())
//        {
//            
//            if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse)
//            {
//                locationOn = true
//            }
//            else if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways)
//            {
//                locationOn = true
//            }
//        }
//        else
//        {
//            locationOn = false
//        }
//        
//        return locationOn
//    }
    
 
}


//MARK: Public Functions

//func isNight()->Bool{
//    
//    let date = Date()
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "hh:mm a"
//    let calendar = Calendar.current
//    
//    let hours = calendar.component(.hour, from: date)
//
//    
//    return (hours <= 7 || hours >= 19) ? true : false
//    
//    
//}

func dateformatter(date: String) -> String {
    
    
    
    let dateformater = DateFormatter() //yyyy-mm-dd't'hh:mm:ss'z'
    
    dateformater.timeZone = NSTimeZone(name: "UTC") as TimeZone!
    dateformater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    
    let fromDate = dateformater.date(from: date)! as Date
    
    
    let calender:Calendar = Calendar.current
    let components: DateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: fromDate, to: Date())
    //print(components)
    var returnString:String = ""
    //print(components.second)
    
    
    
    if components.day! >= 7
    {
        let dateformater1 = DateFormatter() //yyyy-mm-dd't'hh:mm:ss'z'
        dateformater1.dateFormat = "MMMM dd"
        returnString = dateformater1.string(from: fromDate)
    }
    else if components.day! >= 1
    {
        returnString = String(describing: components.day!) + " days ago"
    }
    else if components.hour! >= 1
    {
        returnString = String(describing: components.hour!) + " hour ago"
    }
    else if components.minute! >= 1
    {
        returnString = String(describing: components.minute!) + " min ago"
    }
    else if components.second! <= 60
    {
        returnString = "Just Now"
        
    }
    
    return returnString
}



func timeSince(from: String, numericDates: Bool = false) -> String
{
    
    let dateformater = DateFormatter() //yyyy-mm-dd't'hh:mm:ss'z'
    //dateformater.timeZone = NSTimeZone.local
    dateformater.timeZone = NSTimeZone(name: "UTC") as TimeZone!
    dateformater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    
    let fromDate = dateformater.date(from: from)! as Date
    
  
    
    let calendar = Calendar.current
    let now = NSDate()
    let earliest = now.earlierDate(fromDate)
    //let latest = earliest == now as Date ? fromDate : now as Date
    
    let latest = now as Date
    let components = calendar.dateComponents([.year, .weekOfYear, .month, .day, .hour, .minute, .second], from: earliest, to: latest as Date)
    
    var result = ""
    
    if components.day! > 7
    {
        
        let dateformater1 = DateFormatter() //yyyy-mm-dd't'hh:mm:ss'z'
        
        dateformater1.dateFormat = "MMM dd"
        
        
        result = dateformater1.string(from: fromDate)
    }
    else if components.day! >= 2
    {
        result = "\(components.day!) days ago"
    }
    else if components.day! >= 1
    {
       
        result = "Yesterday"
       
    }
    else if components.hour! >= 2
    {
        result = "\(components.hour!) hours ago"
    }
    else if components.hour! >= 1
    {
        result = "1 hour ago"
       
    }
    else if components.minute! >= 2
    {
        result = "\(components.minute!) mins ago"
    }
    else if components.minute! >= 1
    {
        result = "1 mins ago"
    }
    else
    {
        result = "In \(components.second!) secs"
    }
   
    
    return result
}


//func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage
//{
//    
//    if image.size.width < targetSize.width || image.size.height < targetSize.height
//    {
//        return image
//    }
//    
//    let size = image.size
//    let widthRatio = targetSize.width / image.size.width
//    let heightRatio = targetSize.height / image.size.height
//    // Figure out what our orientation is, and use that to form the rectangle
//    var newSize: CGSize
//    if(widthRatio > heightRatio)
//    {
//        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
//    }
//    else
//    {
//        newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
//    }
//    // This is the rect that we've calculated out and this is what is actually used below
//    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
//    // Actually do the resizing to the rect using the ImageContext stuff
//    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
//    image.draw(in: rect)
//    let newImage = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    
//    return newImage!
//}


public func jsonStringFromDictionaryOrArrayObject(_ obj: AnyObject) -> String
{
    do
    {
        let jsonData = try JSONSerialization.data(withJSONObject: obj, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
        
        return jsonString!
    }
    catch let error as NSError
    {
        print("Error!! = \(error)")
    }
    
    return ""
}

public func jsonObjectFromJsonString(_ jsonString: String) -> AnyObject
{
    do
    {
        let jsonData = jsonString.data(using: String.Encoding.utf8)!
        let jsonObj = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
        
        return jsonObj as AnyObject
    }
    catch let error as NSError
    {
        print("Error!! = \(error)")
    }
    
    return "" as AnyObject
}


public func getCleanedObj(_ dataObj: [String: AnyObject]) -> [String: AnyObject]
{
    var jsonCleanDictionary = [String: AnyObject]()
    
    for (key, value) in dataObj
    {
        if !(value is NSNull)
        {
            if let valueNumber = value as? NSNumber
            {
                jsonCleanDictionary[key] = valueNumber.stringValue as AnyObject?
            }
            else
            {
                jsonCleanDictionary[key] = value
            }
        }
    }
    
    return jsonCleanDictionary
}

public func setDataToPreference(_ data: AnyObject, forKey key: String)
{
    UserDefaults.standard.set(data, forKey: key)
    UserDefaults.standard.synchronize()
}

public func getDataToPreference(_ data: AnyObject, forKey key: String) -> AnyObject
{
    return UserDefaults.standard.object(forKey: key)! as AnyObject
}

public func isPreferenceWithKeyExist(_ key: String) -> Bool
{
    return UserDefaults.standard.object(forKey: key) != nil
}


var TimeStampInterval: TimeInterval {
    return Date().timeIntervalSince1970
}

var TimeStampString: String {
    return "\(Date().timeIntervalSince1970)"
}

//func printFonts()
//{
//    let fontFamilyNames = UIFont.familyNames
//    for familyName in fontFamilyNames
//    {
//        print("------------------------------")
//        print("Font Family Name = [\(familyName)]")
//        let names = UIFont.fontNames(forFamilyName: familyName)
//        print("Font Names = [\(names)]")
//    }
//}
//
//
//func setStatusBarBackgroundColor(_ color: UIColor)
//{
//    guard  let statusBar = (UIApplication.shared.value(forKey: "statusBarWindow") as AnyObject).value(forKey: "statusBar") as? UIView else {
//        return
//    }
//    
//    statusBar.backgroundColor = color
//}


func delay(time: Double, closure:
    @escaping ()->()) {
    
    DispatchQueue.main.asyncAfter(deadline: .now() + time) {
        closure()
    }
    
}


//func getTotalNetCost(distance:Float,price:Float) -> Float
//{
//    let totalNetCost = (distance * price * 1000) / 1000;
//    
//    return totalNetCost
//    
//}


func removePerefixZero(phoneNumber:String) -> String
{
   var phoneNumberString = phoneNumber

    for number in phoneNumberString.characters
    {
        if number == "0"
        {
            phoneNumberString.characters.removeFirst()
        }
        else
        {
            break
        }
        
    }
    
    return phoneNumberString
    
}

//MARK: Device Version/Type/Size


func getMajorSystemVersion() -> Int
{
    let systemVersionStr = UIDevice.current.systemVersion   //Returns 7.1.1
    let mainSystemVersion = Int((systemVersionStr.characters.split{$0 == "."}.map(String.init))[0])
    
    return mainSystemVersion!
}

struct IOS_VERSION
{
    static var IS_IOS7 = getMajorSystemVersion() >= 7 && getMajorSystemVersion() < 8
    static var IS_IOS8 = getMajorSystemVersion() >= 8 && getMajorSystemVersion() < 9
    static var IS_IOS9 = getMajorSystemVersion() >= 9
}

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
    //static let IS_TV = UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.TV
    
    static let IS_IPHONE_4_OR_LESS =  IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = IS_IPHONE && ScreenSize.SCREEN_MAX_LENGTH == 736.0
}

func getAppUniqueId() -> String
{
    let uniqueId: UUID = UIDevice.current.identifierForVendor! as UUID
    
    return uniqueId.uuidString
}


//MARK: - Display Alerts / Toast


//func displayToastOnTop(message: String)
//{
//    let alertWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
//    alertWindow.rootViewController = UIViewController()
//    alertWindow.windowLevel = UIWindowLevelAlert + 1
//    alertWindow.makeKeyAndVisible()
//    
//    _ = AppDelegate.sharedDelegate().window?.rootViewController?.view
//    //alertWindow.windowLevel = UIWindowLevelAlert + 1
//    
//    let style = CSToastStyle(defaultStyle: ())
//    
//    style?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//    //style?.titleColor = UIColor.black
//    style?.messageColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//    alertWindow.makeToast(message, duration: 1.0, position: CSToastPositionTop, style: style)
//}
//
//func displayToastOnBottom(message: String)
//{
//    let alertWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
//    alertWindow.rootViewController = UIViewController()
//    alertWindow.windowLevel = UIWindowLevelAlert + 1
//    alertWindow.makeKeyAndVisible()
//    
//    let style = CSToastStyle(defaultStyle: ())
//    
//    style?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//    //style?.titleColor = UIColor.black
//    
//    let windowView = AppDelegate.sharedDelegate().window?.rootViewController?.view
//    style?.messageColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//    windowView?.makeToast(message, duration: 2.0, position: CSToastPositionBottom, style: style)
//}
//
//

func displayAlert(_ title: String, andMessage message: String)
{
    let alertWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
    alertWindow.rootViewController = UIViewController()
    alertWindow.windowLevel = UIWindow.Level.alert + 1
    alertWindow.makeKeyAndVisible()
    
    let alertController: UIAlertController = UIAlertController(title: NSLocalizedString(title, comment: ""), message: NSLocalizedString(message, comment: ""), preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { (action) -> Void in
        
        alertWindow.isHidden = true
    }))
    
    alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
}

//MARK: - Extension CAShapeLayer

//extension CAShapeLayer {
//    fileprivate func drawCircleAtLocation(_ location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
//        fillColor = filled ? color.cgColor : UIColor.white.cgColor
//        strokeColor = color.cgColor
//        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
//        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
//    }
//}
//
//private var handle: UInt8 = 0;

//MARK: - Extension UIView

//extension UIView
//{
//
//    func displayToast(message: String, backgroundColor: UIColor, messageColor:  UIColor, position: String)
//    {
//
//        let style = CSToastStyle(defaultStyle: ())
//        
//        style?.backgroundColor = backgroundColor
//        //style?.titleColor = UIColor.black
//        style?.messageColor = messageColor
//        makeToast(message, duration: 2.0, position: position, style: style)
// 
//    }
//    
//    func roundCorners(_ corners:UIRectCorner, radius: CGFloat)
//    {
//        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        self.layer.mask = mask
//    }
//}

//MARK: - Extension UIImage

extension UIImage {
    
//    func imageResize (sizeChange:CGSize)-> UIImage{
//        
//        let hasAlpha = true
//        let scale: CGFloat = 0.0 // Use scale factor of main screen
//        
//        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
//        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
//        
//        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
//        return scaledImage!
//    }
//    
//    
//    func tintWithColor(_ color:UIColor)->UIImage
//    {
//        
//        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale);
//        //UIGraphicsBeginImageContext(self.size)
//        let context = UIGraphicsGetCurrentContext()
//        
//        // flip the image
//        context?.scaleBy(x: 1.0, y: -1.0)
//        context?.translateBy(x: 0.0, y: -self.size.height)
//        
//        // multiply blend mode
//        context?.setBlendMode(.multiply)
//        
//        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
//        context?.clip(to: rect, mask: self.cgImage!)
//        color.setFill()
//        context?.fill(rect)
//        
//        // create uiimage
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return newImage!
//        
//    }
//    
//    func changeIconColorWithAppTheme() -> UIImage
//    {
//        return self.tintWithColor(appIconColor)
//    }
}

//MARK: - Extension UIBarButtonItem

extension UIBarButtonItem {
    
//    fileprivate var badgeLayer: CAShapeLayer? {
//        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
//            return b as? CAShapeLayer
//        } else {
//            return nil
//        }
//    }
//    
//    func addBadge(_ number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true) {
//        guard let view = self.value(forKey: "view") as? UIView else { return }
//        
//        badgeLayer?.removeFromSuperlayer()
//        
//        // Initialize Badge
//        let badge = CAShapeLayer()
//        let radius = CGFloat(7)
//        let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
//        badge.drawCircleAtLocation(location, withRadius: radius, andColor: color, filled: filled)
//        view.layer.addSublayer(badge)
//        
//        // Initialiaze Badge's label
//        let label = CATextLayer()
//        label.string = "\(number)"
//        label.alignmentMode = kCAAlignmentCenter
//        label.fontSize = 11
//        label.frame = CGRect(origin: CGPoint(x: location.x - 4, y: offset.y), size: CGSize(width: 8, height: 16))
//        label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
//        label.backgroundColor = UIColor.clear.cgColor
//        label.contentsScale = UIScreen.main.scale
//        badge.addSublayer(label)
//        
//        // Save Badge as UIBarButtonItem property
//        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//    }
//    
//    func updateBadge(_ number: Int) {
//        if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
//            text.string = "\(number)"
//        }
//    }
//    
//    func removeBadge() {
//        badgeLayer?.removeFromSuperlayer()
//    }
//    
}
//
//
//
//
////MARK: - Extension Integer
//
//extension Int
//{
//    static func random(range: Range<Int> ) -> Int
//    {
//        var offset = 0
//        
//        if range.lowerBound < 0   // allow negative ranges
//        {
//            offset = abs(range.lowerBound)
//        }
//        
//        let mini = UInt32(range.lowerBound + offset)
//        let maxi = UInt32(range.upperBound   + offset)
//        
//        return Int(mini + arc4random_uniform(maxi - mini)) - offset
//    }
//}
//
////MARK: - Extension UIButton
//
//extension UIButton
//{
//    func centerVerticallyWithPadding(padding: CGFloat)
//    {
//        let imageSize: CGSize = (self.imageView?.frame.size)!
//        let titleString: NSString = (self.titleLabel?.text)! as NSString
//        let titleSize: CGSize = titleString.size(attributes: [NSFontAttributeName: (self.titleLabel?.font)!])
//        
//        let totalHeight: CGFloat = imageSize.height + titleSize.height + padding
//        
//        self.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height), 0.0, 0.0, -titleSize.width)
//        
//        self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(totalHeight - titleSize.height), 0.0)
//    }
//    
//    func centerVertically()
//    {
//        let kDefaultPadding: CGFloat  = 6.0;
//        
//        self.centerVerticallyWithPadding(padding: kDefaultPadding);
//    }
//    
//    func addCornerRadius(_ radius: CGFloat)
//    {
//        self.layer.cornerRadius = radius
//    }
//    
//    func applyBorder(_ width: CGFloat, borderColor: UIColor)
//    {
//        self.layer.borderWidth = width
//        self.layer.borderColor = borderColor.cgColor
//    }
//    
//    func setRegularFont()
//    {
//        self.titleLabel?.font = UIFont(name: CustomFontName.ROBOTO_CONDENSED_REGULAR, size: (self.titleLabel?.font.pointSize)!)
//    }
//    
//    func setBoldFont()
//    {
//        self.titleLabel?.font = UIFont(name: CustomFontName.ROBOTO_CONDENSED_BOLD, size: (self.titleLabel?.font.pointSize)!)
//    }
//}
//
//// MARK: - UIViewController Extension
//
//extension UIViewController
//{
//    func addKeyboardDismissFeature()
//    {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
//            target: self,
//            action: #selector(UIViewController.dismissKeyboard))
//        
//        view.addGestureRecognizer(tap)
//    }
//    
//    func dismissKeyboard()
//    {
//        view.endEditing(true)
//        
//    }
//    
//    public func slideDrawerMenuController() -> KYDrawerController? {
//        var viewController: UIViewController? = self
//        while viewController != nil {
//            if viewController is KYDrawerController {
//                return viewController as? KYDrawerController
//            }
//            viewController = viewController?.parent
//        }
//        return nil;
//    }
//    
//    func addBarBackButton()
//    {
//        self.navigationController?.navigationBar.isHidden = true
//        
//        
//        let backItem = UIBarButtonItem(image: UIImage(named: "ic_Arrow"), style: .plain, target: self, action: #selector(clickToBackButton))
//        backItem.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        navigationItem.leftBarButtonItem = backItem
//        
//    }
//    
//    func clickToBackButton()
//    {
//        _ = navigationController?.popViewController(animated: true)
//    }
//}
//
//
//
// MARK: - String Extension

extension String
{
    var isValidEmail: Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidPhoneNumber: Bool
    {
        let phoneRegEx = "^\\d{3}-\\d{3}-\\d{4}$"
        
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: self)
    }
    
    var isValidPassword: Bool
    {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&.*-~`\"'#()+,:;<>=^_{}\\]\\[])[A-Za-z\\d$@$!%*?&.*-~`\"'#()+,:;<>=^_{}\\]\\[]{6,}"//"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{6,}"
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: self)
    }
    
    func getDateWithFormate(formate: String, timezone: String) -> NSDate
    {
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        formatter.timeZone = NSTimeZone(abbreviation: timezone) as TimeZone!
        
        return formatter.date(from: self)! as NSDate
    }
    
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.sizeToFit()
        
        return label.frame.height
    }
    
    
    func removeSpecialCharsFromString() -> String
    {
        let okayChars : Set<Character> = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890+".characters)
        return String(self.characters.filter {okayChars.contains($0) })
    }
    
    func removeDash() -> String
    {
        return self.replacingOccurrences(of: "-", with: "")
    }
}

// MARK: - Extension UIProgressView

//extension UIProgressView
//{
//    
//    @IBInspectable var barHeight : CGFloat {
//        get {
//            return transform.d * 2.0
//        }
//        set {
//            // 2.0 Refers to the default height of 2
//            let heightScale = newValue / 2.0
//            let c = center
//            transform = CGAffineTransform(scaleX: 1.0, y: heightScale)
//            center = c
//        }
//    }
//}



// MARK: - Extension SkyFloatingLabelTextField

//extension SkyFloatingLabelTextField
//{
//    func addTextFieldFloatingProperty()
//    {
//        self.placeholderColor = #colorLiteral(red: 0.8274509804, green: 0.8196078431, blue: 0.8235294118, alpha: 1)
//        self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        self.lineColor = #colorLiteral(red: 0.8588235294, green: 0.8588235294, blue: 0.8588235294, alpha: 1)
//        self.selectedLineColor = #colorLiteral(red: 0.1294117647, green: 0.3568627451, blue: 0.537254902, alpha: 1)
//        self.tintColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
//        self.selectedTitleColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
//    }
//}

// MARK: - Extension UITextField

//extension UITextField
//{
//    func addPadding(_ padding: CGFloat)
//    {
//        let leftView = UIView()
//        leftView.frame = CGRect(x: 0, y: 0, width: padding, height: self.frame.height)
//        
//        self.leftView = leftView
//        self.leftViewMode = .always
//    }
//    
//    func addCornerRadius(_ radius: CGFloat)
//    {
//        self.layer.cornerRadius = radius
//    }
//    
//    func applyBorder(_ width: CGFloat, borderColor: UIColor)
//    {
//        self.layer.borderWidth = width
//        self.layer.borderColor = borderColor.cgColor
//    }
//    
//    func addImageToRightSide(image: UIImage, width: CGFloat)
//    {
//        let rightView = UIImageView()
//        rightView.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
//        rightView.contentMode = .center
//        rightView.image = image
//        
//        self.rightView = rightView
//        self.rightViewMode = .always
//    }
//    
//    
//    func addImageToLeftSide(image: UIImage, width: CGFloat)
//    {
//        let rightView = UIImageView()
//        rightView.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
//        rightView.contentMode = .center
//        rightView.image = image
//        
//        self.leftView = rightView
//        self.leftViewMode = .always
//    }
//    
//    func addImageToLeftSide(image: UIImage, width: CGFloat, height: CGFloat)
//    {
//        let imageView = UIImageView()
//        imageView.frame.size = CGSize(width: height, height: width)//CGRect(x: 0, y: 0, width: width, height: height)
//        imageView.contentMode = .scaleAspectFit
//        imageView.image = image
//        
//        let rightView = UIView(frame: CGRect(x: 0, y: self.frame.height/2/2, width: width, height: self.frame.height))
//        
//        rightView.addSubview(imageView)
//        imageView.center = rightView.center
//        
//        self.leftView = rightView
//        self.leftViewMode = .always
//    }
//    
//    @IBInspectable var placeHolderColor: UIColor? {
//        get {
//            return self.placeHolderColor
//        }
//        set {
//            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
//        }
//    }

//    @IBInspectable var setRegularFont: UIFont? {
//        get {
//            return self.setRegularFont
//        }
//        set {
//            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes: [NSFontAttributeName: CustomFontName.ROBOTO_CONDENSED_REGULAR ])
//            self.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle(rawValue: CustomFontName.ROBOTO_CONDENSED_REGULAR))
//        }
//    }
//    
//    @IBInspectable var setBoldFont: UIFont?{
//        
//        get {
//            return self.setBoldFont
//        }
//        set {
//            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes: [NSFontAttributeName: CustomFontName.ROBOTO_CONDENSED_BOLD ])
//            self.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle(rawValue: CustomFontName.ROBOTO_CONDENSED_BOLD))
//        }
//    }
    
//    func setRegularFont()
//    {
//        self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes: [NSFontAttributeName: CustomFontName.ROBOTO_CONDENSED_REGULAR ])
//        self.font = UIFont(name: CustomFontName.ROBOTO_CONDENSED_REGULAR, size: (self.font?.pointSize)!)
//    }
//    
//    func setBoldFont()
//    {
//        self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes: [NSFontAttributeName: CustomFontName.ROBOTO_CONDENSED_BOLD ])
//        self.font = UIFont(name: CustomFontName.ROBOTO_CONDENSED_BOLD, size: (self.font?.pointSize)!)
//    }
//    
    
//}



// MARK: - Extension UILabel

//extension UILabel
//{
////    func setRegularFont()
////    {
////        self.font = UIFont(name: CustomFontName.ROBOTO_CONDENSED_REGULAR, size: (self.font?.pointSize)!)
////    }
////    
////    func setBoldFont()
////    {
////        self.font = UIFont(name: CustomFontName.ROBOTO_CONDENSED_BOLD, size: (self.font?.pointSize)!)
////    }
//}
//
//// MARK: - Extension UIFont
//
//extension UIFont
//{
////    func setRegularFont() -> UIFont
////    {
////        return UIFont(name: CustomFontName.ROBOTO_CONDENSED_REGULAR, size: (self.pointSize))!
////    }
////    
////    func setBoldFont()  -> UIFont
////    {
////         return UIFont(name: CustomFontName.ROBOTO_CONDENSED_BOLD, size: (self.pointSize))!
////    }
//}
//
//
//
//
////var txtTestMobileNumber =  VMaskTextField()
////
////extension UITextField
////{
////    func setVMaskMobileNo(range: NSRange, string: String) -> Bool
////    {
////        
////        txtTestMobileNumber = VMaskTextField()
////        txtTestMobileNumber.mask = "###-###-####"
////        
////        var newText = (self.text! as NSString).replacingCharacters(in: range, with: string)
////        let numberOfChars = newText.characters.count
////        
////        if(string.isEmpty)
////        {
////            
////            
////            if(!newText.isEmpty)
////            {
////                
////                if Array(newText.characters)[range.location - 1] == "-"
////                {
////                    txtTestMobileNumber.text = ""
////                    txtTestMobileNumber.setTextWithMask(self.text!)
////                    txtTestMobileNumber.text?.characters.removeLast()
////                    
////                    self.text! = txtTestMobileNumber.text!
////                }
////                
////            }
////            
////            
////            return true
////        }
////        else if numberOfChars <= 12
////        {
////            txtTestMobileNumber.text = ""
////            txtTestMobileNumber.setTextWithMask(self.text!)
////            
////            self.text! = txtTestMobileNumber.text!
////            return true
////        }
////        else
////        {
////            return false
////        }
////    }
////
////}
//
////extension String
////{
////    func setDefaultMaskPhoneNo() -> String
////    {
////        txtTestMobileNumber = VMaskTextField()
////        txtTestMobileNumber.mask = "###-###-####"
////        var finalNo = ""
////        for no in self.characters
////        {
////            finalNo += String(no)
////            txtTestMobileNumber.text = ""
////            txtTestMobileNumber.setTextWithMask(finalNo)
////            finalNo = txtTestMobileNumber.text!
////        }
////        
////        return finalNo
////    }
////}
//
//// MARK: - Extension UITextView
//
//extension UITextView
//{
//    func addCornerRadius(_ radius: CGFloat)
//    {
//        self.layer.cornerRadius = radius
//    }
//    
//    func applyBorder(_ width: CGFloat, borderColor: UIColor)
//    {
//        self.layer.borderWidth = width
//        self.layer.borderColor = borderColor.cgColor
//    }
//}

// MARK: - Extension Date

extension Date
{
    
   
    
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool
    {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending
        {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(_ dateToCompare: Date) -> Bool
    {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending
        {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(_ dateToCompare: Date) -> Bool
    {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedSame
        {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(_ daysToAdd: Int) -> Date
    {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: Date = self.addingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(_ hoursToAdd: Int) -> Date
    {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: Date = self.addingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
    
    func getDateStringWithFormate(_ formate: String, timezone: String) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        formatter.timeZone = TimeZone(abbreviation: timezone)
        
        return formatter.string(from: self)
    }
    
    func getDays(from date: Date) -> Int
    {
        return Calendar.current.dateComponents([.day], from: date, to: self).day!
    }
    
}


// MARK: - Extension UIPickerView

var dataPickerView: UIPickerView!
let txtSuperView = UIView()
var pickerDataArray = [String]()
var datePicker: UIDatePicker!

extension UITextField: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate
{
    
    func addPickerView(dataArray: [String])
    {
        
        pickerDataArray = dataArray
        
        dataPickerView = UIPickerView()
        dataPickerView.delegate = self
        dataPickerView.dataSource = self
        
        let keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: 44))
        keyboardToolbar.barStyle = .black
        keyboardToolbar.tintColor = UIColor.white
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(clickToKeyboardToolbarDone(sender:)))
        
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let items = [flex, barButtonItem]
        keyboardToolbar.setItems(items, animated: true)
        
        self.inputAccessoryView = keyboardToolbar
        
        self.inputView = dataPickerView
        //self.delegate = self
        
        
    }

    
    @IBAction func clickToKeyboardToolbarDone(sender: UIBarButtonItem)
    {
        if(self.isFirstResponder)
        {
            let selectedIndex = dataPickerView.selectedRow(inComponent: 0)
            
            let selectedString = pickerDataArray[selectedIndex]
            let stringObj = selectedString.components(separatedBy: " ")
            
            self.text = stringObj[0]
        }
        
        
        self.resignFirstResponder()
        
        
        txtSuperView.removeFromSuperview()
    }
    
    //UIPickerViewDelegate, UIPickerViewDataSource Methods
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        txtSuperView.frame = self.frame
        
        txtSuperView.isUserInteractionEnabled = true
        self.superview!.addSubview(txtSuperView)
        
        return 1
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataArray.count
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        
        
        return pickerDataArray[row]
    }
    
    func addDatePicker()
    {
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        let keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: 44))
        keyboardToolbar.barStyle = .black
        keyboardToolbar.tintColor = UIColor.white
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(clickToKeyboardToolbarDone1(_:)))
        
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let items = [flex, barButtonItem]
        keyboardToolbar.setItems(items, animated: true)
        
        self.inputAccessoryView = keyboardToolbar
        
        self.inputView = datePicker
        
        
    }
    
    
    @IBAction func clickToKeyboardToolbarDone1(_ sender: UIBarButtonItem)
    {
        if(self.isFirstResponder)
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd,yyyy"
            self.text = formatter.string(from: datePicker.date)
        }
        
        self.resignFirstResponder()
    }
    
}


// MARK: - Extension UIImageView

//extension UIImageView
//{
//    func setImage(_ image: UIImage, withColor color: UIColor)
//    {
//        self.image = image.withRenderingMode(.alwaysTemplate)
//        self.tintColor = color
//    }
//}

// MARK: - Extension Array

extension Array where Element:Equatable
{
    func removeDuplicates() -> [Element]
    {
        var result = [Element]()
        
        for value in self
        {
            if result.contains(value) == false
            {
                result.append(value)
            }
        }
        
        return result
    }
}

// MARK: - Extension Dictionary

extension Dictionary
{
    //https://developer.apple.com/swift/bprint/?id=12
    func valuesForKeys(_ keys: [Key]) -> [Value?]
    {
        return keys.map { self[$0] }
    }
    
    func valuesForKeys(_ keys: [Key], notFoundMarker: Value) -> [Value]
    {
        return self.valuesForKeys(keys).map { $0 ?? notFoundMarker }
    }
}

 //MARK: - Public Functions

func formatNumberStringToShortForm(_ numberStr: String) -> String
{
    var numberStr = numberStr
    numberStr = numberStr.replacingOccurrences(of: ",", with: "")
    
    
    if let numberDouble = Double(numberStr)// (numberStr as NSString).doubleValue
    {
        
        var shortNumber = numberDouble
        var suffixStr = ""
        
        if(numberDouble >= 1000000000.0)
        {
            suffixStr = "Arab"
            shortNumber = numberDouble / 1000000000.0
        }
        else if(numberDouble >= 10000000.0)
        {
            suffixStr = "Cr"
            shortNumber = numberDouble / 10000000.0
        }
        else if(numberDouble >= 100000.0)
        {
            suffixStr = "Lac"
            shortNumber = numberDouble / 100000.0
        }
        else if(numberDouble >= 1000.0)
        {
            suffixStr = "K"
            shortNumber = numberDouble / 1000.0
        }
        
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let numberAsString = numberFormatter.string(from: NSNumber(value: shortNumber as Double))
        let finalString = String(format: "%@ %@", numberAsString!, suffixStr)
        
        return finalString
    }
    
    return numberStr
}

func isStringContainsOnlyNumbers(_ string: String) -> Bool
{
    let charactersSet = NSMutableCharacterSet.decimalDigit()
    let badCharacters = charactersSet.inverted
    
    if string.rangeOfCharacter(from: badCharacters) == nil
    {
        print("string was a number")
        
        return true
    }
    else
    {
        print("string contained non-digit characters.")
        
        return false
    }
}

func isStringContainsOnlyNumbersWithFloatValue(_ string: String) -> Bool
{
    let charactersSet = NSMutableCharacterSet.decimalDigit()
    charactersSet.addCharacters(in: ".")
    let badCharacters = charactersSet.inverted
    
    if string.rangeOfCharacter(from: badCharacters) == nil
    {
        print("string was a number")
        
        return true
    }
    else
    {
        print("string contained non-digit characters.")
        
        return false
    }
}

func parseStringBetween(_ stringToParse: String, firstString: String, lastString: String) -> String
{
    let scanner = Scanner(string:stringToParse)
    var scanned: NSString?
    
    if scanner.scanUpTo(firstString, into:nil)
    {
        scanner.scanString(firstString, into:nil)
        if scanner.scanUpTo(lastString, into:&scanned)
        {
            let result: String = scanned! as String
            //print("parse result: \(result)") // result: google
            
            return result
        }
    }
    
    return ""
}

func getParsedImageUrl(_ imageUrl: String) -> String
{
    
    let nativeURL = URL(string: imageUrl)
    
    let pathComponents = nativeURL?.pathComponents
    
    var parsedString = parseStringBetween(imageUrl, firstString: "__", lastString: "__")
    
    parsedString = parsedString.replacingOccurrences(of: "w-", with: "")
    
    if(parsedString.isEmpty)
    {
        return ""
    }
    
    let widthArray = parsedString.components(separatedBy: "-")
    
    //var lowestDiff: Int = Int.max
    
    let device_width = Int(UIScreen.main.bounds.size.width * UIScreen.main.scale)
    
    var finalWidthStr: String = widthArray.last!
    
    for widthStr: String in widthArray
    {
        let currentWidth = Int(widthStr)
        
        /*let diff = abs(device_width - currentWidth!)
        
        if(diff < lowestDiff)
        {
            lowestDiff = diff;
            
            finalWidthStr = widthStr
        }*/
        
        if(currentWidth! >= device_width)
        {
            finalWidthStr = widthStr
            break
        }
    }
    
    
    var finalUrl = imageUrl
    
    for component in pathComponents!
    {
        if(component.range(of: parsedString) != nil)
        {
            finalUrl = imageUrl.replacingOccurrences(of: component, with: "w\(finalWidthStr)")
            break
        }
    }
    
    return finalUrl
}

func getParsedImageUrl(_ imageUrl: String, width: Int) -> String
{
    
    let nativeURL = URL(string: imageUrl)
    
    let pathComponents = nativeURL?.pathComponents
    
    var parsedString = parseStringBetween(imageUrl, firstString: "__", lastString: "__")
    
    parsedString = parsedString.replacingOccurrences(of: "w-", with: "")
    
    if(parsedString.isEmpty)
    {
        return ""
    }
    
    let widthArray = parsedString.components(separatedBy: "-")
    
    //var lowestDiff: Int = Int.max
    
    let device_width = Int(CGFloat(width) * UIScreen.main.scale)
    
    var finalWidthStr: String = widthArray.last!
    
    for widthStr: String in widthArray
    {
        let currentWidth = Int(widthStr)
        
        /*let diff = abs(device_width - currentWidth!)
        
        if(diff < lowestDiff)
        {
            lowestDiff = diff;
            
            finalWidthStr = widthStr
        }*/
        
        if(currentWidth! >= device_width)
        {
            finalWidthStr = widthStr
            break
        }
    }
    
    
    var finalUrl = imageUrl
    
    for component in pathComponents!
    {
        if(component.range(of: parsedString) != nil)
        {
            finalUrl = imageUrl.replacingOccurrences(of: component, with: "w\(finalWidthStr)")
            break
        }
    }
    
    return finalUrl
}


func getParsedImageUrl(_ imageUrl: String, maxWidth: Int) -> String
{
    
    let nativeURL = URL(string: imageUrl)
    
    let pathComponents = nativeURL?.pathComponents
    
    var parsedString = parseStringBetween(imageUrl, firstString: "__", lastString: "__")
    
    parsedString = parsedString.replacingOccurrences(of: "w-", with: "")
    
    if(parsedString.isEmpty)
    {
        return ""
    }
    
    let widthArray = parsedString.components(separatedBy: "-")
    
    var lowestDiff: Int = Int.max
    
    let device_width = maxWidth
    
    var finalWidthStr: String = widthArray.last!
    
    for widthStr: String in widthArray
    {
        let currentWidth = Int(widthStr)
        
        if(currentWidth! <= maxWidth)
        {
            let diff = abs(device_width - currentWidth!)
            
            if(diff < lowestDiff)
            {
                lowestDiff = diff;
                
                finalWidthStr = widthStr
            }
        }
    }
    
    
    var finalUrl = imageUrl
    
    for component in pathComponents!
    {
        if(component.range(of: parsedString) != nil)
        {
            finalUrl = imageUrl.replacingOccurrences(of: component, with: "w\(finalWidthStr)")
            break
        }
    }
    
    return finalUrl
}


func getEncodedUrlComponentString(_ urlStr: String) -> String!
{
    return urlStr.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
}

func getEncodedUrlQueryString(_ urlStr: String) -> String!
{
    return urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
}

func getConstraintForIdentifier(_ identifier: String, fromView: AnyObject) -> NSLayoutConstraint?
{
    for subview in fromView.subviews as [UIView]
    {
        for constraint in subview.constraints as [NSLayoutConstraint]
        {
            if constraint.identifier == identifier
            {
                return constraint
            }
        }
    }
    
    return nil
}

func getYouTubeVideoIdFromUrl(_ urlStr: String) -> String
{
    let regexString: String = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
    
    let regExp = try! NSRegularExpression(pattern: regexString, options: [.caseInsensitive])
    
    let array: [AnyObject] = regExp.matches(in: urlStr, options: [], range: NSMakeRange(0, urlStr.characters.count))
    if array.count > 0
    {
        let result: NSTextCheckingResult = array.first as! NSTextCheckingResult
        return (urlStr as NSString).substring(with: result.range)
    }
    
    return ""
}

func getYouTubeThumbnailUrlFromVideoUrl(_ urlStr: String) -> String
{
    return "http://img.youtube.com/vi/\(getYouTubeVideoIdFromUrl(urlStr))/hqdefault.jpg"
}

func getExtentionFromUrl(_ urlStr: String) -> String
{
    let URL = Foundation.URL(string: urlStr)
    
    if let extention = URL?.pathExtension
    {
        return extention
    }
    
    return ""
}
//
//func appVersion() -> String
//{
//    return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
//}
//
//func platform() -> String
//{
//    var systemInfo = utsname()
//    uname(&systemInfo)
//    
//    let machine = systemInfo.machine
//    let mirror = Mirror(reflecting: machine)
//    var identifier = "unknown"
//    
//    for child in mirror.children
//    {
//        if let value = child.value as? Int8 , value != 0
//        {
//            identifier.append(String(UnicodeScalar(UInt8(value))))
//        }
//    }
//
//    return identifier
//}
//
//func deviceNameString() -> String
//{
//    
//    let pf = platform();
//    if (pf == "iPhone1,1")   { return  "iPhone 1G"}
//    if ( pf   == "iPhone1,2"  )    {return  "iPhone 3G"}
//    if (  pf   == "iPhone2,1"  )    { return  "iPhone 3GS"}
//    if (  pf   == "iPhone3,1"  )    { return  "iPhone 4"}
//    if (  pf   == "iPhone3,3"  )    { return  "Verizon iPhone 4"}
//    if (  pf   == "iPhone4,1"  )    { return  "iPhone 4S"}
//    if (  pf   == "iPhone5,1"  )    { return  "iPhone 5 (GSM)"}
//    if (  pf   == "iPhone5,2"  )    { return  "iPhone 5 (GSM+CDMA)"}
//    if (  pf   == "iPhone5,3"  )    { return  "iPhone 5c (GSM)"}
//    if (  pf   == "iPhone5,4"  )    { return  "iPhone 5c (GSM+CDMA)"}
//    if (  pf   == "iPhone6,1"  )    { return  "iPhone 5s (GSM)"}
//    if (  pf   == "iPhone6,2"  )    { return  "iPhone 5s (GSM+CDMA)"}
//    if (  pf   == "iPhone7,1"  )    { return  "iPhone 6 Plus"}
//    if (  pf   == "iPhone7,2"  )    { return  "iPhone 6"}
//    if (  pf   == "iPhone8,1"  )    { return  "iPhone 6s Plus"}
//    if (  pf   == "iPhone8,2"  )    { return  "iPhone 6s"}
//    
//    if (  pf   == "iPod1,1"  )      { return  "iPod Touch 1G"}
//    if (  pf   == "iPod2,1"  )      { return  "iPod Touch 2G"}
//    if (  pf   == "iPod3,1"  )      { return  "iPod Touch 3G"}
//    if (  pf   == "iPod4,1"  )      { return  "iPod Touch 4G"}
//    if (  pf   == "iPod5,1"  )      { return  "iPod Touch 5G"}
//    if (  pf   == "iPad1,1"  )      { return  "iPad"}
//    
//    if (  pf   == "iPad2,1"  )      { return  "iPad 2 (WiFi)"}
//    if (  pf   == "iPad2,2"  )      { return  "iPad 2 (GSM)"}
//    if (  pf   == "iPad2,3"  )      { return  "iPad 2 (CDMA)"}
//    if (  pf   == "iPad2,4"  )      { return  "iPad 2 (WiFi)"}
//    if (  pf   == "iPad2,5"  )      { return  "iPad Mini (WiFi)"}
//    if (  pf   == "iPad2,6"  )      { return  "iPad Mini (GSM)"}
//    if (  pf   == "iPad2,7"  )      { return  "iPad Mini (GSM+CDMA)"}
//    if (  pf   == "iPad3,1"  )      { return  "iPad 3 (WiFi)"}
//    if (  pf   == "iPad3,2"  )      { return  "iPad 3 (GSM+CDMA)"}
//    if (  pf   == "iPad3,3"  )      { return  "iPad 3 (GSM)"}
//    if (  pf   == "iPad3,4"  )      { return  "iPad 4 (WiFi)"}
//    if (  pf   == "iPad3,5"  )      { return  "iPad 4 (GSM)"}
//    if (  pf   == "iPad3,6"  )      { return  "iPad 4 (GSM+CDMA)"}
//    if (  pf   == "iPad4,1"  )      { return  "iPad Air (WiFi)"}
//    if (  pf   == "iPad4,2"  )      { return  "iPad Air (Cellular)"}
//    if (  pf   == "iPad4,4"  )      { return  "iPad mini 2G (WiFi)"}
//    if (  pf   == "iPad4,5"  )      { return  "iPad mini 2G (Cellular)"}
//    
//    if (  pf   == "iPad4,7"  )      { return  "iPad mini 3 (WiFi)"}
//    if (  pf   == "iPad4,8"  )      { return  "iPad mini 3 (Cellular)"}
//    if (  pf   == "iPad4,9"  )      { return  "iPad mini 3 (China Model)"}
//    
//    if (  pf   == "iPad5,3"  )      { return  "iPad Air 2 (WiFi)"}
//    if (  pf   == "iPad5,4"  )      { return  "iPad Air 2 (Cellular)"}
//    
//    if (  pf   == "AppleTV2,1"  )      { return  "AppleTV 2"}
//    if (  pf   == "AppleTV3,1"  )      { return  "AppleTV 3"}
//    if (  pf   == "AppleTV3,2"  )      { return  "AppleTV 3"}
//    
//    if (  pf   == "i386"  )         { return  "Simulator"}
//    if (  pf   == "x86_64"  )       { return  "Simulator"}
//    return  pf
//}
//
//
//
//
//
//
//
//func getNSUserDefaultObjectForKey(_ key: String) -> AnyObject?
//{
//    return UserDefaults.standard.object(forKey: key) as AnyObject?
//}

/*extension String {

    var lastPathComponent: String {

        get {
            return (self as NSString).lastPathComponent
        }
    }
    var pathExtension: String {
        
        get {
            
            return (self as NSString).pathExtension
        }
    }
    var stringByDeletingLastPathComponent: String {
        
        get {
            
            return (self as NSString).stringByDeletingLastPathComponent
        }
    }
    var stringByDeletingPathExtension: String {
        
        get {
            
            return (self as NSString).stringByDeletingPathExtension
        }
    }
    var pathComponents: [String] {
        
        get {
            
            return (self as NSString).pathComponents
        }
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.stringByAppendingPathComponent(path)
    }
    
    func stringByAppendingPathExtension(ext: String) -> String? {
        
        let nsSt = self as NSString
        
        return nsSt.stringByAppendingPathExtension(ext)
    }
}*/

//MARK: -
//MARK: Get library directory path

//func getLibraryDirectoryPath() -> String
//{
//    var paths: [AnyObject] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [AnyObject]
//    return paths[0] as! String
//}

//MARK: Get document directory path

//func getDocumentDirectoryPath() -> String
//{
//    var paths: [AnyObject] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [AnyObject]
//    return paths[0] as! String
//}

//MARK: Get file path from library directory

//func getFilePathFromLibraryDirectory(_ fileName: String) -> String
//{
//    let filePath = getLibraryDirectoryPath().appendingFormat("/%@", fileName)
//    
//    return filePath
//}

//MARK: Get file path from document directory

//func getFilePathFromDocumentDirectory(_ fileName: String) -> String
//{
//    let filePath = getDocumentDirectoryPath().appendingFormat("/%@", fileName)
//    
//    return filePath 
//}

//MARK: Check for file exist or not

//func isFileOrDirectoryExistAtPath(_ path: String) -> Bool
//{
//    let fileManager: FileManager = FileManager.default
//    if fileManager.fileExists(atPath: path)
//    {
//        return true
//    }
//    return false
//}

//func createDirectoryFilePath(_ filePath: String) -> Bool
//{
//    do
//    {
//        try FileManager.default.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
//        return true
//    }
//    catch let error as NSError
//    {
//        print("Unable to create directory \(error)")
//        return false
//    }
//}

//MARK: Create directory name at given path

//func createDirectory(_ directoryName: String, atFilePath filePath: String) -> Bool
//{
//    let filePathAndDirectory: String = filePath.appendingFormat("/%@", directoryName)
//    
//    if isFileOrDirectoryExistAtPath(filePathAndDirectory)
//    {
//        return true
//    }
//    
//    return createDirectoryFilePath(filePathAndDirectory)
//}

//MARK: Create directory at library path

//func createDirectoryAtLibraryDirectory(_ directoryName: String) -> Bool
//{
//    let filePathAndDirectory: String = getLibraryDirectoryPath().appendingFormat("/%@", directoryName)
//    if isFileOrDirectoryExistAtPath(filePathAndDirectory)
//    {
//        return true
//    }
//    
//    return createDirectoryFilePath(filePathAndDirectory)
//}

//MARK: Create directory at document path

//func createDirectoryAtDocumentDirectory(_ directoryName: String) -> Bool
//{
//    let filePathAndDirectory: String = getLibraryDirectoryPath().appendingFormat("/%@", directoryName)
//    if isFileOrDirectoryExistAtPath(filePathAndDirectory)
//    {
//        return true
//    }
//    
//    return createDirectoryFilePath(filePathAndDirectory)
//}

//MARK: Get count of contents within directory path

//func getCountOfContentsWithinDirectory(_ directoryPath: String) -> Int
//{
//    do
//    {
//        let contentArray = try FileManager.default.contentsOfDirectory(atPath: directoryPath)
//        return contentArray.count
//    }
//    catch let error as NSError
//    {
//        print("Unable to get directory content \(error)")
//        return 0
//    }
//}

//MARK: Delete path at given path

//func deleteFileFromPath(_ filePath: String) -> Bool
//{
//    print("Path: %@", filePath)
//    let fileManager: FileManager = FileManager.default
//    
//    do
//    {
//        try fileManager.removeItem(atPath: filePath)
//        return true
//    }
//    catch let error as NSError
//    {
//        print("Delete directory error: \(error)")
//        return false
//    }
//
//}

//MARK: Delete all files at given directory path

//func deleteAllFilesAtDirectory(_ directoryPath: String) -> Bool
//{
//    print("Path: %@", directoryPath)
//    
//    let fileManager: FileManager = FileManager.default
//    
//    do
//    {
//        try fileManager.removeItem(atPath: directoryPath)
//        let _ = createDirectoryFilePath(directoryPath)
//        return true
//    }
//    catch let error as NSError
//    {
//        print("Delete directory error: \(error)")
//        return false
//    }
//}

//MARK: Delete file with given search name at given directory path

//func deleteFileNameStartWithText(_ searchText: String, atDirectory directory: String)
//{
//    let fileManager: FileManager = FileManager.default
//    
//    do
//    {
//        let dirContents: [String] = try fileManager.contentsOfDirectory(atPath: directory)
//        
//        for fileString: String in dirContents
//        {
//            if fileString.lowercased().hasPrefix(searchText.lowercased())
//            {
//                print("delete file = %@", fileString)
//                let _ = deleteFileFromPath(directory.appendingFormat("/%@", fileString))
//            }
//        }
//    }
//    catch let error as NSError
//    {
//        print("Delete dire ctory error: \(error)")
//    }
//}




//func getPhoneNumberString(phoneNumber: String) -> String
//{
////    var extractedPhoneNumber : NSString? = nil
////    let phoneUtil = NBPhoneNumberUtil()
////    phoneUtil.extractCountryCode(phoneNumber, nationalNumber: &extractedPhoneNumber)
////    
////    if extractedPhoneNumber != nil
////    {
////        return (extractedPhoneNumber as? String)!
////    }
////    else
////    {
////        return ""
////    }
//    
//    
//}



//func getPhoneCountryCodeString(phoneNumber: String) -> String
//{
////    var extractedPhoneNumber: NSString? = nil
////    let phoneUtil = NBPhoneNumberUtil()
////    let countryCode = phoneUtil.extractCountryCode(phoneNumber, nationalNumber: &extractedPhoneNumber)
////    return String(describing: countryCode!)
////}
////
////
////func isValidPhoneNumber(getPhoneNumberString: String,countryCodeString: String) -> Bool
////{
////    
////    let phoneUtil = NBPhoneNumberUtil()
////    let isoCode = phoneUtil.getRegionCode(forCountryCode: NSNumber(value: Int(countryCodeString)!))
////    
////    if let lookupNumber: NBPhoneNumber = try? phoneUtil.parse(getPhoneNumberString, defaultRegion: isoCode)
////    {
////        if(phoneUtil.isValidNumber(lookupNumber) && (phoneUtil.getNumberType(lookupNumber) == NBEPhoneNumberType.MOBILE || phoneUtil.getNumberType(lookupNumber) == NBEPhoneNumberType.FIXED_LINE_OR_MOBILE))
////        {
////            return true
////        }
////        else
////        {
////            displayAlert(NSLocalizedString("error", comment: ""), andMessage: NSLocalizedString("enter_valid_telephone", comment: ""))
////            return false
////        }
////    }
////    else
////    {
////        displayAlert(NSLocalizedString("error", comment: ""), andMessage: NSLocalizedString("enter_valid_telephone", comment: ""))
////        return false
////    }
//
//}


//func checkIfNumberIsValid(getPhoneNumberString: String,countryCodeString: String) -> Bool
//{
////    let phoneUtil = NBPhoneNumberUtil()
////    let isoCode = phoneUtil.getRegionCode(forCountryCode: NSNumber(value: Int(countryCodeString)!))
////    
////    if let lookupNumber: NBPhoneNumber = try? phoneUtil.parse(getPhoneNumberString, defaultRegion: isoCode)
////    {
////        
////        if phoneUtil.isValidNumber(lookupNumber)
////        {
////            return true
////        }
////        else
////        {
////            return false
////        }
////        
////        
////    }
////    else
////    {
////    
////        return false
////    }
////    
//}





