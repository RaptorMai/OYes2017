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

class NameViewController: UIViewController, UITextFieldDelegate {
    // Database
    var ref: DatabaseReference! = Database.database().reference()
    var uid = "+1" + EMClient.shared().currentUsername!

    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameChangTextView.text = UserDefaults.standard.string(forKey: "userName")
        nameChangTextView.becomeFirstResponder()
        nameChangTextView.clearButtonMode = .always
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
    }
    
    // MARK: - Outlets
    @IBOutlet weak var nameChangTextView: UITextField!

    // MARK: - Actions
    @IBAction func SaveText(_ sender: UIButton) {
        if textCount(nameChangTextView){
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
        } else {
            createNameFormatAlert()
        }
    }
    
    func uploadName(_ Name: String){
        self.ref?.child("users/\(self.uid)").updateChildValues(["username":Name])
    }
    
    // Dismiss Keyboard
    func handleTap(_ tapGesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // Limit text in text view
    func textCount(_ textView: UITextField) -> Bool {
        let numberOfChars = textView.text?.characters.count
        return numberOfChars! < 16
    }
    
    func createNameFormatAlert (){
        let alert = UIAlertController(title: "Format Error", message: "Limit your username in 15 characters", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title:"Try Again", style: UIAlertActionStyle.default, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: textfielddelegate
    // handle return press on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        SaveText(saveButton as! UIButton)
        return true
    }
}



