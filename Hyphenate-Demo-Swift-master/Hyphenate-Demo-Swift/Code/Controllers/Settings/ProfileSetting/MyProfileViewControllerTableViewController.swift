//
//  MyProfileViewControllerTableViewController.swift
//  ProfileSetting
//
//  Created by Yi Jerry on 2017-09-23.
//  Copyright © 2017 Yi Jerry. All rights reserved.
//

import UIKit
import MessageUI
import Firebase
import FirebaseDatabase
import Hyphenate
import FirebaseAuth


class MyProfileViewControllerTableViewController: UITableViewController, MFMailComposeViewControllerDelegate{
    
    // MARK: - Properties
    var ref = Database.database().reference()
    var uid = "+1" + EMClient.shared().currentUsername!
    
    
    // MARK: SETUP UserDefaults
    let defaultProfilePic = UIImage(named: "profile")
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table navigation bar
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // color of the back button
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        // Section: PROFILE
        case 0:
            return 2
        // Section: PRIVACY
        case 1:
            return 1
        // Section: INFORMATION
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Section: PROFILE
        if indexPath.section == 0{
            switch indexPath.row {
            // Profile Picture
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "profilePictureCell", for: indexPath) as! profilePictureTableViewCell
                if let data = UserDefaults.standard.data(forKey: "profilePicture") {
                    let imageUIImage: UIImage = UIImage(data: data)!
                    cell.profileImageView.image = imageUIImage
                } else {
                    cell.profileImageView.image = UIImage(named: "placeholder")
                }
                cell.profilePhotoLabel.text = "Profile Photo"
                return cell
            // Name
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath) as! nameTableViewCell
                cell.nameCellLabel.text = "Name"
                cell.userNameLabel.text = UserDefaults.standard.string(forKey: "userName")
                return cell
            // Should Never Reach
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
                return cell
            }
            
        // Section: PRIVACY
        } else if indexPath.section == 1{
            switch indexPath.row {
            // Password
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "passwordCell", for: indexPath) as! passwordTableViewCell
                cell.passwordCellLabel.text = "Reset Password"
                return cell
            // Should Never Reach
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
                return cell
            
            }
            
        }
            // Section: INFORMATION
        else {
            switch indexPath.row {                
            // Email
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "emailCell", for: indexPath) as! emailTableViewCell
                cell.emailCellLabel.text = "Email"
                cell.userEmailLabel.text = UserDefaults.standard.string(forKey: "email")
                return cell
            // Should Never Reach
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
                return cell
            }
        }
            
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileHeaderCell") as! profileHeaderTableViewCell
        switch section {
        case 0:
            cell.headerLabel.text = "PROFILE"
        case 1:
            cell.headerLabel.text = "PRIVACY"
        case 2:
            cell.headerLabel.text = "INFORMATION"
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // change Height of Profile Picture Cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0 && indexPath.row == 0){
            return 90
            
        }
        return 40
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2{
            if indexPath.row == 0{
                print("clicked email")
                tableView.deselectRow(at: indexPath, animated: true)
                createChangeEmailAlert()
            }
        } else if indexPath.section == 1{
            if indexPath.row == 0 {
                print("cliced password")
                tableView.deselectRow(at: indexPath, animated: true)
                createPasswordChangeAlert()
            }
        }
    }
    
    func createChangeEmailAlert (){
        let alert = UIAlertController(title: "Alert", message: "Please notify us via Email", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title:"Cancel", style: UIAlertActionStyle.default, handler:nil))
        alert.addAction(UIAlertAction(title:"Notify Us", style: UIAlertActionStyle.default, handler:{(action:UIAlertAction) in
            if !MFMailComposeViewController.canSendMail(){
                print("Mail services are not available")
                self.showSendMailErrorAlert()
                return
            } else {
                self.sendFeedback()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // send Feedback
    func sendFeedback(){
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface
        composeVC.setToRecipients(["instasolve1@gmail.com"])
        composeVC.setSubject("Email Change Request - InstaSolve")
        composeVC.setMessageBody("Please leave indicate your previous and new Email!", isHTML: false)
        self.present(composeVC, animated: true, completion:nil)
    }
    
    // Mail: error handler
    func showSendMailErrorAlert(){
        let sendMailErrorAlert = UIAlertController(title: "Mail cannot be sent", message: "Mailbox is not setup properly", preferredStyle: .alert )
        sendMailErrorAlert.addAction(UIAlertAction(title: "Yes", style: .default) {_ in})
        self.present(sendMailErrorAlert, animated: true)
    }
    
    // Mail: dimiss controller
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case MFMailComposeResult.cancelled:
            print("Mail cancelled")
        case MFMailComposeResult.saved:
            print("Mail saved")
        case MFMailComposeResult.sent:
            print("Mail sent")
        case MFMailComposeResult.failed:
            print("Mail sent failure")
        default:
            break
        }
        // Dismiss mail view controller and back to setting page
        self.dismiss(animated:true, completion: nil)
    }
    
    // PW change alert
    func createPasswordChangeAlert (){
        let email = UserDefaults.standard.string(forKey: "userEmail")
        let alert = UIAlertController(title: "Alert", message: "Do you want to reset your password? An email will be sent to you", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title:"Change Password", style: UIAlertActionStyle.default, handler:{(action:UIAlertAction) in
            self.resetPW(email!)
        }))
        alert.addAction(UIAlertAction(title:"Cancel", style: UIAlertActionStyle.default, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // reset user password
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
    
    // MARK: - NOTES
    /*
     - to make headers non sticky: go to main storyboard and chage tableview style to: group
     
     */
    
}
