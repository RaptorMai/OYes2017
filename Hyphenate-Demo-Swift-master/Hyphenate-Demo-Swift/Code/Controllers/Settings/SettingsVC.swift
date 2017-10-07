//
//  SettingsVC.swift
//  TutorApp
//
//  Created by devuser on 2017-08-13.
//  Copyright © 2017 sul. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD
import MessageUI

class SettingsVC: UITableViewController, MFMailComposeViewControllerDelegate{
/*
    @IBAction func LogOut(_ sender: Any) {
        try! Auth.auth().signOut()
        let LoginScreenNC = UINavigationController(rootViewController: LaunchViewController())
        LoginScreenNC.navigationBar.barStyle = .blackTranslucent
        present(LoginScreenNC, animated: true, completion: nil)
    }
    
*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        self.tableView.backgroundColor = UIColor.init(hex: "F0EFF5")
        self.tableView.separatorInset = .zero
        self.tableView.layoutMargins = .zero
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(UINib(nibName: "SwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "switchCell")
        self.tableView.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "labelCell")
        
        self.tabBarController?.tabBar.isHidden = false
        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "SettingProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "settingProfileCell")
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Settings"
        self.tabBarController?.tabBar.isHidden = false
        self.tableView.reloadData()
    }
    
    let data = [[[#imageLiteral(resourceName: "Profile"),"Profile"]], [[#imageLiteral(resourceName: "Bank"),"Bank account"], [#imageLiteral(resourceName: "Cash"),"Cash out"]], [[#imageLiteral(resourceName: "Help"),"Help"], [#imageLiteral(resourceName: "Feedback"),"Feedback"], [#imageLiteral(resourceName: "About"),"About"]],[["Log out"]]]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // My Profile TODO: don't use conversation table view cell, better make a new one
            let cell:SettingProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "settingProfileCell", for: indexPath) as! SettingProfileTableViewCell
            cell.senderLabel.text = ""
            cell.timeLabel.isHidden = true
            cell.lastMessageLabel.isHidden = true
            cell.senderImageView.contentMode = UIViewContentMode.scaleAspectFill
            
            // username
            cell.senderLabel.text = UserDefaults.standard.string(forKey: "userName")
            // profile picture
            let imageUIImage: UIImage
            if let data = UserDefaults.standard.data(forKey: "profilePicture"){
                imageUIImage = UIImage(data: data)!
            }else{
                imageUIImage = UIImage(named:"placeholder")!
            }
            cell.senderImageView.image = imageUIImage
            
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
        else if indexPath.section < 3 {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = self.data[indexPath.section][indexPath.row][1] as? String
            cell.imageView?.image = self.data[indexPath.section][indexPath.row][0] as? UIImage
            
            cell.accessoryType = .disclosureIndicator
            return cell}
            
        else{
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = self.data[indexPath.section][indexPath.row][0] as? String
            cell.textLabel?.textAlignment = .center
            
            return cell
        }

    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0{
                let StoryBoard = UIStoryboard(name:"ProfileSetting",bundle:nil)
                let myProfileVC = StoryBoard.instantiateViewController(withIdentifier: "myProfileVC")
                navigationController?.pushViewController(myProfileVC, animated: true)
                self.tabBarController?.tabBar.isHidden = true
                myProfileVC.navigationController?.navigationBar.tintColor = UIColor.white
            }
        //case 1: bank account and cash out
        case 2:
            switch indexPath.row{
            case 0:
                let openWebPageVC = OpenUrlViewController()
                openWebPageVC.url = "https://www.instasolve.ca/"
                navigationController?.pushViewController(openWebPageVC, animated: true)
                self.tabBarController?.tabBar.isHidden = true
                self.navigationController?.navigationBar.tintColor = UIColor.white
            case 1:
                if !MFMailComposeViewController.canSendMail(){
                    print("Mail services are not available")
                    self.showSendMailErrorAlert()
                    return
                } else {
                    sendFeedback()
                    
                }
                tableView.deselectRow(at: indexPath, animated: true)
            default:break
            }
        case 3:
            //An alert window will appear if the user click the log out button.
            let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Logout", style: .default) { (action) in self.logoutAction()}
            alertController.addAction(okAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
            alertController.addAction(cancelAction)
            tabBarController!.present(alertController, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
            
        default:break
            
        }
    }
    
    // change Height of Profile Picture Cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0 && indexPath.row == 0){
            return 100
        } else {
            return UITableViewAutomaticDimension
        }
    }

    func logoutAction() {
        
        try! Auth.auth().signOut()
        let LoginScreenNC = UINavigationController(rootViewController: LaunchViewController())
        LoginScreenNC.navigationBar.barStyle = .blackTranslucent
        present(LoginScreenNC, animated: true, completion: nil)
        
        //TODO add hyphenate logout
        /*EMClient.shared().logout(false) { (error) in
            if let _ = error {
                let alert = UIAlertController(title:"Sign Out error", message: "Please try again later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .cancel, handler: nil))
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            } else {
                let loginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginScene")
                UIApplication.shared.keyWindow?.rootViewController = loginController
                
            }
        }*/
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK - Functions for email sending. (Feedback button)
    
    // send Feedback
    func sendFeedback(){
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface
        composeVC.setToRecipients(["instasolve1@gmail.com"])
        composeVC.setSubject("Feedback - InstaSolve")
        composeVC.setMessageBody("Please leave us your precious feedback!", isHTML: false)
        self.present(composeVC, animated: true, completion:nil)
        
    }
    
    // error handler
    func showSendMailErrorAlert(){
        let sendMailErrorAlert = UIAlertController(title: "Mail cannot be sent", message: "Mailbox is not setup properly", preferredStyle: .alert )
        sendMailErrorAlert.addAction(UIAlertAction(title: "Yes", style: .default) {_ in})
        self.present(sendMailErrorAlert, animated: true)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["someone@somewhere.com"])
        mailComposerVC.setSubject("Sending you an in-app e-mail...")
        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        return mailComposerVC
    }
    
    // dimiss controller
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        //Dismiss the black view controller.
        //self.presentingViewController?.dismiss(animated: false, completion: nil)
        
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


}
