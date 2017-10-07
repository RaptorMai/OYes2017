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
    

    // MARK: - Pull to Refresh ======================

    // properties:
    let pullToRefreshControl = UIRefreshControl()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueName = segue.identifier
        if segueName == "magic"{
            let childVC = segue.destination as? MainTableViewController
            childVC?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rating = 4.9
        starView.rating = rating
        starView.text = "\(rating)"
    }
    
    func removeSpinner(){
    
        MBProgressHUD.hideAllHUDs(for: tableofquestions, animated: true)
    
    }
    
}
