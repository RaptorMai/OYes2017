//
//  SignInVC.swift
//  Chat App For iOS 10
//
//  Created by MacBook on 11/22/16.
//  Copyright © 2016 Awesome Tuts. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    
    private let CONTACTS_SEGUE = "ContactsSegue";

    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func viewDidAppear(_ animated: Bool) {
        if AuthProvider.Instance.isLoggedIn() {
            performSegue(withIdentifier: self.CONTACTS_SEGUE, sender: nil);
        }
    }
    
    @IBAction func login(_ sender: Any) {
        
        if emailTextfield.text != "" && passwordTextfield.text != "" {
            
            AuthProvider.Instance.login(withEmail: emailTextfield.text!, password: passwordTextfield.text!, loginHandler: { (message) in
                
                if message != nil {
                    self.alertTheUser(title: "Problem With Authentication", message: message!);
                } else {
                    
                    self.emailTextfield.text = "";
                    self.passwordTextfield.text = "";
                    
                    self.performSegue(withIdentifier: self.CONTACTS_SEGUE, sender: nil);
                    
                }
                
            })
            
        } else {
            alertTheUser(title: "Email And Password Are Required", message: "Please enter email and password in the text fields");
        }
        
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        if emailTextfield.text != "" && passwordTextfield.text != "" {
            
            AuthProvider.Instance.signUp(withEmail: emailTextfield.text!, password: passwordTextfield.text!, loginHandler: { (message) in
                
                if message != nil {
                self.alertTheUser(title: "Problem With Creating A New User", message: message!);
                } else {
                    
                    self.emailTextfield.text = "";
                    self.passwordTextfield.text = "";
                    
                    self.performSegue(withIdentifier: self.CONTACTS_SEGUE, sender: nil);
                }
                
            })
            
        } else {
            alertTheUser(title: "Email And Password Are Required", message: "Please enter email and password in the text fields");
        }
        
    }
    
    private func alertTheUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
    

} // class












































