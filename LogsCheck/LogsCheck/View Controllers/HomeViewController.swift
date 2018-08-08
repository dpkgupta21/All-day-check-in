//
//  HomeViewController.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 17/09/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var LblTime: UILabel!
    @IBOutlet weak var CheckOutVw: UIView!
    @IBOutlet weak var CheckInVw: UIView!
    @IBOutlet weak var BtnLogs: UIButton!
    @IBOutlet weak var BtnRollOut: UIButton!
    @IBOutlet weak var BtnCheckOut: UIButton!
    @IBOutlet weak var BtnCheckIn: UIButton!
    
    @IBOutlet weak var RollCallVw: UIView!
    
    var locationManager: CLLocationManager!
    var menu : UIAlertController!
    var timer : Timer!
    var clocktimer : Timer!
    var checkInTime : Date!
    var strHours: String!
    var strMinutes: String!
    var strSeconds: String!
    var timeZone : Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        GetButtonStatus()
        GetCompanyTimeZone()
        NotificationCenter.default.addObserver(self, selector: #selector(GetTime), name: .UIApplicationDidBecomeActive, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        runTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    func runTimer() {
        if(timer != nil){
            timer.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: 60*30, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        
    }
    
    func updateTimer() {
        GetButtonStatus()
    }
    
    @objc func GetTime() {
        
        Utility.showProgressHud(text: "")
        ServerTimeResponseModel.FetchTime(callback: { (checkin, error) in
            
            DispatchQueue.main.async {
                Utility.hideProgressHud()
                if(checkin != nil && checkin!.time != nil && checkin?.ErrorMessage == nil){
                    //Set values from Fetch Time
                    self.checkInTime = checkin?.time!;
                    self.strHours = checkin?.strHours;
                    self.strMinutes = checkin?.strMins;
                    self.strSeconds = checkin?.strSec;
                    self.showTime()
                    if(self.clocktimer != nil){
                        self.clocktimer.invalidate()
                    }
                    
                    self.clocktimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.clockTimer)), userInfo: nil, repeats: true)
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
                    self.timeZone = checkin?.timeZoneVal.toDate(format: "+HH:mm");
                    self.GetTime()
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
    
    func showTime()
    {
        DispatchQueue.main.async {
        let h = self.strHours;
        let m = self.strMinutes;
        let s = self.strSeconds;
        print("Show Time is  ", h!,":",m!, ":" , s!)
        self.LblTime.text = String(h!) + ":" + String(m!) + ":" + String(s!);
            
//        self.checkInTime = self.LblTime.text!.toDate(format: "HH:mm:ss");
            
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
    }
    
    func clockTimer(){
        checkInTime = checkInTime.addingTimeInterval(TimeInterval(1));
        LblTime.text = checkInTime.ToString(format: "HH:mm:ss");
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
                    self.CheckOutVw.backgroundColor = (checkin?.showCheckout)! ? UIColor.red : UIColor.darkGray;
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
        if checkLocEnable() == true{
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
                                                    self.CheckOutVw.backgroundColor = (checkin?.showCheckout)! ? UIColor.red : UIColor.darkGray;
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
    }
    
    
    @IBAction func BtnCheckOutClicked(_ sender: Any) {
        if checkLocEnable() == true{
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
                                                    self.CheckOutVw.backgroundColor = (checkin?.showCheckout)! ? UIColor.red : UIColor.darkGray;
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
    }
    
    @IBAction func BtnRollOutClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "RollCallSegue", sender: self)
    }
    
    func checkLocEnable()->Bool{
        //check if location services are enabled at all
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            switch(CLLocationManager.authorizationStatus()) {
            //check if services disallowed for this app particularly
            case .restricted, .denied:
                print("No access")
                let accessAlert = UIAlertController(title: "Location Services Disabled", message: "We can not take in or out time without location services (GPS) working.", preferredStyle: UIAlertControllerStyle.alert)
                
                accessAlert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: { (action: UIAlertAction!) in UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
                    
                }))
                present(accessAlert, animated: true, completion: nil)
                return false
                
            //check if services are allowed for this app
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access! We're good to go!")
                return true
            //check if we need to ask for access
            case .notDetermined:
                print("asking for access...")
                locationManager.requestAlwaysAuthorization()
                return true
            }
            //location services are disabled on the device entirely!
        } else {
            print("Location services are not enabled")
            return false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}
