import UIKit
import Firebase
import Hyphenate

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var phoneNumber: HyphenateTextField!
    @IBOutlet weak var verificationCode: HyphenateTextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        
        let loginButton:UIButton = UIButton(type: .custom)
        loginButton.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50)
        loginButton.backgroundColor = UIColor.hiPrimary()
        loginButton.setTitle("Sign Up", for: .normal)
        
        loginButton.addTarget(self, action: #selector(SignUpViewController.signupAction(_:)), for: .touchUpInside)
        phoneNumber.inputAccessoryView = loginButton
        verificationCode.inputAccessoryView = loginButton
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }

    func dismissKeyboard(){
        phoneNumber.resignFirstResponder()
        verificationCode.resignFirstResponder()
    }

    
    @IBAction func signupRequestCodeAction(_ sender: UIButton) {
        //check for valid number in PhoneNum
        let PhoneNumValid = true
        if PhoneNumValid {
            let alert = UIAlertController(title: "Phone number", message: "Is this your phone number? \n \(phoneNumber.text!)", preferredStyle: .alert)
            let action = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
                PhoneAuthProvider.provider().verifyPhoneNumber("+1\(self.phoneNumber.text!)") { (verificationID, error) in
                    if error != nil {
                        print (" error: \(String(describing: error?.localizedDescription))")
                    } else {
                        let defaults = UserDefaults.standard
                        defaults.set(verificationID, forKey: "authVID")
                    }
                }
            }
            let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        } else {
            //insert error for invalid number
        }
    }
    
    @IBAction func signupAction(_ sender: AnyObject) {
        activityIndicator.startAnimating()
        
        /* signup for firebase first */
        let defaults = UserDefaults.standard
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVID")!, verificationCode: verificationCode.text!)
        Auth.auth().signIn(with: credential) { (user, error) in
            self.activityIndicator.stopAnimating()
            if error != nil {
                print("error: \(String(describing: error?.localizedDescription))")
                //Popup error indicating an error occured
                let alert = UIAlertController(title: "Error", message: "An error has occured", preferredStyle: .alert)
                let okay = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okay)
                self.present(alert, animated: true, completion: nil)
                
            } else{
                print("Phone number: \(String(describing: user?.phoneNumber))")
                let userInfo = user?.providerData[0]
                print("Provider ID: \(String(describing: userInfo?.providerID))")
                /****************************/
                /* signup for hyphenate */
                EMClient.shared().register(withUsername: self.phoneNumber.text, password: self.phoneNumber.text) { (userID, error) in
                    
                    if ((error) != nil) {
                        self.activityIndicator.stopAnimating()
                        let alert = UIAlertController(title:"Registration Failure", message: error?.errorDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .cancel, handler: nil))
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                    } else {
                        EMClient.shared().login(withUsername: self.phoneNumber.text, password: self.phoneNumber.text, completion: { (userID, error) in
                            if ((error) != nil) {
                                let alert = UIAlertController(title:"Login Failure", message: error?.errorDescription, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .cancel, handler: nil))
                                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                            } else if EMClient.shared().isLoggedIn {
                                EMClient.shared().options.isAutoLogin = true
                                
                                //register & login finished, segue to main view
                                let mainVC = MainViewController()
                                HyphenateMessengerHelper.sharedInstance.mainVC = mainVC
                                self.navigationController?.pushViewController(mainVC, animated: true)
                                //self.performSegue(withIdentifier: "RegisterToHome", sender: Any?.self)
                            }
                        })
                    }
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == phoneNumber {
            phoneNumber.resignFirstResponder()
            verificationCode.becomeFirstResponder()
        } else {
            signupAction(self)
        }
        return true
    }
}
