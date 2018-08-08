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
    var strHours: String!
    var strMins: String!
    var strSec: String!
    
    override init(xml:Data) {
        super.init(xml:xml)
        do{
            let xmlDoc = try? AEXMLDocument(xml: xml)
            let result = xmlDoc?.root["ResultDoc"]
            if(result?.value != nil){
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"//this your string date format
                let strDate = result?.value
                print("strData ",strDate!)
                let endIndex = strDate?.index((strDate?.endIndex)!, offsetBy: -6)
                var truncated = strDate?.substring(to: endIndex!)
                truncated! += "+00:00"
                time = dateFormatter.date(from: truncated!)//result?.value?.toTime()
                
                let start = strDate?.index((strDate?.startIndex)!, offsetBy: 11)
                let strTemp = strDate?.substring(from: start!)
                let endHours = strTemp?.index((strTemp?.startIndex)!, offsetBy: 2)
                
                strHours = strTemp?.substring(to:endHours!)
                strMins = strDate?.substring(from: (strDate?.index((strDate?.startIndex)!, offsetBy: 14))!)
                strMins = strMins?.substring(to:(strMins?.index((strMins?.startIndex)!, offsetBy: 2))!)
                
                strSec = strDate?.substring(from: (strDate?.index((strDate?.startIndex)!, offsetBy: 17))!)
                
                strSec = strSec?.substring(to:(strSec?.index((strSec?.startIndex)!, offsetBy: 2))!)
                print("Time to show is ",self.strHours,":",self.strMins,":", self.strSec)
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
                callback(a, error)
            }else{
                callback(nil,error)
            }
            
        }
        
    }
    
}
