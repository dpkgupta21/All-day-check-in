//
//  CheckBtnStatusResponseModel.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 03/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit
import AEXML

class CheckBtnStatusResponseModel: BaseModel {

    var showCheckIn:Bool!
    var showCheckout:Bool!
    
    
    override init(xml:Data) {
        super.init(xml:xml)
        do{
            let xmlDoc = try? AEXMLDocument(xml: xml)
            let result = xmlDoc?.root["ResultDoc"]
            if(result?.value != nil){
                let temp = result?.value!.components(separatedBy: ":");
                showCheckIn = temp?[0] == "1";
                showCheckout = temp?[1] == "1";
            }
            
        }catch {
            print("\(error)")
        }
        
        
    }
    
    static func GetStatus(callback:@escaping (_ result:CheckBtnStatusResponseModel?,_ error:NSString?)->Void)
    {
        let dictionary = [
            "employeeID" : UserDeafultsManager.SharedDefaults.MemberID
        ]
        let xml = XMLParser.CreateXML(data: dictionary)
        
        WebserviceCommunication.defaultCommunicator().httpPOSTEncodedString(methodName: METHOD_GETBUTTONSTATUS ,valuesString: xml)
        { (data, statusCode, error) in
            if(data != nil){
                let a = CheckBtnStatusResponseModel(xml: (data as! Data))
                callback(a,error)
            }else{
                callback(nil,error)
            }
            
            
        }
        
    }
}
