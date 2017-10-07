//
//  XMLParser.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 30/09/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit
import AEXML

class XMLParser {
    
    static func CreateXML(data:Dictionary<String, String>) -> String{
       let soapRequest = AEXMLDocument()
        let root = soapRequest.addChild(name: "ATSMAPIParams")
        for item in data {
            root.addChild(name: item.key, value: item.value, attributes: [:])
        }
        
        return soapRequest.xml;
        
    }
    

}
