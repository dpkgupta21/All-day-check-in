
import Foundation
import  UIKit
import SystemConfiguration
import MBProgressHUD

public class Utility{
    
    let kTNLDebugLevel1:Bool = true  // Show debug level NSLOG
    let kTNLDebugLevel2:Bool = true  // Show debug level NSLOG
    let kTNLDebugLevel3:Bool = true  // Show debug level NSLOG
    let kTNLDebugError:Bool  = true   // Show error NSLOG
    
    static var hud : MBProgressHUD!
    
    static var longDateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    static var timeFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }

    func isValidEmail(emailAddress:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailAddress)
    }
    
    class func isEmptyString(str:String)->Bool {
        let trimmed = str.trimmingCharacters(in: NSCharacterSet.whitespaces)
        return trimmed.isEmpty
    }
    

    class func showProgressHud(text : String)
    {
        if (hud == nil)
        {
            hud = MBProgressHUD.init(window: UIApplication.shared.keyWindow!)
            UIApplication.shared.keyWindow?.addSubview(hud)
            hud.show(animated: true)
            hud.label.text = text
        }
        else
        {
             DispatchQueue.main.async(execute: {
                //Hide progress view
                if (hud != nil)
                {
                    hud.label.text = text
                }
            })
        }
    }
    
    
  
    class func hideProgressHud()
    {
        if(hud != nil) {
            hud.hide(animated: true)
            hud.removeFromSuperview()
            hud.delegate = nil
            hud = nil
        }
    }
    
    class func showToast(text : String){
        if (hud == nil)
        {
            hud = MBProgressHUD.init(window: UIApplication.shared.keyWindow!)
            hud.mode = .text
            UIApplication.shared.keyWindow?.addSubview(hud)
            hud.removeFromSuperViewOnHide = true;
            hud.label.text = text
            hud.show(animated: true)
            hud.hide(animated: true, afterDelay: 3)
            
        }
        else
        {
            DispatchQueue.main.async(execute: {
                //Hide progress view
                if (hud != nil)
                {
                    hud.label.text = text
                }
            })
        }
    }
    
    
    
    class func showAlertWithInfo(infoDic : NSDictionary)
    {
        var tag : Int = 0
        
        if (infoDic.object(forKey: "tag") != nil) {
            tag = ((infoDic.object(forKey: "tag") as AnyObject).integerValue)!
        }
        
        let alertView : UIAlertView = UIAlertView.init(title: infoDic.object(forKey: "title") as? String, message: infoDic.object(forKey: "message")as? String, delegate: infoDic.object(forKey: "delegate") as? UIAlertViewDelegate, cancelButtonTitle: infoDic.object(forKey: "cancel")as? String)
        alertView.tag = tag
        alertView.show()
    }
    
    
    class func showAlertWithMultiButtonInfo(infoDic : NSDictionary)
    {
        var tag : Int = 0
        
        if (infoDic.object(forKey: "tag") != nil) {
            tag = ((infoDic.object(forKey: "tag") as AnyObject).integerValue)!
        }
        
        let alertView : UIAlertView = UIAlertView.init(title: infoDic.object(forKey: "title") as! String, message: infoDic.object(forKey: "message") as! String, delegate: infoDic.object(forKey: "delegate") as? UIAlertViewDelegate, cancelButtonTitle: infoDic.object(forKey: "cancel")as? String, otherButtonTitles: infoDic.object(forKey: "ok")as! String)
        alertView.tag = tag
        alertView.show()
    }
    
    class func isNameValid(inputString : String) -> Bool
    {
        let letters = NSCharacterSet.letters
        let range = inputString.rangeOfCharacter(from: letters)
        
        // range will be nil if no letters is found
        if range != nil {
            return true
        }
        else {
            return false
        }
    }
    
    
    class func  getAttributedString(date:Date) -> NSAttributedString {
        let str1 = date.ToString(format: "MMM") + "\n";
        let str2 = date.ToString(format: "dd") + "\n" ;
        let str3 = date.ToString(format: "yyyy")
        
        let font1 = UIFont.systemFont(ofSize: 12)
        let font2 = UIFont.systemFont(ofSize: 17)
        
        let attr1 = NSMutableAttributedString(
            string: str1,
            attributes: [NSFontAttributeName:font1])
        let attr2 = NSMutableAttributedString(
            string: str2,
            attributes: [NSFontAttributeName:font2])
        let attr3 = NSMutableAttributedString(
            string: str3,
            attributes: [NSFontAttributeName:font1])
        
        attr1.append(attr2)
        attr1.append(attr3)
        
        return attr1
        
        
        
    }
    
}




