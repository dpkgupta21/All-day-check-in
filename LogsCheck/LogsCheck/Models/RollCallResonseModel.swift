//
//  RollCallResonseModel.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 02/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit
import AEXML

class RollCallResonseModel: BaseModel {

    var RollCalls:[RollCallModel] = []
    
    override init(xml:Data) {
        super.init(xml:xml)
        do{
            let xmlDoc = try? AEXMLDocument(xml: xml)
            let result = xmlDoc?.root["ResultDoc"]
            if(result != nil && (result?.children.count)!>0){
                for item in (result?.children)! {
                    let model = RollCallModel(xml: item)
                    RollCalls.append(model)
                }
            }
            
        }catch {
            print("\(error)")
        }
        
        
    }
    
    static func GetRollCalls(terminals:String,callback:@escaping (_ result:RollCallResonseModel?,_ error:NSString?)->Void)
    {
        let dictionary = [
            "employeeID" : UserDeafultsManager.SharedDefaults.MemberID,
            "terminals" : terminals
        ]
        let xml = XMLParser.CreateXML(data: dictionary)
        
        WebserviceCommunication.defaultCommunicator().httpPOSTEncodedString(methodName: METHOD_GETROLLCALL ,valuesString: xml)
        { (data, statusCode, error) in
            if(data != nil){
                let a = RollCallResonseModel(xml: (data as! Data))
                callback(a,error)
            }else{
                callback(nil,error)
            }
            
            
        }
        
    }
    
}
