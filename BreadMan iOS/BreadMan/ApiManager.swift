//
//  ApiManager.swift
//  PastZero
//
//  Created by Sunil Zalavadiya on 7/28/16.
//  Copyright © 2016 Sunil Zalavadiya. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage

class Helper
{
    
    private static let _instance = Helper()
    
    static var Instance:Helper = _instance
  
    func getWebService(content_type:String,WebAPI:String, helperCompletionHandler: @escaping(_ json:Any) -> Void)->Void
    {
        
        let headers: HTTPHeaders = ["Content-Type" : content_type]
        
        
        Alamofire.request(WebAPI, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON(completionHandler: {
            response in
            
            do{
                let json = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                helperCompletionHandler(json)
            }
            catch
            {
                print(error)
            }
            
        })
        
        
    }
    
}

class ApiManager
{
    static let sharedInstance = ApiManager()
   // var strBaseURL:String =  "http://139.59.84.204:82/api/"
    var strBaseURL:String =  "http://139.59.84.204:82/api/"
    
    func postMethod(urlString:String,parameters:String,headers:[String:AnyObject], onSuccess: @escaping(AnyObject) -> Void, onFailure: @escaping(Error) -> Void)
    {
        let url : String = strBaseURL + urlString
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.timeoutInterval = 30
         print(parameters)
        print(headers)
        request.allHTTPHeaderFields = headers as? [String : String]
        request.httpBody = parameters.data(using: String.Encoding.utf8)
        let session = URLSession.shared
             let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                //let result = JSON(data: data!)
                
                let result = try? JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                print(result ?? "Love")
                if result != nil
                {
                    onSuccess(result as AnyObject)
                }
                else
                {
                    //SVProgressHUD.dismiss()
                }
            }
        })
        task.resume()
        
    }
    
    
    
    
    
    
    
   class func requestApi(method: Alamofire.HTTPMethod, urlString: String, parameters: [String: AnyObject]? = nil, headers: [String: String]? = nil, success successBlock:@escaping (([String: AnyObject]) -> Void), failure failureBlock:@escaping ((NSError) -> Void))
    {
//        let url : String = "http://139.59.84.204:82/api/"+urlString
        // old base url
        // http://139.59.84.204/fostersoftsolutions.com/jobtick/index.php/
        let url : String = AppDelegate.baseURL+urlString
        var finalParameters = [String: AnyObject]()
        if(parameters != nil)
        {
            finalParameters = parameters!
        }
        
        print(url)
        
//        if(AppPrefsManager.sharedInstance.isUserLogin())
//        {
//            finalParameters["user_id"] = AppPrefsManager.sharedInstance.getUserId() as AnyObject?
//            //finalParameters["session_id"] = AppPrefsManager.sharedInstance.getSessionId() as AnyObject?
//        }
         //finalParameters["customer_id"] = AppPrefsManager.sharedInstance.getStripeCustomerId() as AnyObject?
        //finalParameters["client_id"] = AppPrefsManager.sharedInstance.getClientId() as AnyObject?
        
        print(finalParameters)
   //     log(message: "parameters = \(finalParameters)")
        
        let request = NSMutableURLRequest(url: NSURL.init(string: url)! as URL)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 30
        request.httpBody = try! JSONSerialization.data(withJSONObject: finalParameters, options: [])
        request.allHTTPHeaderFields = headers
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        
        
               // let url = "\(AppDelegate.baseURL)login"
                Alamofire.request(url, method: .post, parameters: finalParameters, encoding:  URLEncoding.httpBody, headers: headers).responseJSON { (response) in
                    switch(response.result) {
                    case.success(let data):
                        print(data as! [String:AnyObject])
                        
                     //   let responseData: [String:AnyObject] = data as! [String:AnyObject]
                        successBlock(data as! [String : AnyObject])
                        
                    case.failure(let error):
                       print("Not Success",error.localizedDescription)
                        failureBlock(error as NSError)
                       // displayAlert("Network Problem!!!", andMessage: error.localizedDescription)
                    }

            }
        
        
    }
