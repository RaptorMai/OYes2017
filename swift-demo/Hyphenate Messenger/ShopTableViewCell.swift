//
//  ShopTableViewCell.swift
//  Hyphenate Messenger
//
//  Created by Luyuan Chen on 2017-10-09.
//  Copyright © 2017 Hyphenate Inc. All rights reserved.
//

import UIKit

class ShopTableViewCell: UITableViewCell {
    // class variable
    static let height: CGFloat = 75
    
    // outlets
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var discountBadgeLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    
    let buttonCornerRadius:CGFloat = 5
    let labelCornerRadius:CGFloat = 4
    
    var productName: String? = nil
    var price: String? = nil
    var discounted = false
    var discountedPrice: String? = nil
    var discountRate: String? = nil
    
    
    func addPurchaseAction(_ target: Any?, action: Selector, amount tag: Int) {
        purchaseButton.addTarget(target, action: action, for: .touchUpInside)
        purchaseButton.tag = tag
    }
    
    func setDispayContent(packageName name: String, atPrice price: String, discounted dis: Bool, atPrice disPrice: String?, discountRate rate: String?) {
        self.productName = name
        self.price = price
        self.discounted = dis
        self.discountedPrice = disPrice
        self.discountRate = rate
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        productNameLabel.text = productName
        
        purchaseButton.layer.cornerRadius = buttonCornerRadius
        purchaseButton.layer.borderWidth = 1
        purchaseButton.layer.borderColor = purchaseButton.tintColor.cgColor
        purchaseButton.backgroundColor = .clear
        
        if discounted {
            discountBadgeLabel.text = discountRate
            discountBadgeLabel.layer.cornerRadius = labelCornerRadius
            discountBadgeLabel.layer.masksToBounds = true
            
            // strike through text: the original price
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: price!)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
            discountPriceLabel.attributedText = attributeString
            
            purchaseButton.setTitle(discountedPrice, for: .normal)
        } else {
            discountPriceLabel.isHidden = true
            discountBadgeLabel.isHidden = true
            
            // setting button to discounted price
            purchaseButton.setTitle(price, for: .normal)
        }
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
