//
//  SummaryVC.swift
//  Hyphenate Messenger
//
//  Created by devuser on 2017-07-25.
//  Copyright © 2017 Hyphenate Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Alamofire

class SummaryVC: UIViewController, UITextViewDelegate, TutorConnectedDelegate{
    //This class is a viewcontroller that gathers and displays the data inputted by the user about their question. This viewcontroler allows the user to double check the data, enter a description of their question, and send the request for help to our platform.
    
    var categorytitle: String = ""
    var ref: DatabaseReference!
    var key: String?
    var keyboardDisplayed = false
    
    //questionPic is the UIImageView that holds the question image.
    var questionPic: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight*0.37))
        image.backgroundColor = UIColor.white
        return image
    }()
    
    
    //categoryLabel is a UILabel that reads "Category:"
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect.init(x: 100, y: 100, width: 200, height: 200)
        label.textAlignment = .left
        label.backgroundColor = UIColor.white
        label.textColor = UIColor.black
        return label
    }()
    
    //subjectLabel is a UILabel that displays the question's category. (e.g. basic calculus, trig, etc)
    let subjectLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect.init(x: 100, y: 100, width: 200, height: 200)
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        return label
    }()
    
    //questionDescription is a UITextView that allows the user to input a short description of their question.
    let questionDescription: UITextView = {
        let textview = UITextView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight*0.3))
        textview.backgroundColor = UIColor.white
        textview.textAlignment = .left
        textview.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textview.textColor = .lightGray
        textview.font = UIFont.systemFont(ofSize: 16.0)
        //textview.text initialized in setup
        return textview
    }()
    
    //nextButton is a UIButton that when presed will send the request of the student and display a waiting screen.
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.init(hex: "2EA2DC")
        button.setTitle("Request Help!", for: .normal)
        button.setTitleColor( .white , for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.white


        //        view.backgroundColor = UIColor.init(red: 239, green: 239, blue: 255, alpha: 1)
        view.backgroundColor = UIColor.init(hex: "EFEFF4")
        ref = Database.database().reference()
        self.key = self.ref?.child("request/active").childByAutoId().key
//        navigationController?.navigationBar.tintColor = UIColor.black
        //        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        
        //add the subviews and setup their autolayout constraints
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func createlabel()->UILabel{
    
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 81))
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.white
        
        label.font = UIFont(name: "HelveticaNeue", size: CGFloat(22))
        label.text = "You can cancel this question in few second"
        
        return label
    }
    
    func setuplabel(label:UILabel){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant:100).isActive = true
        label.widthAnchor.constraint(equalToConstant: 200).isActive = true
        label.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
    }
    
    //flag variable monitors which screen we are on. States: -1 = not set, 0 = tutor connecting screen, 1 = tutor connected screen
    var flag = -1
    
    func requestHelpPressed(button: UIButton) {
        //check if keyboard is displayed and if it is then dismiss before continuing
        if keyboardDisplayed == true {
            dismissKeyboard()
        }
        //Check if description was entered. If a description was not entered modify text uploaded to database.
        if self.questionDescription.text == "Add Description Here..." {
            self.questionDescription.text = "No Description Available"
        }
        //write question to firebase
        var data = Data()
        data = UIImageJPEGRepresentation(questionPic.image!, 0.8)!
        let sid = EMClient.shared().currentUsername!
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        _ = MKFullSpinner.show("Your tutor is on the way", view: self.view)
        self.flag = 0
        
        //let label = createlabel()
        //self.view.addSubview(label)
        //setuplabel(label: label)
        let button = UIButton(frame: CGRect(x: 0, y: 20, width: 100, height: 50))
        button.setTitle("Cancel", for: .normal)
        button.addTarget(self, action: #selector(self.cancelAction), for: .touchUpInside)
        self.view.addSubview(button)
        
        uploadPicture(data, completion:{ (url) -> Void in
            let addRequest = ["sid": sid, "picURL":url!, "category": self.categorytitle, "description":
                self.questionDescription.text as String, "status": 0, "qid": self.key!, "tid":"", "duration": "", "rate":""] as [String : Any]
            self.ref?.child("Request/active/\(self.categorytitle)/\(String(describing: self.key!))").setValue(addRequest)
            //label.removeFromSuperview()
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tutorFound(_:)), name: NSNotification.Name(rawValue: "kNotification_didReceiveRequest"), object: nil)
        
    }
    
    var didStudentClickOkAfterTutorinChat = false
    func changeDidStudentClickOkAfterTutorinChat(){
        didStudentClickOkAfterTutorinChat = true
    }
    
    func tutorFound(_ notification: NSNotification){
        
        let alert = UIAlertController(title: "Tutor Connected", message: "Tutor Connected", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(
            title: "OK",style: UIAlertActionStyle.default, handler:
            { (alert:UIAlertAction!) in
                MKFullSpinner.hide()
                
                //tcVC - tutorconnectedVC
                let tcVC = TutorConnectedVC()
                tcVC.questionDescription = self.questionDescription.text
                tcVC.questionImage = self.questionPic.image
                tcVC.requestdict = notification.userInfo as? [String : Any]
                tcVC.delegate = self
                tcVC.didStudentCickOkAfterTutorinChat = self.didStudentClickOkAfterTutorinChat
                
                //if student clicks ok before tutor is in chat this variable will remain false. Hence the observer is removed. The observer will then be changed to calltcVC.startChatwithTutor inside the viewdidload of next VC
                if self.didStudentClickOkAfterTutorinChat == false{
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "kNotification_didReceiveRequest"), object: nil)
                }
                self.flag = 1
                self.navigationController?.pushViewController(tcVC, animated: true)
        }))
        
        //Before the alert is presented we edit the friendrequest observer to call the function didStudentClickOkAfterTutorinChat function to notify the next VC, that the tutor is in chat if the student hasnt clicked ok on the alert before the tutor clicks ready to begin.
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "kNotification_didReceiveRequest"), object: nil)
        //Add observer to lookout for notification
        NotificationCenter.default.addObserver(self, selector: #selector(changeDidStudentClickOkAfterTutorinChat), name: NSNotification.Name(rawValue: "kNotification_didReceiveRequest"), object: nil)

        self.present(alert, animated: true, completion: nil)
//        self.startChatting(requestDict: notification.userInfo as! [String : Any])

    }

    
    func startChatting(requestDict:[String: Any], image: UIImage, description: String){
        let timeStamp = ["SessionId":String(Date().ticks)]
        let sessionController = ChatTableViewController(conversationID: requestDict["username"] as! String , conversationType: EMConversationTypeChat, initWithExt: timeStamp)
        sessionController?.key = self.key!
        sessionController?.category = self.categorytitle
        //check if description was entered.
        var isDescriptionEntered: Bool?
        if description == "No Description Available" {
            isDescriptionEntered = false
        } else {
            isDescriptionEntered = true
        }
        
        self.navigationController?.isNavigationBarHidden = false
        if let sessContr = sessionController{
            sessContr.questionimage = image
            if isDescriptionEntered == true{
                sessContr.questiondescription = description
            }
            self.navigationController?.pushViewController(sessContr, animated: true)
        }
    }

    func cancelAction(sender: UIButton!){
        let parameters: Parameters = [
            "category" : self.categorytitle,
            "qid" : self.key!,
        ]
        print(parameters)
        Alamofire.request("http://us-central1-instasolve-d8c55.cloudfunctions.net/cancel",method:.get, parameters: parameters, encoding: URLEncoding.default)
            .responseString { response in
                print(response.result.value!)

        }
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        sender.removeFromSuperview()
        MKFullSpinner.hide()
        self.flag = -1

       /* let storage = Storage.storage()
        let storageRef = storage.reference()
        let removeRef = storageRef.child("image/\(self.categorytitle)/\(self.key!))")
        removeRef.delete { (Error) in
            if let error = Error {
                let alert = UIAlertController(title: "Delete error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
                self.present(alert, animated: true, completion: nil)

            } else {
                self.ref?.child("Request/active/\(self.categorytitle)/\(String(describing: self.key!))").removeValue()
            }
        }
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        sender.removeFromSuperview()
        MKFullSpinner.hide()*/
    }
    
    func cancelFromAppTermination(){
        // This function is called when a cancel order needs to be put through because the app is terminated. It is the same function as cancel action but deleted one line of code "sender.removeFromSuperview()" since there is no sender.
        let parameters: Parameters = [
            "category" : self.categorytitle,
            "qid" : self.key!,
            ]
        print(parameters)
        Alamofire.request("http://us-central1-instasolve-d8c55.cloudfunctions.net/cancel",method:.get, parameters: parameters, encoding: URLEncoding.default)
//            .responseString { response in
//                print(response.result.value!)
//        
//        }
        self.navigationController?.setNavigationBarHidden(false, animated: false)
//        MKFullSpinner.hide()
    }
    
    func uploadPicture(_ data: Data, completion:@escaping (_ url: String?) -> ()) {
        let storageRef = Storage.storage().reference()
        storageRef.child("image/\(self.categorytitle)/\(self.key!))").putData(data, metadata: nil){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                
            }else{
                //store downloadURL
                completion((metaData?.downloadURL()?.absoluteString)!)
                
                
            }
            
        }
    }
    
    func setupQuestionPic() {
        questionPic.translatesAutoresizingMaskIntoConstraints = false
        questionPic.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        questionPic.heightAnchor.constraint(equalToConstant: screenHeight*0.37).isActive = true
        
        questionPic.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        questionPic.topAnchor.constraint(equalTo: view.topAnchor, constant: 68).isActive = true
        questionPic.contentMode = .scaleAspectFit
    }
    
    func setupCategoryLabel() {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        categoryLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: questionPic.bottomAnchor, constant: 12).isActive = true
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
        questionDescription.heightAnchor.constraint(equalToConstant: screenHeight*0.3).isActive = true
        
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
//        textView.becomeFirstResponder() //Optional
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text == "")
        {
            textView.text = placeholdertext
            textView.textColor = .lightGray
        }
