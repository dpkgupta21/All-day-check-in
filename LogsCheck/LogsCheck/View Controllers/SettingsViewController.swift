//
//  SettingsViewController.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 30/09/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var BtnSubmit: UIButton!
    @IBOutlet weak var TxtPassword: UITextField!
    @IBOutlet weak var TxtUserName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TxtPassword.text = UserDeafultsManager.SharedDefaults.Password
        TxtUserName.text = UserDeafultsManager.SharedDefaults.Username
        
        TxtPassword.delegate = self
        TxtUserName.delegate = self
        
        TxtPassword.returnKeyType = .done
        TxtUserName.returnKeyType = .done
    }
    
    @IBAction func BtnSubmitClicked(_ sender: Any) {
        
        UserDeafultsManager.SharedDefaults.Password = TxtPassword.text ?? ""
        UserDeafultsManager.SharedDefaults.Username = TxtUserName.text ?? ""
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    //Hide Keyboard when User click outside text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //This will hide the keyboard
    }
}
