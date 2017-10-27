import UIKit

enum PrivacyMode {
    case privacyMode
    case termsMode
}

class PrivacyViewController: UIViewController {
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var textView: UITextView!
    
    var mode: PrivacyMode = .privacyMode
    override func viewDidLoad() {
        super.viewDidLoad()
        if mode == .privacyMode {
            navBar.topItem?.title = "Privacy policy"
            textView.text = "No privacy"
        } else {
            navBar.topItem?.title = "Terms of Use"
            textView.text = "Don't use"
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
