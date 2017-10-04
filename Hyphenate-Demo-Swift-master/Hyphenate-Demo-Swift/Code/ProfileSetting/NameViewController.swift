//
//  NameViewController.swift
//  ProfileSetting
//
//  Created by Yi Jerry on 2017-09-23.
//  Copyright © 2017 Yi Jerry. All rights reserved.
//

import UIKit

class NameViewController: UIViewController {
    
    // MARK: - View Did Load

    override func viewDidLoad() {
        super.viewDidLoad()
        nameChangTextView.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameChangTextView: UITextView!
    


    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
