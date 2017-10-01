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

class NameViewController: UIViewController {
    // Database
    var ref: DatabaseReference! = Database.database().reference()
    var uid = "+1" + EMClient.shared().currentUsername!

    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // get username from DB
        self.ref?.child("users").child(uid).child("username").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                let val = snapshot.value as? String
                if (val! != ""){
                    self.nameChangTextView.text = val!
                }
                else{
                    print("Username is an empty string!")
                    self.nameChangTextView.text = "Unknown"
                }
            }
        }) { (error) in print(error.localizedDescription)}
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameChangTextView: UITextView!

    // MARK: - Actions
    @IBAction func SaveText(_ sender: UIButton) {
        let Name = nameChangTextView.text
        uploadName(Name!)
        self.navigationController?.popViewController(animated: true)
    }
    
    func uploadName(_ Name: String){
        self.ref?.child("users/\(self.uid)").updateChildValues(["username":Name])
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

extension NameViewController{
    //Allows the keyboard to be hidden when tapped outside of keyboard
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NameViewController.dismissKeyboard))
        
        let swipeOutOfKeyboard: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(NameViewController.dismissKeyboard))
        swipeOutOfKeyboard.direction = .down
        
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(swipeOutOfKeyboard)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
