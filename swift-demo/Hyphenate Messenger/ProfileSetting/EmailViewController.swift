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
import MBProgressHUD


class EmailViewController: UIViewController {
    // Database
    var ref: DatabaseReference! = Database.database().reference()
    var uid = "+1" + EMClient.shared().currentUsername!

    override func viewDidLoad() {
        super.viewDidLoad()
        // get email from DB
        self.EmailText.text = UserDefaults.standard.string(forKey: "email")
        EmailText.becomeFirstResponder()
        EmailText.clearButtonMode = .always
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var EmailText: UITextField!
    
    @IBAction func Save(_ sender: UIBarButtonItem) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        //Upload Email to DB
        let email = EmailText.text
        if verifyEmail(email: email!){
        uploadEmail(email!)
        
        // Retrive Email from firebase
        // Store data to UserDefaults
        self.ref.child("users").child(uid).child("email").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                let val = snapshot.value as? String
                if (val! != ""){
                    UserDefaults.standard.set(val, forKey: "email")
                }
                else{
                    print("Username is an empty string!")
                    UserDefaults.standard.set("Unknown", forKey: "email")
                }
            }
            MBProgressHUD.hide(for: self.view, animated: true)
            self.navigationController?.popViewController(animated: true)
        }) { (error) in print(error.localizedDescription)}
        }else{
            let alert = UIAlertController(title: "Alert", message: "Incorrect Email Format", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func uploadEmail(_ email: String){
        self.ref?.child("users/\(self.uid)").updateChildValues(["email":email])
    }
    
    // Verify Email format
    func verifyEmail(email: String) -> Bool{
        if email == "" {
            return true
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,15}"
        let emailverify = NSPredicate(format:"SELF MATCHES %@",emailRegEx)
        let res = emailverify.evaluate(with: email)
        return res
    }
    
    // Dismiss Keyboard
    func handleTap(_ tapGesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}






