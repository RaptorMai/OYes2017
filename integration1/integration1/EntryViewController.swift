//
//  EntryViewController.swift
//  registration
//
//  Created by devuser on 2017-07-07.
//  Copyright © 2017 devuser. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {
    

    @IBAction func Login(_ sender: UIButton) {
        performSegue(withIdentifier: "EntryLoginToPhoneNum", sender: sender)
    }

    @IBAction func Register(_ sender: UIButton) {
         performSegue(withIdentifier: "EntryRegisterToPhoneNum", sender: sender)
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
