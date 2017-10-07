//
//  TerminalModel.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 02/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit
import AEXML

class TerminalModel: NSObject {
    
    var TerminalID:Int!
    var TerminalName:String!
    var TerminalType:String!
    var TerminalIP:String!
    var CompanyID:Int!
    var IsSelected:Bool!
    
    init(xml:AEXMLElement) {
        
        do{
            TerminalID = xml["TerminalID"].value?.toInt()
            CompanyID = xml["CompanyID"].value?.toInt()
            TerminalName = xml["TerminalName"].value
            TerminalType = xml["TerminalType"].value
            TerminalIP = xml["TerminalIP"].value
            IsSelected = false
            
        }catch {
            print("\(error)")
        }
        
        
    }
    

}
