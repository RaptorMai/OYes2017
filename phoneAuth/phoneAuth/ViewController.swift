//
//  ViewController.swift
//  phoneAuth
//
//  Created by devuser on 2017-07-06.
//  Copyright © 2017 devuser. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    
    
    @IBOutlet weak var phoneNum: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func sendCode(_ sender: UIButton) {
        let alert = UIAlertController(title: "Phone number", message: "Is this your phone number? \n \(phoneNum.text!)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
            PhoneAuthProvider.provider().verifyPhoneNumber(self.phoneNum.text!) { (verificationID, error) in
                if error != nil {
                    print (" error: \(String(describing: error?.localizedDescription))")
                } else {
                    let defaults = UserDefaults.standard
                    defaults.set(verificationID, forKey: "authVID")
                    self.performSegue(withIdentifier: "code", sender: Any?.self)
                }
            }
        }
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

