//
//  HomeViewController.swift
//  TutorApp
//
//  Created by devuser on 2017-08-06.
//  Copyright © 2017 sul. All rights reserved.
//

import UIKit
import Foundation

class QuestionsVC: UIViewController {

    @IBAction func refresh(_ sender: UIBarButtonItem) {
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil)
    }
    
    
    @IBOutlet weak var tableofquestions: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

}
