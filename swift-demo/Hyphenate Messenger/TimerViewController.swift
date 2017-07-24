//
//  timerViewController.swift
//  Hyphenate Messenger
//
//  Created by Ming Yue on 2017-07-19.
//  Copyright © 2017 InstaSolve Inc. All rights reserved.
//


class TimerViewController: UIViewController{
    var counter = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    func updateCounter() {
        //you code, this is an example
        counter += 1
    }
}
