//
//  CheckInResponseModel.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 02/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit
import AEXML
import CoreLocation

class CheckInResponseModel: BaseModel {

    
    var msg:String!
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
                msg = temp?[2];
            }
            
        }catch {
            print("\(error)")
        }
        
        
    }
    
    static func CheckIn(status:String,callback:@escaping (_ result:CheckInResponseModel?,_ error:NSString?)->Void)
    {
        let dictionary = [
            "empID" : UserDeafultsManager.SharedDefaults.MemberID,
            "status" : status,
            "longitude":String(describing: CLLocationManager().location?.coordinate.longitude),
            "latitude":String(describing: CLLocationManager().location?.coordinate.latitude)
        ]
        let xml = XMLParser.CreateXML(data: dictionary)
        
        WebserviceCommunication.defaultCommunicator().httpPOSTEncodedString(methodName: METHOD_INSERTCLOCK ,valuesString: xml)
        { (data, statusCode, error) in
            if(data != nil){
                let a = CheckInResponseModel(xml: (data as! Data))
                callback(a,error)
            }else{
                callback(nil,error)
            }
            
            
        }
        
    }
    
}
