import UIKit
import CoreTelephony

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var logoImagView: UIImageView!
    
    // only display animation once
    var animationDisplayed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 5.0
        loginButton.alpha = 0
        loginButton.center.y += 15
        signupButton.layer.cornerRadius = 5.0
        signupButton.alpha = 0
        signupButton.center.y += 15

        
        // setting color of back arrow in navigation bar
        navigationController?.navigationBar.tintColor = UIColor(red: 45.0/255.0, green: 162.0/255.0, blue: 220.0/255.0, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !animationDisplayed {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.logoImagView.center.y -= UIScreen.main.bounds.size.height * 0.08
            }, completion: nil)
            
            UIView.animate(withDuration: 0.2, delay: 0.5, options: [.curveEaseInOut], animations: {
                self.loginButton.alpha = 1
                self.loginButton.center.y -= 15
                self.signupButton.alpha = 1
                self.signupButton.center.y -= 15
            }, completion: nil)
            
            animationDisplayed = true
        }
    }
    
    /// Determines whether carrier service exist
    ///
    /// If service is not existant, present a alert view to warn the user
    /// - Returns: true when service is available, false otherwise
    func carrierServiceExists() -> Bool {
        // verify carrier service is present - for receiving verification code
        let telephonyInfo = CTTelephonyNetworkInfo()
        if telephonyInfo.subscriberCellularProvider == nil {
            // no carrier info, should not continue
            let alert = UIAlertController(title: "Error", message: "Please make sure the carrier service is available", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(okay)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let loginPhoneVC = segue.destination as! LoginPhoneNumberViewController
        loginPhoneVC.mode = segue.identifier!
        navigationController?.navigationBar.isHidden = false
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return carrierServiceExists()
    }
}

