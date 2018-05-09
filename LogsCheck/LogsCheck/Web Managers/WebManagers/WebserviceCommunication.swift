//  WebserviceCommunication.swift
//  TNLAgency
//

//  Created by Jatin sharan on 15/04/16.
//  Copyright © 2016 Ps. All rights reserved.
//

import Foundation

//FREQUENTLY USED WEBSERVICE KEY
let WEBSERVICE_HEADER_KEY              :String  = "header"
let WEBSERVICE_CLASS_DATA              :String  = "data"
let WEBSERVICE_CLASS_RESULT            :String  = "result"
let WEBSERVICE_CLASS_KEY               :String  = "class"
let WEBSERVICE_CLASS_SUCCESS           :String  = "success"
let WEBSERVICE_CLASS_ERROR             :String  = "error"
let WEBSERVICE_MESSAGE_KEY             :String  = "message"
let WEBSERVICE_TYPE_KEY                :String  = "type"
let WEBSERVICE_ATTRIBUTE_KEY           :String  = "attribute"
let WEBSERVICE_CODE_KEY                :String  = "code"
let WEBSERVICE_UNIT_KEY                :String  = "unit"

let WEBSERVICE_RESULT_KEY              :Bool    =  true

let timeInterval                       : TimeInterval = 300.0
let vimeotimeInterval                  : TimeInterval = 3000.0

let kTNLDebugLevel1:Bool = true  // Show debug level NSLOG
let kTNLDebugLevel2:Bool = true  // Show debug level NSLOG
let kTNLDebugLevel3:Bool = true  // Show debug level NSLOG
let kTNLDebugError:Bool  = true   // Show error NSLOG

let baseURL = "https://atsmapi.alldaytime.co.uk/api/BasicAction/";
let token = "?token=NixpkcMC4gKP3OIQA8hBJqv1ByZ4c+ffMYLb5mfDwFeWEQ7XEReLXA=="

let METHOD_LOGIN = "AuthenticateUser"
let METHOD_SERVERTIME = "FetchServerTime"
let METHOD_INSERTCLOCK = "InsertClock"
let METHOD_GETLOGS = "fetchLogs"
let METHOD_GETTERMINALS = "fetchTerminals"
let METHOD_GETROLLCALL = "FetchRollCall"
let METHOD_GETBUTTONSTATUS = "CheckForButtonsStatus"
let METHOD_COMPANY_TIME_ZONE = "FetchCompanyTimeZone"

class WebserviceCommunication: NSObject,URLSessionDownloadDelegate,URLSessionTaskDelegate{
    @available(iOS 7.0, *)
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
    }
    
    
    private static let _sharedInstance = WebserviceCommunication()
    
    
    class func defaultCommunicator() -> WebserviceCommunication {
        return _sharedInstance
    }
    
    
    func httpPOSTEncodedString(methodName:String,valuesString:String,callback:@escaping (_ result:AnyObject?,_ statusCode:Int? ,_ error:NSString?)->Void)
    {
        //Request on background thread
        DispatchQueue.global(qos: .background).async {
            
            if(!Utility.isConnectedToNetwork())
            {
                callback(nil,nil , "No Internet Connection")
                return;
            }
            
            let requestURL = baseURL + methodName + token
            
            let url = URL(string: requestURL)
            
            let request = NSMutableURLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: timeInterval)
            
            request.httpMethod = "POST"
            request.addValue("application/xml", forHTTPHeaderField: "Content-Type")
            
            
            do {
                
                let Data =  valuesString.data(using: String.Encoding.utf8)!
                request.httpBody = Data as Data
                
                
                let session = URLSession.shared
                
                let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                    
                    if error != nil {
                        callback(nil , 0 , error?.localizedDescription as NSString?)
                    } else {
                        let dataTaskResponse : HTTPURLResponse = response as! HTTPURLResponse
                        
                        if data == nil {
                            callback(nil, dataTaskResponse.statusCode , "Error")
                        }
                        else {
//                            let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                            callback(data as AnyObject, dataTaskResponse.statusCode ,nil)
                        }
                    }
                }
                
                task.resume()
            }catch{
            
            }
            
        }
        
    }
    
    
}
