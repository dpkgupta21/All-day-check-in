//
//  UITextField+Padding.swift
//  IPO
//
//  Created by Chandan on 22/04/16.
//  Copyright © 2016 Pratham Software Pvt. Ltd. All rights reserved.
//

import UIKit

extension UITextField {
    
    func setLeftPadding(paddingValue: CGFloat)
    {
        let paddingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: paddingValue, height: self.frame.height));
        self.leftView = paddingView;
        self.leftViewMode = .always
    }
    
}
