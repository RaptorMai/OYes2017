//
//  EmailViewController.swift
//  ProfileSetting
//
//  Created by Yi Jerry on 2017-09-23.
//  Copyright © 2017 Yi Jerry. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class EmailViewController: UIViewController {
    // Database
    var ref: DatabaseReference! = Database.database().reference()
    var uid = "+1" + EMClient.shared().currentUsername!

    override func viewDidLoad() {
        super.viewDidLoad()
        // get email from DB
        self.ref?.child("users").child(uid).child("email").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                let val = snapshot.value as? String
                if (val! != ""){
                    self.EmailText.text = val!
                }
            }
        }) { (error) in print(error.localizedDescription)}
        EmailText.becomeFirstResponder()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var EmailText: UITextField!
    
    @IBAction func Save(_ sender: UIBarButtonItem) {
        let email = EmailText.text
        uploadEmail(email!)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func uploadEmail(_ email: String){
        self.ref?.child("users/\(self.uid)").updateChildValues(["email":email])
    }
    
    // Dismiss Keyboard
    func handleTap(_ tapGesture: UITapGestureRecognizer) {
        view.endEditing(true)
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






