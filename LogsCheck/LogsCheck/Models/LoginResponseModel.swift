//
//  LoginResponseModel.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 30/09/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit
import AEXML

class LoginResponseModel: BaseModel {
    
    var EmployeeID :Int!
    var CompanyID  :Int!
    var CompanyName :String!
    var DepartmentID :Int!
    var ManagerID :Int!
    var Email :String!
    var Password :String!
    var FirstName : String!
    var LastName : String!
    var HourlyRate :String!
    var ISOvertimeAllowed : Bool!
    var OvertimeRate : Int!
    var PayPeriodDays :Int!
    var EmpRoleID :Int!
    var GetTaskNotification : Bool!
    var GetProjectNotification :Bool!
    var CreatedOn : Date!
    var ISActive : Bool!
    var UpdatedOn : Date!
    var ISEmailVerified : Bool!
    var ISInvited :Bool!
    var ClockCardProEnabled :Int!
    var ISRollCallAllowed : Bool!
    
    
    override init(xml:Data) {
        super.init(xml:xml)
        do{
            let xmlDoc = try? AEXMLDocument(xml: xml)
            let result = xmlDoc?.root["ResultDoc"]
            if(result != nil){
                EmployeeID = result?["EmployeeID"].value?.toInt()
                CompanyID = result?["CompanyID"].value?.toInt()
                CompanyName = result?["CompanyName"].value
                DepartmentID = result?["DepartmentID"].value?.toInt()
                ManagerID = result?["ManagerID"].value?.toInt()
                Email = result?["Email"].value
                Password = result?["Password"].value
                FirstName = result?["FirstName"].value
                LastName = result?["LastName"].value
                HourlyRate = result?["HourlyRate"].value
                ISOvertimeAllowed = result?["ISOvertimeAllowed"].value?.toBool()
                OvertimeRate = result?["OvertimeRate"].value?.toInt()
                PayPeriodDays = result?["PayPeriodDays"].value?.toInt()
                EmpRoleID = result?["EmpRoleID"].value?.toInt()
                GetTaskNotification = result?["GetTaskNotification"].value?.toBool()
                GetProjectNotification = result?["GetProjectNotification"].value?.toBool()
                CreatedOn = result?["CreatedOn"].value?.toDate(format: Utility.longDateFormat)
                ISActive = result?["ISActive"].value?.toBool()
                UpdatedOn = result?["UpdatedOn"].value?.toDate(format: Utility.longDateFormat)
                ISEmailVerified = result?["ISEmailVerified"].value?.toBool()
                ISInvited = result?["ISInvited"].value?.toBool()
                ClockCardProEnabled = result?["ClockCardProEnabled"].value?.toInt()
                ISRollCallAllowed = result?["ISRollCallAllowed"].value?.toBool()
            }
            
        }catch {
            print("\(error)")
        }
        
        
    }
    
    static func Login(username:String,password:String,callback:@escaping (_ result:LoginResponseModel?,_ error:NSString?)->Void)
    {
        let dictionary = [
            "userName" : username,
            "password":password
        ]
        let xml = XMLParser.CreateXML(data: dictionary)
        
        WebserviceCommunication.defaultCommunicator().httpPOSTEncodedString(methodName: METHOD_LOGIN ,valuesString: xml)
        { (data, statusCode, error) in
            if(data != nil){
                let a = LoginResponseModel(xml: (data as! Data))
                callback(a,error)
            }else{
                callback(nil,error)
            }
            
            
        }
        
    }
}
