//
//  LoginVC.swift
//  TutorApp
//
//  Created by devuser on 2017-08-03.
//  Copyright © 2017 sul. All rights reserved.
//

import UIKit
import Firebase
import Hyphenate
import MBProgressHUD


class LoginVC: UIViewController {
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth  = UIScreen.main.bounds.width
    var token: String?
    var ref: DatabaseReference?
    
    let Instructions: UILabel = {
        let label = UILabel()
        label.text = "Sign In With Account Name"
        label.textColor = UIColor.black
        label.font = UIFont(name: "Helvetica", size: 25)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    func setupInstructions(){
        Instructions.translatesAutoresizingMaskIntoConstraints = false
        Instructions.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        Instructions.topAnchor.constraint(equalTo: view.topAnchor, constant:125).isActive = true
        Instructions.widthAnchor.constraint(equalToConstant: screenWidth*0.8).isActive = true
    }

    let Username: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email Address"
        return tf

    }()
    
    func setupUsername(){
        Username.translatesAutoresizingMaskIntoConstraints = false
        Username.rightAnchor.constraint(equalTo: view.rightAnchor, constant:-screenWidth*0.075).isActive = true
        Username.topAnchor.constraint(equalTo: Instructions.bottomAnchor, constant:125).isActive = true
        Username.widthAnchor.constraint(equalToConstant: screenWidth*0.65).isActive = true
    }
    
    let Password: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Password"
        tf.isSecureTextEntry = true
        return tf
        
    }()
    
    func setupPassword(){
        Password.translatesAutoresizingMaskIntoConstraints = false
        Password.rightAnchor.constraint(equalTo: view.rightAnchor, constant:-screenWidth*0.075).isActive = true
        Password.topAnchor.constraint(equalTo: Username.bottomAnchor, constant:25).isActive = true
        Password.widthAnchor.constraint(equalToConstant: screenWidth*0.65).isActive = true
    }
    
    let EmailLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        label.text = "Account"
        return label
    }()
    
    func setupEmailLabel(){
        EmailLabel.translatesAutoresizingMaskIntoConstraints = false
        EmailLabel.rightAnchor.constraint(equalTo: Username.leftAnchor).isActive = true
        EmailLabel.topAnchor.constraint(equalTo: Username.topAnchor).isActive = true
        EmailLabel.widthAnchor.constraint(equalToConstant: screenWidth*0.2).isActive = true
    }
    
    let PasswordLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        label.text = "Password"
        return label
    }()
    
    func setupPasswordLabel(){
        PasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        PasswordLabel.rightAnchor.constraint(equalTo: Password.leftAnchor).isActive = true
        PasswordLabel.topAnchor.constraint(equalTo: Password.topAnchor).isActive = true
        PasswordLabel.widthAnchor.constraint(equalToConstant: screenWidth*0.2).isActive = true
    }
    
    let LoginButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(hex: "DEC164")
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(Login), for: .touchUpInside)
        return button
    }()
    
    func UsernameValid() -> Bool{
        if Username.text == nil{
            return false
        }
        return true
    }
    
    func PasswordValid() -> Bool{
        if Password.text == nil{
            return false
        }
        return true
    }
    
    func Login(){
        if UsernameValid() || PasswordValid() {
            Auth.auth().signIn(withEmail: Username.text!, password: Password.text!) { (user, error) in
                if error != nil {
                    print (" error: \(String(describing: error?.localizedDescription))")

                    //An alert window will appear if the account infomation is invalid.
                    let alertAccountController = UIAlertController(title: "Login", message: "Password is incorrect or the account does not exist.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in }
                    alertAccountController.addAction(okAction)
                    self.present(alertAccountController, animated: true)

                }
                else{
                    var usernameNoSign = self.Username.text!.replacingOccurrences(of: "@", with: "")
                    usernameNoSign = usernameNoSign.replacingOccurrences(of: ".", with: "")
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    weak var weakSelf = self
                    EMClient.shared().login(withUsername: usernameNoSign, password: self.Password.text!) { (username, error) in
                        MBProgressHUD.hide(for: weakSelf?.view, animated: true)
                        
                        if error == nil {
                            EMClient.shared().options.isAutoLogin = true
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue:KNOTIFICATION_LOGINCHANGE), object: NSNumber(value: true))
                        } else {
                            
                            var alertStr = ""
                            switch error!.code {
                            case EMErrorUserNotFound:
                                alertStr = error!.errorDescription
                                break
                            case EMErrorNetworkUnavailable:
                                alertStr = error!.errorDescription
                                break
                            case EMErrorServerNotReachable:
                                alertStr = error!.errorDescription
                                break
                            case EMErrorUserAuthenticationFailed:
                                alertStr = error!.errorDescription
                                break
                            case EMErrorServerTimeout:
                                alertStr = error!.errorDescription
                                break
                            default:
                                alertStr = error!.errorDescription  
                                break
                            }
                            
                            let alertView = UIAlertView.init(title: nil, message: alertStr, delegate: nil, cancelButtonTitle: "okay")
                            alertView.show()  
                        }
                    }
                    
                    
                    //Save token to firebase
                    if let tokenNotNil = self.token{
                        
                    let addToken = ["token": tokenNotNil] as [String: String?]
                        self.ref?.child("tutors/\(usernameNoSign)").updateChildValues(addToken)
                    
                    
                    }
                    
                    
                    
                    
                    let homeVC = UIStoryboard(name: "CellPrototype", bundle: nil).instantiateViewController(withIdentifier: "MainTabView")

                    
                    self.present(homeVC, animated: true, completion: nil)
                    

                }
            }
        }
    }
    
    func setupLoginButton(){
        LoginButton.translatesAutoresizingMaskIntoConstraints = false
        LoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        LoginButton.topAnchor.constraint(equalTo: Password.bottomAnchor, constant:150).isActive = true
        LoginButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        LoginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override func viewDidLayoutSubviews(){
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: Username.frame.size.height - width, width:  Username.frame.size.width, height: Username.frame.size.height)
        
        border.borderWidth = width
        Username.layer.addSublayer(border)
        Username.layer.masksToBounds = true
        
        let border2 = CALayer()
        border2.borderColor = UIColor.lightGray.cgColor
        border2.frame = CGRect(x: 0, y: Password.frame.size.height - width, width:  Password.frame.size.width, height: Password.frame.size.height)
        
        border2.borderWidth = width
        Password.layer.addSublayer(border2)
        Password.layer.masksToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        view.backgroundColor = UIColor(hex: "EFEFF4")
        ref = Database.database().reference()
        
        view.addSubview(Instructions)
        setupInstructions()
        view.addSubview(Username)
        setupUsername()
        view.addSubview(Password)
        setupPassword()
        view.addSubview(EmailLabel)
        setupEmailLabel()
        view.addSubview(PasswordLabel)
        setupPasswordLabel()
        view.addSubview(LoginButton)
        setupLoginButton()
        
        hideKeyboardWhenTappedAround()
        

    }

}

//extension to be able to tap outside of uitextview to dismiss keyboard
extension LoginVC {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}



