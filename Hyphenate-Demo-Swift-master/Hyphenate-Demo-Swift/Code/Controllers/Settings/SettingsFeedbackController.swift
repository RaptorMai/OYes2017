//
//  SettingsFeedbackController.swift
//  Hyphenate-Demo-Swift
//
//  Created by Caryn Cheung on 2017-09-20.
//  Copyright © 2017 杜洁鹏. All rights reserved.
//

import Foundation
import MessageUI
import UIKit

class SendFeedbackController: UIViewController, MFMailComposeViewControllerDelegate{
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        if !MFMailComposeViewController.canSendMail(){
            print("Mail services are not available")
            self.showSendMailErrorAlert()
            return
        } else {
            sendFeedback()
        }
    }
    
    
    // MARK - Functions
    
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
    
    // dimiss controller
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
        controller.dismiss(animated: true, completion: nil)
        let settingVC = SettingsVC()
        navigationController?.pushViewController(settingVC, animated: false)
    }
}
