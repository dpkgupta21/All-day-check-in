//
//  LogModel.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 02/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit
import AEXML

class LogModel: NSObject {

    var LogID:Int!
    var EmployeeID:Int!
    var LogDate:Date!
    var Description:String!
    
    init(xml:AEXMLElement) {
        
        do{
            LogID = xml["LogId"].value?.toInt()
            EmployeeID = xml["EmployeeID"].value?.toInt()
            LogDate = xml["LogDate"].value?.toDate(format: Utility.longDateFormat)
            Description = xml["Description"].value
            
        }catch {
            print("\(error)")
        }
        
        
    }
    
    
}
