//
//  RollCallCell.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 02/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class RollCallCell: UITableViewCell {

    @IBOutlet weak var LblTitle: UILabel!
    @IBOutlet weak var LblTime: UILabel!
    @IBOutlet weak var LblDesc: UILabel!
    @IBOutlet weak var LblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(data:RollCallModel){
        LblDate.attributedText = Utility.getAttributedString(date: data.WorkDate)
        LblDesc.text = String(data.EmployeeID)
        LblTime.text = data.WorkDate.shortTimeString
    }

}
