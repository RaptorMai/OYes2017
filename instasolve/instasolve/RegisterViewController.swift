//
//  RegisterViewController.swift
//  registration
//
//  Created by devuser on 2017-07-07.
//  Copyright © 2017 devuser. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var PhoneNum: UITextField!
    
    @IBAction func RequestCode(_ sender: UIButton) {
        //check for valid number in PhoneNum
        let PhoneNumValid = true
        
        if PhoneNumValid {
            let alert = UIAlertController(title: "Phone number", message: "Is this your phone number? \n \(PhoneNum.text!)", preferredStyle: .alert)
            let action = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
                PhoneAuthProvider.provider().verifyPhoneNumber("+1\(self.PhoneNum.text!)") { (verificationID, error) in
                    if error != nil {
                        print (" error: \(String(describing: error?.localizedDescription))")
                    } else {
                        let defaults = UserDefaults.standard
                        defaults.set(verificationID, forKey: "authVID")
                        self.performSegue(withIdentifier: "RegisterPhoneNumToCode", sender: sender)
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
    
    @IBOutlet weak var Code: UITextField!
    
    @IBAction func Register(_ sender: UIButton) {
        
        //NEED TO INSERT CODE TO ADD USER TO DATABASE
        
        let defaults = UserDefaults.standard
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVID")!, verificationCode: Code.text!)
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("error: \(String(describing: error?.localizedDescription))")
            } else{
                print("Phone number: \(String(describing: user?.phoneNumber))")
                let userInfo = user?.providerData[0]
                print("Provider ID: \(String(describing: userInfo?.providerID))")
                self.performSegue(withIdentifier: "RegisterToHome", sender: Any?.self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
