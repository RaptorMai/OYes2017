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


class QuestionsVC: UIViewController, refreshSpinnerProtocol{
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueName = segue.identifier
        if segueName == "magic"{
            let childVC = segue.destination as? MainTableViewController
            childVC?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tutorProfilePicture.clipsToBounds = true
        self.tutorProfilePicture.layer.cornerRadius = 20
        
    }
    override func viewWillAppear(_ animated: Bool) {
        // profile picture
        if let data = UserDefaults.standard.data(forKey: "profilePicture"){
            self.tutorProfilePicture.image = UIImage(data: data)!
        }else{
            self.tutorProfilePicture.image = UIImage(named:"placeholder")!
        }
        // tutor name
        if let name = UserDefaults.standard.string(forKey: "userName"){
            self.tutorName.text = name
        } else {
            self.tutorName.text = "Unknown"
        }
        // rating
        var rating: Double = 0.0
        if let qnum = UserDefaults.standard.string(forKey: "qnum"), let star = UserDefaults.standard.string(forKey: "star"){
            if let d_qnum = Double(qnum), let d_star = Double(star){
                if d_qnum == 0.0 {
                    rating = 5.0
                }
                rating = round((d_star/d_qnum)*100)/100
            }
        }else{
           rating=0.0
        }
        starView.rating = rating
        starView.text = "\(rating)"
    }
    
    func removeSpinner(){
    
        MBProgressHUD.hideAllHUDs(for: tableofquestions, animated: true)
    
    }
    
}
