//
//  LogsCell.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 02/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class LogsCell: UITableViewCell {

    @IBOutlet weak var LblTime: UILabel!
    @IBOutlet weak var LblDesc: UILabel!
    @IBOutlet weak var LblDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(data:LogModel){
        LblDate.attributedText = Utility.getAttributedString(date: data.LogDate)
        LblDesc.text = data.Description
        LblTime.text = data.LogDate.shortTimeString
    }

}
