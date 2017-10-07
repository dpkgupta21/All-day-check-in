//
//  BaseModel.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 30/09/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit
import AEXML

class BaseModel: NSObject {
    
    var ISFailed:Bool!
    var statusCode:String!
    var ErrorMessage:String!
    
    init(xml:Data) {
       
        do{
            let xmlDoc = try? AEXMLDocument(xml: xml)
            ISFailed = xmlDoc?.root["ISFailed"].value?.toBool()
            ErrorMessage = xmlDoc?.root["ErrorMessage"].value
            statusCode = xmlDoc?.root["StatusCode"].value
            
        }catch {
            print("\(error)")
        }
        
        
    }
    
}
