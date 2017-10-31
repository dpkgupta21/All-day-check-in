//
//  CompanyZoneResponseModel
//  CompanyZoneResponseModel
//
//  Created by Akash Deep Kaushik on 02/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit
import AEXML

class CompanyZoneModel: NSObject {

    var TimeZoneID:Int!
    var TimeZoneValue:String!
    var CompanyID:Int!
    var TimeZoneName:String!
    var ISActive:Bool!

    init(xml:AEXMLElement) {
        
        do{
            TimeZoneID = xml["TimeZoneID"].value?.toInt()
            TimeZoneValue = xml["TimeZoneValue"].value
            CompanyID = xml["CompanyID"].value?.toInt()
            TimeZoneName = xml["TimeZoneName"].value
            ISActive = xml["ISActive"].value?.toBool()
        }catch {
            print("\(error)")
        }
        
        
    }
    
    
}
