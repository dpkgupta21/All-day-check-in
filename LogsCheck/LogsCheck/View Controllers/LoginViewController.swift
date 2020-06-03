//
//  LoginViewController.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 17/09/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit
import CoreLocation

class LoginViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var BtnLogin: UIButton!
    @IBOutlet weak var TxtPassword: UITextField!
    @IBOutlet weak var TxtUserName: UITextField!
    @IBOutlet weak var BtnForgotPassword: UIButton!
    @IBOutlet weak var BtnShowPassword: UIButton!
    var locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.TxtUserName.text = UserDeafultsManager.SharedDefaults.Username
        self.TxtPassword.text = UserDeafultsManager.SharedDefaults.Password
        
        // Initiate location services
        self.EnableLocationServices();
        
        //paul.mason5@ntlworld.com
        if UserDeafultsManager.SharedDefaults.IsLoggedIn {
            self.loginWebRequest();
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "LoginSegue"){
            let vc = segue.destination as! UINavigationController
            let vc1 = vc.topViewController as! HomeViewController
            vc1.locationManager = locationManager;
        }
    }
        
    
    @IBAction func BtnLoginlClicked(_ sender: Any) {
        if (TxtUserName.text?.isEmpty)! || (TxtPassword.text?.isEmpty)! {
            let info = ["title":"Invalid Information",
                        "message":"Please enter correct user name and password",
                        "cancel":"Ok"]
            Utility.showAlertWithInfo(infoDic: info as NSDictionary)
        }else{
            self.loginWebRequest();
        }
    }
    
    @IBAction func ForgotPasswordClicked(_ sender: Any) {
        
    }
    
    @IBAction func TCClicked(_ sender: Any) {
    }
    
    @IBAction func ShowPasswordClicked(_ sender: Any) {
        BtnShowPassword.isSelected = !BtnShowPassword.isSelected;
        TxtPassword.isSecureTextEntry = !BtnShowPassword.isSelected;
    }
    
    
    func EnableLocationServices()
    {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if checkLocEnable() == true {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }else{
            let alertController = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: { (alert: UIAlertAction!) in
                UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
            })
            alertController.addAction(OKAction)
            OperationQueue.main.addOperation {
                self.present(alertController, animated: true, completion:nil)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func checkLocEnable()->Bool{
        //check if location services are enabled at all
        if CLLocationManager.locationServicesEnabled() {
            
            switch(CLLocationManager.authorizationStatus()) {
            //check if services disallowed for this app particularly
            case .restricted, .denied:
                print("No access")
                let accessAlert = UIAlertController(title: "Location Services Disabled", message: "You need to enable location services in settings.", preferredStyle: UIAlertControllerStyle.alert)
                
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
    
    private func loginWebRequest()
    {
        Utility.showProgressHud(text: "")
        LoginResponseModel.Login(username: TxtUserName.text!,
                                 password: TxtPassword.text!)
        { (user, error) in
            DispatchQueue.main.async {
                Utility.hideProgressHud()
                if(user != nil && user?.ErrorMessage == nil){
                    UserDeafultsManager.SharedDefaults.IsLoggedIn = true
                    UserDeafultsManager.SharedDefaults.CompanyID = String(user!.CompanyID);
                    UserDeafultsManager.SharedDefaults.MemberID = String(user!.EmployeeID);
                    UserDeafultsManager.SharedDefaults.Username = user!.Email
                    UserDeafultsManager.SharedDefaults.Password = user!.Password
                    UserDeafultsManager.SharedDefaults.FirstName = user!.FirstName
                    UserDeafultsManager.SharedDefaults.LastName = user!.LastName
                    UserDeafultsManager.SharedDefaults.IsRollCallAllowed = user!.ISRollCallAllowed
                    
                    self.performSegue(withIdentifier: "LoginSegue", sender: self);
                }else if(user != nil){
                    let info = ["title":"Error",
                                "message":user?.ErrorMessage,
                                "cancel":"Ok"]
                    Utility.showAlertWithInfo(infoDic: info as NSDictionary)
                }else{
                    let info = ["title":"Error",
                                "message":error,
                                "cancel":"Ok"]
                    Utility.showAlertWithInfo(infoDic: info as NSDictionary)
                }
            }
        }
    }
}
