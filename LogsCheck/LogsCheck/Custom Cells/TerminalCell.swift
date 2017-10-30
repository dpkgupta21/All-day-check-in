//
//  TerminalCell.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 02/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class TerminalCell: UITableViewCell {

    @IBOutlet weak var ImgCheck: UIImageView!
    @IBOutlet weak var LblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(data:TerminalModel){
        LblTitle.text = data.TerminalName
        ImgCheck.isHighlighted = data.IsSelected
    }

}
