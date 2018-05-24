//
//  ServerTimeResponseModel.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 02/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit
import AEXML

class ServerTimeResponseModel: BaseModel {

    var time:Date!
    
    override init(xml:Data) {
        super.init(xml:xml)
        do{
            
            let xmlDoc = try? AEXMLDocument(xml: xml)
            let result = xmlDoc?.root["ResultDoc"]
            if(result?.value != nil){
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"//this your string date format
                let strDate = result?.value
                let endIndex = strDate?.index((strDate?.endIndex)!, offsetBy: -6)
                var truncated = strDate?.substring(to: endIndex!)
                truncated! += "+00:00"
                time = dateFormatter.date(from: truncated!)//result?.value?.toTime()
            }
            
        }catch {
            print("\(error)")
        }
        
        
    }
    
    static func FetchTime(callback:@escaping (_ result:ServerTimeResponseModel?,_ error:NSString?)->Void)
    {
        let dictionary = [
            "companyID" : UserDeafultsManager.SharedDefaults.CompanyID
        ]
        let xml = XMLParser.CreateXML(data: dictionary)
        
        WebserviceCommunication.defaultCommunicator().httpPOSTEncodedString(methodName: METHOD_SERVERTIME ,valuesString: xml)
        { (data, statusCode, error) in
            if(data != nil){
                let a = ServerTimeResponseModel(xml: (data as! Data))
                callback(a,error)
            }else{
                callback(nil,error)
            }
            
        }
        
    }
    
}
