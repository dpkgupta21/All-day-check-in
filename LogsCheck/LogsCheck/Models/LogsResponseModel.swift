//
//  LogsResponseModel.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 02/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit
import AEXML

class LogsResponseModel: BaseModel {
    
    var Logs:[LogModel] = []
    
    override init(xml:Data) {
        super.init(xml:xml)
        do{
            let xmlDoc = try? AEXMLDocument(xml: xml)
            let result = xmlDoc?.root["ResultDoc"]
            if(result != nil && (result?.children.count)!>0){
                for item in (result?.children)! {
                    let model = LogModel(xml: item)
                    Logs.append(model)
                }
            }
            
        }catch {
            print("\(error)")
        }
        
        
    }
    
    static func GetLogs(startDate:Date, endDate:Date,callback:@escaping (_ result:LogsResponseModel?,_ error:NSString?)->Void)
    {
        let dictionary = [
            "employeeID" : UserDeafultsManager.SharedDefaults.MemberID,
            "fromDate":startDate.longDateString,
            "toDate":endDate.longDateString
        ]
        let xml = XMLParser.CreateXML(data: dictionary)
        
        WebserviceCommunication.defaultCommunicator().httpPOSTEncodedString(methodName: METHOD_GETLOGS ,valuesString: xml)
        { (data, statusCode, error) in
            if(data != nil){
                let a = LogsResponseModel(xml: (data as! Data))
                callback(a,error)
            }else{
                callback(nil,error)
            }
            
            
        }
        
    }
    
    

}
