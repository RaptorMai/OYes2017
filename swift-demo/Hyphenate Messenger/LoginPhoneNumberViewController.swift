import UIKit
import Firebase

class LoginPhoneNumberViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var bannerLabel: UILabel!
    
    var mode: LoginViewControllerMode = .login
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add a line under the text field
        // configure button
        verifyButton.layer.cornerRadius = 5.0
        
        numberField.delegate = self
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyborad))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // setting values here because the verification VC might pop, and view did load will not be called
        super.viewWillAppear(animated)
        let titleString = (mode == .login) ? "Login" : "Sign up"
        title = titleString
        
        let bannerTitle = (mode == .login) ? "Please log in with phone number" : "Please sign up with phone number"
        bannerLabel.text = bannerTitle
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // num field is laid out with autolayout, frames can change until now
        let border = CALayer()
        let width = CGFloat(1.5)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: numberField.frame.size.height - width, width:  numberField.frame.size.width, height: numberField.frame.size.height)
        
        border.borderWidth = width
        numberField.layer.addSublayer(border)
        numberField.layer.masksToBounds = true
    }

    @IBAction func verifyCellphone(_ sender: Any) {
        // verify cellphone, first check if the phone number is correctly formatted, alert user if not.
        // Otherwise, alert user to confirm cellphone number
        view.endEditing(true)
        if numberField.text == nil || !isPhoneNumberStringValid(numberField.text!) {
            let alertView = UIAlertController(title: "Phone number invalid", message: "The phone number is not valid, please double check", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Go back", style: .cancel, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        } else {
            let alertView = UIAlertController(title: "Verify cellphone", message: "We will send cellphone verification code to \(numberField.text!). Please confirm the phone number", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            // when confirming, request code to be sent
            let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
                requestCode(forNumber: self.numberField.text!)
                self.performSegue(withIdentifier: "verifyCellphone", sender: nil)
            }
            alertView.addAction(cancelAction)
            alertView.addAction(confirmAction)
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    
    /// Verifies phone number is formatted
    ///
    /// It strips white spaces, and check the length of string is 10. It writes the stripped string back to textfield
    /// - Parameter num: String of phone number, plain numbers only
    /// - Returns: true if num is 10 digits long
    func isPhoneNumberStringValid(_ num: String) -> Bool {
        let trimmedStr = num.trimmingCharacters(in: .whitespaces)
        numberField?.text = trimmedStr
        return trimmedStr.count == 10
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let verifyVC = segue.destination as! LoginVerificationViewController
        // setting the phone number and operation mode of verify VC
        // mode will determine whether VC calls signup or login for hyphenate
        verifyVC.phoneNumber = Int((numberField?.text)!)!
        verifyVC.mode = mode
    }
    
    @objc func dismissKeyborad()
    {
        view.endEditing(true)
    }
    


}
