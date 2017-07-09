//
//  LoginViewController.swift
//  registration
//
//  Created by devuser on 2017-07-07.
//  Copyright © 2017 devuser. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var PhoneNum: UITextField!
    
    @IBAction func RequestCode(_ sender: UIButton) {
        //check for valid number in PhoneNum
        let PhoneNumValid = true
        if PhoneNumValid {
            performSegue(withIdentifier: "LoginPhoneNumToCode", sender: sender)
        } else {
            //insert error for invalid number
        }
    }
    
    @IBOutlet weak var Code: UITextField!
    
    @IBAction func Login(_ sender: UIButton) {
        let CodeValid = true
        if CodeValid {
            performSegue(withIdentifier: "LoginToHome", sender: sender)
        } else {
            //insert error for invalid code
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
