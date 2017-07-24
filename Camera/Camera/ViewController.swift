//
//  ViewController.swift
//  Camera
//
//  Created by ZHEDA MAI on 2017-07-16.
//  Copyright © 2017 ZHEDA MAI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var croppingEnabled: Bool = false
    var libraryEnabled: Bool = true
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Snap(_ sender: UIButton) {
        let cameraViewController = CameraViewController(croppingEnabled: croppingEnabled, allowsLibraryAccess: libraryEnabled) { [weak self] image, asset in
            
            self?.dismiss(animated: true, completion: nil)
        }
        
        present(cameraViewController, animated: true, completion: nil)
    }
    
}