//        textView.resignFirstResponder()
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
//extension to SummaryVC to alow for better keyboard functionality
extension SummaryVC {
    //Allows the keyboard to be hidden when tapped outside of keyboard
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SummaryVC.dismissKeyboard))
        
        let swipeOutOfKeyboard: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SummaryVC.dismissKeyboard))
        swipeOutOfKeyboard.direction = .down
        
        questionDescription.addGestureRecognizer(swipeOutOfKeyboard)
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(swipeOutOfKeyboard)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //The below two functions allow the view to move up/down when the keyboard is presented/hidden. These functions are called by an observer for when the keyboard is presented/hidden.
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        keyboardDisplayed = true
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
        keyboardDisplayed = false
    }
}

/*
 CODE GRAVEYARD
 
 //flag variable monitors which screen we are on. States: -1 = not set, 0 = tutor connecting screen, 1 = tutor connected screen
 var flag = 0
 func tutorFound(_ notification: NSNotification){
 if self.flag == 0 {
 let alert = UIAlertController(title: "Tutor Connected", message: "Tutor Connected", preferredStyle: UIAlertControllerStyle.alert)
 alert.addAction(UIAlertAction(title: "OK",
 style: UIAlertActionStyle.default,
 handler: { (alert:UIAlertAction!) in
 MKFullSpinner.hide()
 _ = MKFullSpinner.show("Your tutor is working on your problem", view: self.view)
 self.flag = 1
 }))
 self.present(alert, animated: true, completion: nil)
 }
 if self.flag == 1 {
 let alert = UIAlertController(title: "Tutor is Ready", message: "Your tutor is now ready to begin your session.", preferredStyle: UIAlertControllerStyle.alert)
 alert.addAction(UIAlertAction(title: "OK",
 style: UIAlertActionStyle.default,
 handler: { (alert:UIAlertAction!) in
 MKFullSpinner.hide()
 self.startChatting(requestDict: notification.userInfo as! [String : Any])
 self.flag = 0
 }))
 self.present(alert, animated: true, completion: nil)
 }
 
 }
 
 
 
 */