//
//        return Alamofire.request(url, method: method, parameters: finalParameters, encoding: URLEncoding.default)
//            .responseString { response in
//
//                log(message: "Response String: \(String(describing: response.result.value))")
//
//            }
//            .responseJSON { response in
//                
//                log(message: "Response Error: \(String(describing: response.result.error))")
//                log(message: "Response JSON: \(String(describing: response.result.value))")
//                
//                if(response.result.error == nil)
//                {
//                    let responseObject = response.result.value as! [NSObject: AnyObject]
//                    
//                    
//                    successBlock(responseObject as! [String : AnyObject])
//                    
//                    let response = responseObject as! [String : AnyObject]
//                    print("Response JSON String: \(jsonStringFromDictionaryOrArrayObject(response as AnyObject))")
//                    
//                }
//                else
//                {
//                    if(failureBlock != nil && failureBlock!(response.result.error! as NSError))
//                    {
//                        if let statusCode = response.response?.statusCode
//                        {
//                            ApiManager.handleAlamofireHttpFailureError(statusCode: statusCode)
//                        }
//                    }
//                }
//        }
//    }
    
    class func requestWithUploadApi(method: Alamofire.HTTPMethod, urlString: String, parameters: [String: AnyObject]? = nil, fileDataParameters: [AnyObject]? = nil, headers: [String: String]? = nil, success successBlock:@escaping (([String: AnyObject]) -> Void), failure failureBlock:((NSError) -> Bool)?)
    {
        var finalParameters = [String: AnyObject]()
        if(parameters != nil)
        {
            finalParameters = parameters!
        }
//        if(AppPrefsManager.sharedInstance.isUserLogin())
//        {
//            finalParameters["sessionId"] = AppPrefsManager.sharedInstance.getSessionId() as AnyObject?
//        }
        
//        if(AppPrefsManager.sharedInstance.isUserLogin())
//        {
//            finalParameters["user_id"] = AppPrefsManager.sharedInstance.getUserId() as AnyObject?
//            //finalParameters["session_id"] = AppPrefsManager.sharedInstance.getSessionId() as AnyObject?
//        }
        //finalParameters["customer_id"] = AppPrefsManager.sharedInstance.getStripeCustomerId() as AnyObject?
        
//        print(finalParameters)
//        log(message: "parameters = \(finalParameters)")
        
        return Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append("".data(using: String.Encoding.utf8)!, withName: "")
            
            for (key, value) in finalParameters
            {
                multipartFormData.append(String(describing: value).data(using: .utf8)!, withName: key)
            }
            
            /*for (key, value) in finalParameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }*/
            
            if(fileDataParameters != nil && (fileDataParameters?.count)! > 0)
            {
                for i in 0...(fileDataParameters!.count - 1)
                {
                    let dict = fileDataParameters![i] as! [String: AnyObject]
                    multipartFormData.append(dict["data"] as! Data, withName: dict["param_name"] as! String, fileName: dict["file_name"] as! String, mimeType: "image/jpeg")
                }
            }
            
            }, to: urlString, encodingCompletion: { (encodingResult) in
                switch encodingResult
                {
                case .success(let upload, _, _):
                    
                    upload.responseString { response in
                        
                        log(message: "Response String: \(response.result.value)")
                    }
                    
                    upload.responseJSON { response in
                        
                        log(message: "Response Error: \(response.result.error)")
                        log(message: "Response JSON: \(response.result.value)")
                        
                        if(response.result.error == nil)
                        {
                            let responseObject = response.result.value as! [NSObject: AnyObject]
                            
                            successBlock(responseObject as! [String : AnyObject])
                            
                            let response = responseObject as! [String : AnyObject]
                            
//                            if (response["status"] as? NSNumber)?.intValue == ResponseFlag.sessionExpired
//                            {
//                               // AppDelegate.sharedDelegate().logout()
//                            }
                        }
                        else
                        {
                            if(failureBlock != nil && failureBlock!(response.result.error! as NSError))
                            {
                                if let statusCode = response.response?.statusCode
                                {
                                    ApiManager.handleAlamofireHttpFailureError(statusCode: statusCode)
                                }
                            }
                        }
                    }
                case .failure(let encodingError):
                    
                    displayAlert(NSLocalizedString("error", comment: ""), andMessage: "\(encodingError)")
                    
                }
        })
        
    }
    
    class func handleAlamofireHttpFailureError(statusCode: Int)
    {
        switch(statusCode)
        {
        case NSURLErrorUnknown:
            
            displayAlert("Error", andMessage: "Unable to connect, please try again!")
            
            break
        case NSURLErrorCancelled:
            
            break
        case NSURLErrorBadURL:
            displayAlert("Error", andMessage: "Unable to connect, please try again!")
            
            break
        case NSURLErrorTimedOut:
            
            displayAlert("Error", andMessage: "The request timed out, please verify your internet connection and try again.")
            
            break
            /*case NSURLErrorUnsupportedURL:
             displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break*/
        case NSURLErrorCannotFindHost:
            
            displayAlert("Error", andMessage: "The host name for a URL cannot be resolved, please try again later.")
            
            break
        case NSURLErrorCannotConnectToHost:
            
            displayAlert("Error", andMessage: "The host is down, please try again later")
            
            break
        case NSURLErrorDataLengthExceedsMaximum:
            
            //displayAlert("Error", andMessage: NSLocalizedString("data_length_exceeds_maximum", comment: ""))
            
            break
        case NSURLErrorNetworkConnectionLost:
            //displayAlert("Error", andMessage: NSLocalizedString("network_lost", comment: ""))
            break
            /*case NSURLErrorDNSLookupFailed:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorHTTPTooManyRedirects:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break*/
        case NSURLErrorResourceUnavailable:
            
            displayAlert("Error", andMessage: "A requested resource cannot be retrieved.")
            
            break
        case NSURLErrorNotConnectedToInternet:
            //displayAlert("Error", andMessage: NSLocalizedString("internet_appears_offline", comment: ""))
            break
            /*case NSURLErrorRedirectToNonExistentLocation:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorBadServerResponse:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorUserCancelledAuthentication:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorUserAuthenticationRequired:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorZeroByteResource:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break*/
        case NSURLErrorCannotDecodeRawData:
            
            displayAlert("Error", andMessage: "There is problem at the server, please try again after few minutes")
            
            break
        case NSURLErrorCannotDecodeContentData:
            
            displayAlert("Error", andMessage: "There is problem at the server, please try again after few minutes")
            
            break
            /*case NSURLErrorCannotParseResponse:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorInternationalRoamingOff:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorCallIsActive:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorDataNotAllowed:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorRequestBodyStreamExhausted:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorFileDoesNotExist:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorFileIsDirectory:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorNoPermissionsToReadFile:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorSecureConnectionFailed:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorServerCertificateHasBadDate:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorServerCertificateUntrusted:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorServerCertificateHasUnknownRoot:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorServerCertificateNotYetValid:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorClientCertificateRejected:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorClientCertificateRequired:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorCannotLoadFromNetwork:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorCannotCreateFile:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorCannotOpenFile:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorCannotCloseFile:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorCannotWriteToFile:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorCannotRemoveFile:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorCannotMoveFile:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorDownloadDecodingFailedMidStream:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break
             case NSURLErrorDownloadDecodingFailedToComplete:
             //displayAlert("Error", andMessage: NSLocalizedString("request_time_out", comment: ""))
             break*/
            
        default:
            
            displayAlert("Error", andMessage: "Unable to connect, please try again!")
            
            break
        }
    }
    
    
}
extension UIAlertController
{
//    func alertShow(message: String) {
//        let topWindow = UIWindow(frame: UIScreen.main.bounds)
//        topWindow.rootViewController = UIViewController()
//        topWindow.windowLevel = UIWindow.Level.alert + 1
//        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: {(_ action: UIAlertAction) -> Void in
//           
//        }))
//       
//        topWindow.makeKeyAndVisible()
//        topWindow.rootViewController?.present(alert, animated: true, completion: { _ in
//            
//        })
//        
//        
//        
//    }
}
