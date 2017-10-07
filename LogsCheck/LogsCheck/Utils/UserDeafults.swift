//
//  UserDeafults.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 30/09/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class UserDeafultsManager: NSObject {
    
    private static let _sharedInstance = UserDeafultsManager()
    
    public static var  SharedDefaults : UserDeafultsManager
    {
        get{ return _sharedInstance;}
    }
    
    
    let IsLoginKey = "IsLogin"
    let CompanyIDKey = "CompanyID"
    let MemberIDKey = "MemberID"
    let UsernameKey = "UsernameKey"
    let PasswordKey = "PasswordKey"
    let FirstNameKey = "FirstNameKey"
    let LastNameKey = "LastNameKey"
    
    
    
    var IsLoggedIn : Bool{
        get{
           return UserDefaults.standard.bool(forKey: IsLoginKey)
        }
        set (value){
             UserDefaults.standard.set(value, forKey: IsLoginKey)
        }
    }
    
    var CompanyID : String{
        get{
            return UserDefaults.standard.string(forKey: CompanyIDKey)!
        }
        set (value){
            UserDefaults.standard.set(value, forKey: CompanyIDKey)
        }
        
    }
    
    var MemberID : String{
        get{
            return UserDefaults.standard.string(forKey: MemberIDKey)!
        }
        set (value){
            UserDefaults.standard.set(value, forKey: MemberIDKey)
        }
        
    }
    
    var Username : String{
        get{
                return UserDefaults.standard.string(forKey: UsernameKey) ?? ""
        }
        set (value){
            UserDefaults.standard.set(value, forKey: UsernameKey)
        }
        
    }
    
    var Password : String{
        get{
            return UserDefaults.standard.string(forKey: PasswordKey) ?? ""
        }
        set (value){
            UserDefaults.standard.set(value, forKey: PasswordKey)
        }
        
    }
    
    var FirstName : String{
        get{
            return UserDefaults.standard.string(forKey: FirstNameKey) ?? ""
        }
        set (value){
            UserDefaults.standard.set(value, forKey: FirstNameKey)
        }
        
    }
    
    var LastName : String{
        get{
            return UserDefaults.standard.string(forKey: LastNameKey) ?? ""
        }
        set (value){
            UserDefaults.standard.set(value, forKey: LastNameKey)
        }
        
    }
    

}
