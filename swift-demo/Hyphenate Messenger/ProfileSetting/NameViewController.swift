//
//  NameViewController.swift
//  ProfileSetting
//
//  Created by Yi Jerry on 2017-09-23.
//  Copyright © 2017 Yi Jerry. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MBProgressHUD

class NameViewController: UIViewController {
    // Database
    var ref: DatabaseReference! = Database.database().reference()
    var uid = "+1" + EMClient.shared().currentUsername!

    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameChangTextView.text = UserDefaults.standard.string(forKey: "userName")
        nameChangTextView.becomeFirstResponder()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
    }
    
    // MARK: - Outlets
    @IBOutlet weak var nameChangTextView: UITextField!

    // MARK: - Actions
    @IBAction func SaveText(_ sender: UIButton) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        //Upload Name to DB
        let Name = nameChangTextView.text
        uploadName(Name!)
        
        // Retrive Name from firebase
        // Store data to UserDefaults
        self.ref.child("users").child(uid).child("username").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                let val = snapshot.value as? String
                if (val! != ""){
                    UserDefaults.standard.set(val, forKey: "userName")
                }
                else{
                    UserDefaults.standard.set("Unknown", forKey: "userName")
                }
            }
             MBProgressHUD.hide(for: self.view, animated: true)
            self.navigationController?.popViewController(animated: true)
        }) { (error) in print(error.localizedDescription)}
    }
    
    func uploadName(_ Name: String){
        self.ref?.child("users/\(self.uid)").updateChildValues(["username":Name])
    }
    
    // Dismiss Keyboard
    func handleTap(_ tapGesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}



