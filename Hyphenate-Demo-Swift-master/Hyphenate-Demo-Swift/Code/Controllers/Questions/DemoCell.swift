//
//  DemoCell.swift
//  FoldingCell
//
//  Created by Alex K. on 25/12/15.
//  Copyright © 2015 Alex K. All rights reserved.
//

import UIKit
import FoldingCell

class DemoCell: FoldingCell {
  
  @IBOutlet weak var closeNumberLabel: UILabel!
  @IBOutlet weak var openNumberLabel: UILabel!
  
    @IBOutlet weak var closeDescription: UILabel!
    
    @IBOutlet weak var openDescription: UILabel!
    
    @IBOutlet weak var closeQuestPic: UIImageView!
    
    @IBOutlet weak var openQuestPic: UIImageView!
    
  var subject: String = "n/a" {
    didSet {
      closeNumberLabel.text = subject
      openNumberLabel.text = subject
    }
  }
  
  override func awakeFromNib() {
    foregroundView.layer.cornerRadius = 10
    foregroundView.layer.masksToBounds = true
    super.awakeFromNib()
  }
  
  override func animationDuration(_ itemIndex: NSInteger, type: FoldingCell.AnimationType) -> TimeInterval {
    let durations = [0.26, 0.2, 0.2]
    return durations[itemIndex]
  }
  
}

// MARK: - Actions ⚡️
extension DemoCell {
  
  @IBAction func buttonHandler(_ sender: AnyObject) {
    print("tap")
  }
  
}
