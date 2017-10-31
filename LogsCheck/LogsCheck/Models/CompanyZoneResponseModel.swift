//
//  LogsResponseModel.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 02/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit
import AEXML

class CompanyZoneResponseModel: BaseModel {
    
    var timeZoneVal:String!
    // var Logs:[CompanyZoneResponseModel] = []
    
    //    override init(xml:Data) {
    //        super.init(xml:xml)
    //        do{
    //            let xmlDoc = try? AEXMLDocument(xml: xml)
    //            let result = xmlDoc?.root["ResultDoc"]
    //            if(result != nil && (result?.children.count)!>0){
    //                for item in (result?.children)! {
    //                    let model = CompanyZoneResponseModel(xml:item)
    //                    Logs.append(model)
    //                }
    //            }
    //
    //        }catch {
    //            print("\(error)")
    //        }
    //
    //
    //    }
    
    override init(xml:Data) {
        super.init(xml:xml)
        do{
            
            let xmlDoc = try? AEXMLDocument(xml: xml)
            let result = xmlDoc?.root["ResultDoc"]
            if(result?.children != nil){
                for x in (result?.children)! {
                    if(x.name == "TimeZoneValue"){
                        timeZoneVal = x.value;
                        print("\(timeZoneVal)")
                        break
                    }
                }
            }
            
        }catch {
            print("\(error)")
        }
        
        
    }
    
    
    static func FetchCompanyTimeZone(callback:@escaping (_ result:CompanyZoneResponseModel?,_ error:NSString?)->Void)
    {
        let dictionary = [
            "companyID" : UserDeafultsManager.SharedDefaults.CompanyID
        ]
        let xml = XMLParser.CreateXML(data: dictionary)
        
        WebserviceCommunication.defaultCommunicator().httpPOSTEncodedString(methodName: METHOD_COMPANY_TIME_ZONE ,valuesString: xml)
        { (data, statusCode, error) in
            if(data != nil){
                let a = CompanyZoneResponseModel(xml: (data as! Data))
                callback(a,error)
            }else{
                callback(nil,error)
            }
            
        }
        
    }
    
    
    
    
    
}
