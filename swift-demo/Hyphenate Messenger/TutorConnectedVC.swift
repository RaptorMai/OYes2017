//
//  TutorConnectedVC.swift
//  Hyphenate Messenger
//
//  Created by devuser on 2017-08-27.
//  Copyright © 2017 Hyphenate Inc. All rights reserved.
//

import UIKit

class TutorConnectedVC: UIViewController {

    var requestdict: [String: Any]? = nil
    var questionImage: UIImage?
    var questionDescription: String?
    var didStudentCickOkAfterTutorinChat = false
    var delegate: TutorConnectedDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        //Display the spinner
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        _ = MKFullSpinner.show("Your tutor is working on the problem", view: self.view)
        let label = UILabel(frame: CGRect(x: 150, y: 250, width: 200, height: 100))
        label.text = "Your tutor is working on the problem"
        label.numberOfLines = 0
        view.addSubview(label)
        //if the student clicks ok on previous alert after the tutor is in the session, hence didStudentClickOkAfterTutorinChat = true, we call the start chat with tutor, else we modify the observer again so that it calls startchatwithtutor once a notification is recieved
        if didStudentCickOkAfterTutorinChat == true {
            startChatwithTutor()
        } else{
            NotificationCenter.default.addObserver(self, selector: #selector(startChatwithTutor), name: NSNotification.Name(rawValue: "kNotification_didReceiveRequest"), object: nil)
        }


        
    }
    
    func startChatwithTutor(){
        //Remove observer for friend request notification
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "kNotification_didReceiveRequest"), object: nil)
        delegate?.startChatting(requestDict: self.requestdict!, image: self.questionImage!, description: self.questionDescription!)
    }
    

}

protocol TutorConnectedDelegate{
    func startChatting(requestDict:[String: Any], image: UIImage, description: String)
}
