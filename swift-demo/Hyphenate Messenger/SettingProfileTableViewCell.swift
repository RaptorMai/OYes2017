
import UIKit

class SettingProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var senderImageView: UIImageView!
    //    @IBOutlet weak var badgeView: M13BadgeView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        senderImageView.layer.cornerRadius = 10.0
        senderImageView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
