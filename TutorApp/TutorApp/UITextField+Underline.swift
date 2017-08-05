//
//  UITextField+Underline.swift
//  TutorApp
//
//  Created by devuser on 2017-08-04.
//  Copyright © 2017 sul. All rights reserved.
//

import UIKit

extension UITextField{
    func setBottomBorder(color:String)
    {
        self.borderStyle = UITextBorderStyle.none;
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(hex: color).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
}
