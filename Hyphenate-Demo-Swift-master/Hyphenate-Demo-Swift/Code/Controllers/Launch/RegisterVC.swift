//
//  RegisterVC.swift
//  TutorApp
//
//  Created by devuser on 2017-08-03.
//  Copyright © 2017 sul. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth  = UIScreen.main.bounds.width
    
    let LabelOne: UILabel = {
        let label = UILabel()
        label.text = "Thanks for your interest in InstaSolve tutor!"
        label.textColor = UIColor.black
        label.font = UIFont(name: "Helvetica", size: 25)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    func setupLabelOne(){
        LabelOne.translatesAutoresizingMaskIntoConstraints = false
        LabelOne.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        LabelOne.topAnchor.constraint(equalTo: view.topAnchor, constant:125).isActive = true
        LabelOne.widthAnchor.constraint(equalToConstant: screenWidth*0.8).isActive = true
    }

    let LabelTwo: UILabel = {
        let label = UILabel()
        label.text = "We are excited that you can join our InstaSolve family and share knowledge on one of the fastest-growing education platform in Canada"
        label.textColor = UIColor.black
        label.font = UIFont(name: "Helvetica", size: 20)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    func setupLabelTwo(){
        LabelTwo.translatesAutoresizingMaskIntoConstraints = false
        LabelTwo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        LabelTwo.topAnchor.constraint(equalTo: LabelOne.bottomAnchor, constant:75).isActive = true
        LabelTwo.widthAnchor.constraint(equalToConstant: screenWidth*0.8).isActive = true
    }
    
    let LabelThree: UILabel = {
        let label = UILabel()
        var attributedString = NSMutableAttributedString(string: "InstaSolve tutor application is fast and simple. Open www.instasolve.ca/tutors on a desktop computer and start application process. Once finished, come back, sign in and Earn money!", attributes: nil)
        //"InstaSolve tutor application is fast and simple. Open www.instasolve.ca/tutors on a desktop computer and start application process. Once finished, come back, sign in and Earn money!"
        let linkRange: NSRange = NSMakeRange(54, 24)
        let linkAttributes: NSDictionary = ["NSForegroundColorAttributeName" : [UIColor.init(red: 0.05, green: 0.4, blue: 0.65, alpha: 1.0)], "NSUnderlineStyleAttributeName" : NSUnderlineStyle.styleSingle]
        attributedString.addAttributes(linkAttributes as! [String : Any], range: linkRange)
        label.attributedText = attributedString
        
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"String with a link" attributes:nil];
//        NSRange linkRange = NSMakeRange(14, 4); // for the word "link" in the string above
//
//        NSDictionary *linkAttributes = @{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.05 green:0.4 blue:0.65 alpha:1.0],
//            NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) };
//        [attributedString setAttributes:linkAttributes range:linkRange];
//        
//        // Assign attributedText to UILabel
//        label.attributedText = attributedString;
        
        
        label.font = UIFont(name: "Helvetica", size: 20)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    func setupLabelThree(){
        LabelThree.translatesAutoresizingMaskIntoConstraints = false
        LabelThree.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        LabelThree.topAnchor.constraint(equalTo: LabelTwo.bottomAnchor, constant:75).isActive = true
        LabelThree.widthAnchor.constraint(equalToConstant: screenWidth*0.8).isActive = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Registration"
        view.backgroundColor = UIColor(hex: "EFEFF4")
        
        view.addSubview(LabelOne)
        setupLabelOne()
        view.addSubview(LabelTwo)
        setupLabelTwo()
        view.addSubview(LabelThree)
        setupLabelThree()

    }

}
