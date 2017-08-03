//
//  SummaryVC.swift
//  Hyphenate Messenger
//
//  Created by devuser on 2017-07-25.
//  Copyright © 2017 Hyphenate Inc. All rights reserved.
//

import UIKit

class SummaryVC: UIViewController, UITextViewDelegate{
    var categorytitle: String = ""
    
    
    var questionPic: UIImageView = {
//        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight-64)
//        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height*0.25))
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight*0.23))
        image.backgroundColor = UIColor.white
        return image
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect.init(x: 100, y: 100, width: 200, height: 200)
        label.textAlignment = .left
        label.backgroundColor = UIColor.white
        label.textColor = UIColor.black
        return label
    }()
    
    let subjectLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect.init(x: 100, y: 100, width: 200, height: 200)
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        return label
    }()
    
    let questionDescription: UITextView = {
        let textview = UITextView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight*0.3))
        //        textview.placeholder = "Add Description Here..."
        textview.backgroundColor = UIColor.white
        textview.textAlignment = .left
        
        textview.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        //        let myUITextView = UITextView.init()
        //textview.text initialized in setup
        textview.textColor = .lightGray
        textview.font = UIFont.systemFont(ofSize: 16.0)
        //        textview.font = UIFont(name: "", size: 16)
        
        return textview
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.init(hex: "2EA2DC")
        button.setTitle("Request Help!", for: .normal)
        button.setTitleColor( .white , for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        view.backgroundColor = UIColor.init(red: 239, green: 239, blue: 255, alpha: 1)
        view.backgroundColor = UIColor.init(hex: "EFEFF4")
        
//        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        view.addSubview(questionPic)
        setupQuestionPic()
        view.addSubview(categoryLabel)
        setupCategoryLabel()
        view.addSubview(subjectLabel)
        setupSubjectLabel()
        view.addSubview(questionDescription)
        setupQuestionDescription()
        view.addSubview(nextButton)
        setupNextButton()
        
        hideKeyboardWhenTappedAround()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func requestHelpPressed(button: UIButton) {
        //write question to firebase
    }
    
    func setupQuestionPic() {
        questionPic.translatesAutoresizingMaskIntoConstraints = false
        questionPic.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        questionPic.heightAnchor.constraint(equalToConstant: screenHeight*0.25).isActive = true
        
        questionPic.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        questionPic.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
    }
    
    func setupCategoryLabel() {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        categoryLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: questionPic.bottomAnchor, constant: 15).isActive = true
        categoryLabel.text = "    Category:"
    }
    
    func setupSubjectLabel() {
        subjectLabel.translatesAutoresizingMaskIntoConstraints = false
        subjectLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        subjectLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        subjectLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subjectLabel.topAnchor.constraint(equalTo: questionPic.bottomAnchor, constant: 15).isActive = true
        subjectLabel.text = "                                                       \(categorytitle)"
    }
    
    
    func setupQuestionDescription() {
        questionDescription.translatesAutoresizingMaskIntoConstraints = false
        questionDescription.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        questionDescription.heightAnchor.constraint(equalToConstant: screenHeight*0.4).isActive = true
        
        questionDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        questionDescription.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10).isActive = true
        questionDescription.text = placeholdertext
        questionDescription.delegate = self
    }
    
    func setupNextButton() {
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.topAnchor.constraint(equalTo: questionDescription.bottomAnchor, constant: 10).isActive = true
        
        nextButton.addTarget(self, action: #selector(requestHelpPressed(button:)), for: .touchUpInside)
    }
    
    // code for placeholder in UItextview
    
    let placeholdertext = "Add Description Here..."
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if (textView.text == placeholdertext)
        {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder() //Optional
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text == "")
        {
            textView.text = placeholdertext
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
}

//extension to UIColor to allow color definition by hex
extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
//extension to be able to tap outside of uitextview to dismiss keyboard
extension SummaryVC {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SummaryVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

