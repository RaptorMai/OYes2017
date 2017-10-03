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
        // profile picture
        // TODO: delete this hard coded userdefaults
        let imageBuffer = #imageLiteral(resourceName: "photo")
        let imgData = UIImageJPEGRepresentation(imageBuffer, 1)
        UserDefaults.standard.set(imgData, forKey: "profilePicture")
        if let data = UserDefaults.standard.data(forKey: "profilePicture"){
            self.tutorProfilePicture.image = UIImage(data: data)!
        }else{
            // TODO: MAKE SURE PLACEHOLDER IS THERE
            self.tutorProfilePicture.image = UIImage(named:"placeholder")!
        }
        // tutor name
        // TODO: delete this hard coding userdefaults
        UserDefaults.standard.set("Mike", forKey: "userName")
        if let name = UserDefaults.standard.string(forKey: "userName"){
            self.tutorName.text = name
        } else {
            self.tutorName.text = "Unknown"
        }
        // rating
        // TODO: delete this hard coded userdefaults
        UserDefaults.standard.set("10", forKey: "star")
        UserDefaults.standard.set("3", forKey: "qnum")
        var rating: Double = 0.0
        if let qnum = Double(UserDefaults.standard.string(forKey: "qnum")!), let star = Double(UserDefaults.standard.string(forKey: "star")!){
            rating = round((star/qnum)*100)/100
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
