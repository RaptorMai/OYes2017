//
//  SettingsVC.swift
//  TutorApp
//
//  Created by devuser on 2017-08-13.
//  Copyright © 2017 sul. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {

    @IBAction func LogOut(_ sender: Any) {
        try! Auth.auth().signOut()
        let LoginScreenNC = UINavigationController(rootViewController: ViewController())
        LoginScreenNC.navigationBar.barStyle = .blackTranslucent
        present(LoginScreenNC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
