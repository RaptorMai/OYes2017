
import UIKit
import Firebase
import Hyphenate

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var phoneNumber: HyphenateTextField!
    @IBOutlet weak var verificationCode: HyphenateTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginButtonBottomConstraint: NSLayoutConstraint!
    var kbHeight: CGFloat!
    var animated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        
        let loginButton:UIButton = UIButton(type: .custom)
            loginButton.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50)
            loginButton.backgroundColor = UIColor.hiPrimary()
            loginButton.setTitle("Log In", for: .normal)
       
        loginButton.addTarget(self, action: #selector(LoginViewController.loginAction(_:)), for: .touchUpInside)
        phoneNumber.inputAccessoryView = loginButton
        verificationCode.inputAccessoryView = loginButton
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func dismissKeyboard(){
        phoneNumber.resignFirstResponder()
        verificationCode.resignFirstResponder()
    }
    
    @IBAction func loginRequestCodeAction(_ sender: UIButton) {
        //check for valid number in PhoneNum
        let PhoneNumValid = true
        
        //TODO: check if user is in firebase, don't allow login if not in firebase
//        let database = Database.database().reference()
//        database.child("Users").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
//            print(snapshot)
//            if snapshot.hasChild("+1\(self.phoneNumber.text!)")
//            {
//                print("User not in system")
//                PhoneNumValid = false
//            }
//        }
//        )
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
        }
    }
    
    @IBAction func loginAction(_ sender: AnyObject) {
        
        activityIndicator.startAnimating()
        
        let defaults = UserDefaults.standard
        
        /* log in to firebase with phone number  *************/
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVID")!, verificationCode: self.verificationCode.text!)
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
        /******************************************************/
                /* login to firebase succeeded, can login to hyphenate  *********/
                EMClient.shared().login(withUsername: self.phoneNumber.text, password: self.phoneNumber.text) { (userName : String?, error : EMError?) in

                    if ((error) != nil) {
                        let alert = UIAlertController(title:"Login Failure", message: error?.errorDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .cancel, handler: nil))
                        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                    } else if EMClient.shared().isLoggedIn {
                        EMClient.shared().options.isAutoLogin = true
                        
                        //login finished, create main view controller
                        //self.performSegue(withIdentifier: "LoginToHome", sender: Any?.self)
                        let mainVC = MainViewController()
                        HyphenateMessengerHelper.sharedInstance.mainVC = mainVC
                        self.navigationController?.pushViewController(mainVC, animated: true)
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
            loginAction(self)
        }
        return true
    }
}
