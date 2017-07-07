
import Foundation
import UIKit

class ContactTableViewCell:UITableViewCell{

    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var displayNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photoView.layer.cornerRadius = 15
        photoView.clipsToBounds = true
    }
    
    class func reuseIdentifier() -> String {
        return "ContactCell"
    }
}
