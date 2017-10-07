//
//  RollCallModel.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 02/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit
import AEXML

class RollCallModel: NSObject {

    var ClockCardID:Int!
    var EmployeeID:Int!
    var WorkDate:Date!
    
    init(xml:AEXMLElement) {
        
        do{
            ClockCardID = xml["ClockCardID"].value?.toInt()
            EmployeeID = xml["EmployeeID"].value?.toInt()
            WorkDate = xml["WorkDate"].value?.toDate(format: Utility.longDateFormat)
            
        }catch {
            print("\(error)")
        }
        
        
    }
    
}
