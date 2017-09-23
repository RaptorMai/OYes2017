import UIKit
import Firebase

class LoginVerificationViewController: UIViewController {

    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    var mode: String = "Login"
    
    var phoneNumber: Int = 6478611125
    
    private var timerRemaining = 30
    {
        didSet {
            // update label everytime this is updated
            timerLabel?.text = "It takes about \(timerRemaining)s to reeive the code"
        }
    }
    
    private var timer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueButton.layer.cornerRadius = 5.0
        
        resendButton.layer.cornerRadius = 2
        disableButton(resendButton)
        
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 13.0, weight: CGFloat(1.0))
        
        phoneNumberLabel?.text = formatCellPhoneNumber(phoneNumber)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyborad))
        view.addGestureRecognizer(tapRecognizer)
        
        title = "Verify cellphone"
        
        // resend timer
        startTimer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // add a line under textfield
        let border = CALayer()
        let width = CGFloat(1.5)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: numberField.frame.size.height - width, width:  numberField.frame.size.width, height: numberField.frame.size.height)
        
        border.borderWidth = width
        numberField.layer.addSublayer(border)
        numberField.layer.masksToBounds = true
    }
    
    // MARK: - Cellphone number formatting
    
    /// Formats int phone number to (xxx)xxx xxxx format
    ///
    /// - Parameter num: Int format of phone number
    /// - Returns: formatted string
    func formatCellPhoneNumber(_ num: Int) -> String {
        let area = num / 10000000
        let mid = (num - area * 10000000) / 10000
        let last = num - area * 10000000 - mid * 10000
        return "+1 (\(area)) \(mid) \(last)"
    }
    
    // MARK: - Timer
    
    /// Start the timer, set remaining seconds to count and show the label displaying the time, disable the resend button
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
        timerRemaining = 30
        timerLabel?.isHidden = false
        disableButton(resendButton)
    }
    
    /// called everytime the timer fires, update timer count, enable the resentbutton when needed
    @objc func timerRunning() {
        timerRemaining -= 1
        
        if timerRemaining == 0 {
            timer?.invalidate()
            timerLabel.isHidden = true
            enableButton(resendButton)
        }
    }
    
    func disableButton(_ btn: UIButton) {
        btn.isEnabled = false
        btn.isHidden = true
    }
    
    func enableButton(_ btn: UIButton) {
        btn.isEnabled = true
        btn.isHidden = false
    }
    
    @IBAction func resendCode(_ sender: UIButton) {
        startTimer()
        requestCode(forNumber: "\(phoneNumber)")
    }
    
    
    /// Verifies authentication code
    /// The verification key should have been saved by helper reqeustCode(forNumber:), and stored in userDefaults under "authVID". It then uess firebase API to authenticate. After authentication, it calls hyphenate API to login/register user depending on the operation mode (self.mode) of this VC
    @IBAction func verifyCode(sender: UIButton) {
        view.endEditing(true)
        // show hud
        showHud(in: view, hint: "Verifying")
        // key is stored while requesting for the verification code
        if let verificationKey = UserDefaults.standard.string(forKey: "authVID") {
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationKey, verificationCode: numberField.text!)
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if error != nil {
                    print("error: \(String(describing: error?.localizedDescription))")
                    let alertView = UIAlertController(title: "Login failed", message: error?.localizedDescription, preferredStyle: .alert)
                    alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alertView, animated: true, completion: nil)
                } else {
                    // cellphone login successful
                    let userInfo = user?.providerData[0]
                    
                    // log into hyphenate
                    if self.mode == "Login" {
                        self.hyphenateLogin()
                    } else {
                        self.hyphenateSignup()
                    }
                }
            })
        }
    }
    
    /// Login the user to hyphenate using cellphone number as username. If the user is not found, it prompts to send code for signup.
    func hyphenateLogin() {
        // log in with phone number now
        EMClient.shared().login(withUsername: String(phoneNumber), password: String(phoneNumber)) { (username, error) in
            if error != nil {
                self.hideHud()
                let alert = UIAlertController(title:"Login failure", message: error?.errorDescription, preferredStyle: .alert)
                
                if error!.code == EMErrorUserNotFound {
                    alert.addAction(UIAlertAction(title: "Request code for sign up", style: .default, handler: { (action) in
                        requestCode(forNumber: String(self.phoneNumber))
                        self.mode = "signup"
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                        self.navigationController?.popToRootViewController(animated: true)
                    }))
                } else {
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .cancel, handler: nil))
                }
                
                self.present(alert, animated: true, completion: nil)
            } else if EMClient.shared().isLoggedIn {
                // no error and is logged in
                EMClient.shared().options.isAutoLogin = true
                
                (UIApplication.shared.delegate as! AppDelegate).proceedLogin()
            }
        }
    }
    
    /// Signup the user to hyphenate using cellphone number as username. If the user is not found, it prompts to send code for login.
    func hyphenateSignup() {
        EMClient.shared().register(withUsername: String(phoneNumber), password: String(phoneNumber)) { (userID, error) in
            if error != nil {
                self.hideHud()
                let alert = UIAlertController(title:"Registration Failure", message: error?.errorDescription, preferredStyle: .alert)
                if error!.code == EMErrorUserAlreadyExist {
                    // user exists
                    alert.addAction(UIAlertAction(title: "Request code for login", style: .default, handler: { (action) in
                        requestCode(forNumber: String(self.phoneNumber))
                        self.mode = "Login"
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                        self.navigationController?.popToRootViewController(animated: true)
                    }))
                } else {
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .cancel, handler: nil))
                }

                self.present(alert, animated: true, completion: nil)
            } else {
                self.hyphenateLogin()
            }
        }
    }
    
    @objc func dismissKeyborad() {
        view.endEditing(true)
    }
}
