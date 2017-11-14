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
    var DayIn1:Date!
    var EmployeeName:String!
    
    init(xml:AEXMLElement) {
        
        do{
            ClockCardID = xml["ClockCardID"].value?.toInt()
            EmployeeID = xml["EmployeeID"].value?.toInt()
            WorkDate = xml["WorkDate"].value?.toDate(format: Utility.longDateFormat)
            DayIn1 = xml["DayIn1"].value?.toDate(format: "HHmm")
            EmployeeName = xml["EmployeeName"].value
        }catch {
            print("\(error)")
        }
        
        
    }
    
}
