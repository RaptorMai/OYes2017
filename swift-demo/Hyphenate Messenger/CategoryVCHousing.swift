//
//  CategoryVCHousing.swift
//  Hyphenate Messenger
//
//  Created by devuser on 2017-07-25.
//  Copyright © 2017 Hyphenate Inc. All rights reserved.
//

import UIKit

class CategoryVCHousing: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack))
//        self.navigationItem.leftBarButtonItem = backButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goBack(){
        dismiss(animated: true, completion: nil)
    }


}
