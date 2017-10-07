//
//  HomeViewController.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 17/09/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var LblTime: UILabel!
    @IBOutlet weak var CheckOutVw: UIView!
    @IBOutlet weak var CheckInVw: UIView!
    @IBOutlet weak var BtnLogs: UIButton!
    @IBOutlet weak var BtnRollOut: UIButton!
    @IBOutlet weak var BtnCheckOut: UIButton!
    @IBOutlet weak var BtnCheckIn: UIButton!
    
    var menu : UIAlertController!
    var timer : Timer!
    var clocktimer : Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        GetButtonStatus()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        GetTime()
       runTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        clocktimer.invalidate()
        timer.invalidate()
    }
    
    func runTimer() {
         clocktimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(GetTime)), userInfo: nil, repeats: true)
        timer = Timer.scheduledTimer(timeInterval: 60*30, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        
    }
    
    func updateTimer() {
        GetButtonStatus()
    }
    
    func GetTime() {
        self.LblTime.text = Date.now.ToString(format: "hh:mm:ss a");
    }
    
    func GetButtonStatus() {
        Utility.showProgressHud(text: "")
        CheckBtnStatusResponseModel.GetStatus(callback: { (checkin, error) in
             Utility.hideProgressHud()
            DispatchQueue.main.async {
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
    
    @IBAction func RefreshClicked(_ sender: Any) {
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
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func Logout() {
        Utility.showProgressHud(text: "")
        CheckInResponseModel.CheckIn(status: "LOGOUT", callback: { (checkin, error) in
            
            DispatchQueue.main.async {
                Utility.hideProgressHud()
                if(checkin != nil && checkin?.ErrorMessage == nil){
                    Utility.showToast(text: (checkin?.msg)!)
                    UserDeafultsManager.SharedDefaults.IsLoggedIn = false
                    
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginNavigationVC") as! UINavigationController
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    
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
    
    @IBAction func BtnLogsClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "LogsSegue", sender: self)
    }
    
    @IBAction func BtnCheckInClicked(_ sender: Any) {
         Utility.showProgressHud(text: "")
        CheckInResponseModel.CheckIn(status: "IN", callback: { (checkin, error) in
            
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
        CheckInResponseModel.CheckIn(status: "OUT", callback: { (checkin, error) in
            
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
