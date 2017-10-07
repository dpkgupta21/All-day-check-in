//
//  TerminalResponseModel.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 02/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit
import AEXML

class TerminalResponseModel: BaseModel {

    
    var Terminals:[TerminalModel] = []
    
    override init(xml:Data) {
        super.init(xml:xml)
        do{
            let xmlDoc = try? AEXMLDocument(xml: xml)
            let result = xmlDoc?.root["ResultDoc"]
            if(result != nil && (result?.children.count)!>0){
                for item in (result?.children)! {
                    let model = TerminalModel(xml: item)
                    Terminals.append(model)
                }
            }
            
        }catch {
            print("\(error)")
        }
        
        
    }
    
    static func GetTerminals(callback:@escaping (_ result:TerminalResponseModel?,_ error:NSString?)->Void)
    {
        let dictionary = [
            "companyID" : UserDeafultsManager.SharedDefaults.CompanyID,
        ]
        let xml = XMLParser.CreateXML(data: dictionary)
        
        WebserviceCommunication.defaultCommunicator().httpPOSTEncodedString(methodName: METHOD_GETTERMINALS ,valuesString: xml)
        { (data, statusCode, error) in
            if(data != nil){
                let a = TerminalResponseModel(xml: (data as! Data))
                callback(a,error)
            }else{
                callback(nil,error)
            }
            
            
        }
        
    }
    
}
