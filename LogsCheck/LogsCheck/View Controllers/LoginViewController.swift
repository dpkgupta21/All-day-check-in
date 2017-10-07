//
//  LoginViewController.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 17/09/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var BtnLogin: UIButton!
    @IBOutlet weak var TxtPassword: UITextField!
    @IBOutlet weak var TxtUserName: UITextField!
    @IBOutlet weak var ImgLogo: UIImageView!
    @IBOutlet weak var BtnForgotPassword: UIButton!
    @IBOutlet weak var BtnShowPassword: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.TxtUserName.text = UserDeafultsManager.SharedDefaults.Username
         self.TxtPassword.text = UserDeafultsManager.SharedDefaults.Password
        if (UserDeafultsManager.SharedDefaults.IsLoggedIn){
           self.performSegue(withIdentifier: "LoginSegue", sender: self);
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BtnLoginlClicked(_ sender: Any) {
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
                    
                    CheckInResponseModel.CheckIn(status: "Login", callback: { (checkin, error) in
                        DispatchQueue.main.async {
                            if(checkin != nil && checkin?.ErrorMessage == nil){
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
//         self.performSegue(withIdentifier: "LoginSegue", sender: self);
    }
  
    @IBAction func ForgotPasswordClicked(_ sender: Any) {
        
    }
    
    
    @IBAction func ShowPasswordClicked(_ sender: Any) {
        BtnShowPassword.isSelected = !BtnShowPassword.isSelected;
        TxtPassword.isSecureTextEntry = !BtnShowPassword.isSelected;
        
    }
}
