//
//  HomeViewController.swift
//  TutorApp
//
//  Created by devuser on 2017-08-06.
//  Copyright © 2017 sul. All rights reserved.
//

import UIKit
import Foundation
import MBProgressHUD
import Cosmos


protocol refreshSpinnerProtocol {
    func removeSpinner()
}


class QuestionsVC: UIViewController, refreshSpinnerProtocol, ConfigDelegate {
    // function:
    func refreshTable(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
        MBProgressHUD.showAdded(to: tableofquestions, animated: true)
    }
    

    @IBAction func refresh(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
        MBProgressHUD.showAdded(to: tableofquestions, animated: true)
    }
    
    @IBOutlet weak var starView: CosmosView!  // settings in the IB
    
    @IBOutlet weak var tableofquestions: UIView!
    
    @IBOutlet weak var tutorName: UILabel!
    
    @IBOutlet weak var tutorProfilePicture: UIImageView!
    
    @IBOutlet weak var earningLabel: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueName = segue.identifier
        if segueName == "magic"{
            let childVC = segue.destination as? MainTableViewController
            childVC?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // profile loading delegate
        AppConfig.sharedInstance.profileDelegate = self
    }
    
    override func viewDidLayoutSubviews() {
        refreshInformationBanner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshInformationBanner()
    }
    
    
    /// Refreshes the banner that displays the tutor info
    func refreshInformationBanner() {
        if let data = UserDefaults.standard.data(forKey: DataBaseKeys.profilePhotoKey) {
            tutorProfilePicture.image = UIImage(data: data)!
        } else {
            // TODO: MAKE SURE PLACEHOLDER IS THERE
            tutorProfilePicture.image = UIImage(named:"placeholder")!
        }
        tutorProfilePicture.layer.masksToBounds = true
        tutorProfilePicture.layer.cornerRadius = tutorProfilePicture.frame.size.width / 2
        
        if let name = UserDefaults.standard.string(forKey: DataBaseKeys.profileUserNameKey){
            tutorName.text = name
        } else {
            tutorName.text = "Unknown"
        }
        // rating
        // TODO: delete this hard coded userdefaults
        let rating: Double = AppConfig.sharedInstance.starRating
        
        starView.rating = rating
        starView.text = String(format: "%.1f", ceil(rating*100)/100)  // round up
        
        earningLabel.text = String(format: "$ %.2f", UserDefaults.standard.double(forKey: DataBaseKeys.profileEarningThisMonthKey))
    }
    
    func removeSpinner(){
    
        MBProgressHUD.hideAllHUDs(for: tableofquestions, animated: true)
    
    }
    
    // Mark: - Config delegate
    func didFetchConfigTypeProfile() {
        refreshInformationBanner()
    }
    
}
