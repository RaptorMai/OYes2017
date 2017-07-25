//
//  SummaryVC.swift
//  MenuChoice
//
//  Created by devuser on 2017-07-14.
//  Copyright © 2017 juanmao. All rights reserved.
//

import UIKit

class SummaryVC: UIViewController {

    var categorytitle: String = ""
    
    let categoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setTitle("Category", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect.init(x: 100, y: 100, width: 200, height: 200)
        label.textAlignment = .center
        label.backgroundColor = UIColor.black
        label.textColor = UIColor.white
        label.textAlignment = .left
        return label
    }()
    
    let loginRegisterButton: UIButton = {
//        let button = UIButton(type: .system)
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.black
        button.setTitle("Register", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray
        
        view.addSubview(categoryLabel)
        setupCategoryLabel()
        
        view.addSubview(categoryButton)
        setupCategoryButton()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func setupCategoryLabel() {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        categoryLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        categoryLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        categoryLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        categoryLabel.text = categorytitle

    }
    
    func setupCategoryButton() {
        categoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        categoryButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        categoryButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        categoryButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupLoginRegisterButton() {
        //need x, y, width, height constraints
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: categoryLabel.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
//    let codedLabel:UILabel = UILabel()
//    codedLabel.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
//    codedLabel.textAlignment = .center
//    codedLabel.text = alertText
//    codedLabel.numberOfLines=1
//    codedLabel.textColor=UIColor.red
//    codedLabel.font=UIFont.systemFont(ofSize: 22)
//    codedLabel.backgroundColor=UIColor.lightGray
//    
//    self.contentView.addSubview(codedLabel)
//    codedLabel.translatesAutoresizingMaskIntoConstraints = false
//    codedLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
//    codedLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
//    codedLabel.centerXAnchor.constraint(equalTo: codedLabel.superview!.centerXAnchor).isActive = true
//    codedLabel.centerYAnchor.constraint(equalTo: codedLabel.superview!.centerYAnchor).isActive = true
    

}
