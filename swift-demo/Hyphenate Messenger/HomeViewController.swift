//
//  HomeViewController.swift
//  registration
//
//  Created by devuser on 2017-07-07.
//  Copyright © 2017 devuser. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let titleFrame = CGRect(x: 0, y: 0, width: 32, height: 32)
        let title:UILabel = UILabel(frame: titleFrame)
        title.text = "Home"
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
