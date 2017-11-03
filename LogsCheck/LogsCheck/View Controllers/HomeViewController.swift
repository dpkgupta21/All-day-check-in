//
//  HomeViewController.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 17/09/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    
    @IBOutlet weak var LblTime: UILabel!
    @IBOutlet weak var CheckOutVw: UIView!
    @IBOutlet weak var CheckInVw: UIView!
    @IBOutlet weak var BtnLogs: UIButton!
    @IBOutlet weak var BtnRollOut: UIButton!
    @IBOutlet weak var BtnCheckOut: UIButton!
    @IBOutlet weak var BtnCheckIn: UIButton!
    
    
    var locationManager: CLLocationManager!
    var menu : UIAlertController!
    var timer : Timer!
    //    var clocktimer : Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        GetButtonStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        GetCompanyTimeZone()
        runTimer()
        addTimeZonetoCurrentTime()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        timer.invalidate()
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 60*30, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        
    }
    
    @IBAction func RefreshClicked(_ sender: Any) {
        
        GetTime()
        
    }
    func updateTimer() {
        GetButtonStatus()
    }
    
    func GetTime() {
        
        Utility.showProgressHud(text: "")
        ServerTimeResponseModel.FetchTime(callback: { (checkin, error) in
            
            DispatchQueue.main.async {
                Utility.hideProgressHud()
                if(checkin != nil && checkin!.time != nil && checkin?.ErrorMessage == nil){
                    self.LblTime.text = checkin?.time.ToString(format: "HH:mm:ss");
                    
                }else if(checkin != nil){
                    let info = ["title":"Error",
                                "message":checkin?.ErrorMessage != nil ? checkin?.ErrorMessage : "error occured"  ,
                                "cancel":"Ok"]
                    Utility.showAlertWithInfo(infoDic: info as NSDictionary)
                }else{
                    let info = ["title":"Error",
                                "message":error,
                                "cancel":"Ok"]
                    Utility.showAlertWithInfo(infoDic: info as NSDictionary)
                }
            }
        })
        
        
    }
    
    func GetCompanyTimeZone() {
        
        Utility.showProgressHud(text: "")
        CompanyZoneResponseModel.FetchCompanyTimeZone(callback: { (checkin, error) in
            
            DispatchQueue.main.async {
                Utility.hideProgressHud()
                if(checkin != nil && checkin!.timeZoneVal != nil && checkin?.ErrorMessage == nil){
                    self.LblTime.text = checkin?.timeZoneVal;
                    
                }else if(checkin != nil){
                    let info = ["title":"Error",
                                "message":checkin?.ErrorMessage != nil ? checkin?.ErrorMessage : "error occured"  ,
                                "cancel":"Ok"]
                    Utility.showAlertWithInfo(infoDic: info as NSDictionary)
                }else{
                    let info = ["title":"Error",
                                "message":error,
                                "cancel":"Ok"]
                    Utility.showAlertWithInfo(infoDic: info as NSDictionary)
                }
            }
        })
        
        
    }
    
    func addTimeZonetoCurrentTime()
    {
        
        let time1 = "02:15:12"
        let time2 = "+0100"
        //let time3 = "+01:00"
        //let time = time1+time2;
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone=TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "HH:mm:ss"
        let date:NSDate = dateFormatter.date(from: time1)! as NSDate
        let str:String=dateFormatter.string(from: date as Date)
        
        print(str);
        
        //dateFormatter.timeZone=TimeZone(abbreviation: "GMT"+time2)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "HH:mm:sszzz"
        let str1 = str + time2
        let date1:NSDate = dateFormatter1.date(from: str1)! as NSDate
        
        let dateFormatter3 = DateFormatter()
        dateFormatter3.dateFormat = "HH:mm:ss"
        let str2:String=dateFormatter3.string(from: date1 as Date)
        
        print(str2);
        
        
        
        
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.timeZone=TimeZone(abbreviation: "GMT")
        //        dateFormatter.dateFormat = "HH:mm:ss"
        //        let date:NSDate = dateFormatter.date(from: time1)! as NSDate
        //
        //        let dateFormatter1 = DateFormatter()
        //        dateFormatter1.dateFormat = "HH:mm:ss"
        //        let str:String=dateFormatter1.string(from: date as Date)
        //        print(str)
        
        
    }
    
    func GetButtonStatus() {
        Utility.showProgressHud(text: "")
        CheckBtnStatusResponseModel.GetStatus(callback: { (checkin, error) in
            
            DispatchQueue.main.async {
                Utility.hideProgressHud()
                if(checkin != nil && checkin?.ErrorMessage == nil){
                    self.BtnCheckIn.isEnabled = (checkin?.showCheckIn)!
                    self.BtnCheckOut.isEnabled = (checkin?.showCheckout)!
                    self.CheckInVw.backgroundColor = (checkin?.showCheckIn)! ? UIColor.init(red: 0, green: 0.5, blue: 0, alpha: 1):UIColor.darkGray;
                    self.CheckOutVw.backgroundColor = (checkin?.showCheckIn)! ? UIColor.red : UIColor.darkGray;
                }else if(checkin != nil){
                    let info = ["title":"Error",
                                "message":checkin?.ErrorMessage,
                                "cancel":"Ok"]
                    Utility.showAlertWithInfo(infoDic: info as NSDictionary)
                }else{
                    let info = ["title":"Error",
                                "message":error,
                                "cancel":"Ok"]
                    Utility.showAlertWithInfo(infoDic: info as NSDictionary)
                }
            }
        })
    }
    
    @IBAction func BtnRefreshClicked(_ sender: Any) {
        GetButtonStatus()
    }
    
    
    @IBAction func MenuClicked(_ sender: Any) {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        let settingsAction = UIAlertAction(title: "Settings", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "SettingSegue", sender: self)
        }
        let logoutAction = UIAlertAction(title: "LogOut", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.Logout()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        alertController.addAction(logoutAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = sender as? UIBarButtonItem
        }
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func Logout() {
        
        UserDeafultsManager.SharedDefaults.IsLoggedIn = false
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginNavigationVC") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = viewController
        
    }
    
    
    
    @IBAction func BtnLogsClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "LogsSegue", sender: self)
    }
    
    @IBAction func BtnCheckInClicked(_ sender: Any) {
        Utility.showProgressHud(text: "")
        CheckInResponseModel.CheckIn(status: "IN",
                                     lat: String(describing: locationManager.location!.coordinate.latitude),
                                     lang: String(describing: locationManager.location!.coordinate.longitude),
                                     callback: { (checkin, error) in
                                        
                                        DispatchQueue.main.async {
                                            Utility.hideProgressHud()
                                            if(checkin != nil && checkin?.ErrorMessage == nil){
                                                self.BtnCheckIn.isEnabled = (checkin?.showCheckIn)!
                                                self.BtnCheckOut.isEnabled = (checkin?.showCheckout)!
                                                self.CheckInVw.backgroundColor = (checkin?.showCheckIn)! ? UIColor.init(red: 0, green: 0.5, blue: 0, alpha: 1):UIColor.darkGray;
                                                self.CheckOutVw.backgroundColor = (checkin?.showCheckIn)! ? UIColor.red : UIColor.darkGray;
                                                Utility.showToast(text: (checkin?.msg)!)
                                            }else if(checkin != nil){
                                                let info = ["title":"Error",
                                                            "message":checkin?.ErrorMessage,
                                                            "cancel":"Ok"]
                                                Utility.showAlertWithInfo(infoDic: info as NSDictionary)
                                            }else{
                                                let info = ["title":"Error",
                                                            "message":error,
                                                            "cancel":"Ok"]
                                                Utility.showAlertWithInfo(infoDic: info as NSDictionary)
                                            }
                                        }
        })
        
    }
    
    @IBAction func BtnCheckOutClicked(_ sender: Any) {
        Utility.showProgressHud(text: "")
        CheckInResponseModel.CheckIn(status: "OUT",
                                     lat: String(describing: locationManager.location!.coordinate.latitude),
                                     lang: String(describing: locationManager.location!.coordinate.longitude),
                                     callback: { (checkin, error) in
                                        
                                        DispatchQueue.main.async {
                                            Utility.hideProgressHud()
                                            if(checkin != nil && checkin?.ErrorMessage == nil){
                                                self.BtnCheckIn.isEnabled = (checkin?.showCheckIn)!
                                                self.BtnCheckOut.isEnabled = (checkin?.showCheckout)!
                                                self.CheckInVw.backgroundColor = (checkin?.showCheckIn)! ? UIColor.init(red: 0, green: 0.5, blue: 0, alpha: 1):UIColor.darkGray;
                                                self.CheckOutVw.backgroundColor = (checkin?.showCheckIn)! ? UIColor.red : UIColor.darkGray;
                                                Utility.showToast(text: (checkin?.msg)!)
                                            }else if(checkin != nil){
                                                let info = ["title":"Error",
                                                            "message":checkin?.ErrorMessage,
                                                            "cancel":"Ok"]
                                                Utility.showAlertWithInfo(infoDic: info as NSDictionary)
                                            }else{
                                                let info = ["title":"Error",
                                                            "message":error,
                                                            "cancel":"Ok"]
                                                Utility.showAlertWithInfo(infoDic: info as NSDictionary)
                                            }
                                        }
        })
        
    }
    
    @IBAction func BtnRollOutClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "RollCallSegue", sender: self)
    }
}
