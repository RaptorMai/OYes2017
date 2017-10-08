//
//  ResetPWViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by ZHEDA MAI on 2017-10-08.
//  Copyright © 2017 杜洁鹏. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResetPWViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //get email from user default and call this function 
    func resetPW(_ email: String){
        
        self.show("")
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            self.hideHub()
            if error != nil{
                let alert = UIAlertController(title: "Error", message: "\((error?.localizedDescription)!)", preferredStyle: .alert)
                let okay = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okay)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "Email Sent", message: "Please check Email and reset password", preferredStyle: .alert)
                let okay = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okay)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
