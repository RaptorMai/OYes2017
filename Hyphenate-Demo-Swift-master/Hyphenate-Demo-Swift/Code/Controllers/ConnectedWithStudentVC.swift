//
//  ConnectedWithStudentVC.swift
//  Hyphenate-Demo-Swift
//
//  Created by devuser on 2017-08-28.
//  Copyright © 2017 杜洁鹏. All rights reserved.
//

import UIKit
import Hyphenate

class ConnectedWithStudentVC: UIViewController {

    var requestorSid: NSString?
    var category: String?
    var qid: String?
    var image: UIImage?
    var questDescription: String?

    @IBOutlet weak var questionImage: UIImageView!
    
    @IBOutlet weak var questionDescription: UILabel!
    
    @IBAction func readyToConnect(_ sender: UIButton) {
        let addContactViewController = EMAddContactViewController.init(nibName: "EMAddContactViewController", bundle: nil)
        addContactViewController.contactToAdd = self.requestorSid! as String
        addContactViewController.sendRequest(addContactViewController.contactToAdd)
         let sessionController = EMChatViewController.init(requestorSid! as String, EMConversationTypeChat)
         sessionController.category = category!
         sessionController.key = qid!
        
//         let navC = UINavigationController(rootViewController: sessionController)
//         self.navigationController?.present(navC, animated: true, completion: nil)
        navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(sessionController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
        questionImage.image = image
        questionDescription.text = questDescription
        questionImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(expandimage))
        self.questionImage.addGestureRecognizer(tapGesture)

    }

    /*
    func readyButtonPressed(requestorSid: NSString, category: NSString, qid: NSString, image:UIImage?, description: String?) {
        
        let ref = Database.database().reference()
        let tid = EMClient.shared().currentUsername
        //print(tid)
        // TO DO: get current questionId from db
        let qid: String = (qid as String)
        let category: String = (category as String)
        let refStatus = ref.child("Request/active/" + category + "/" + qid)
        //let refInactive = ref.child("Request/inactive/" + category + "/" + qid)
        refStatus.runTransactionBlock ({ (currentData: MutableData) -> TransactionResult in
            //print(currentData.value)
            if var data = currentData.value as? [String: Any] {
                print("this is data \(data)")
                var status = data["status"] as? Int
                
                if status == 1 {
                    // TO DO: pop up window saying better luck next time
                    
                    return TransactionResult.abort()
                } else {
                    status = 1
                    data["status"] = status
                    data["tid"] = tid
                    // TO DO: assign tutorId to accepted question
                    // TO DO: connect to student to start session -> func startSession(sid)
                    
                }
                // update status on Firebase db
                currentData.value = data
                print("updated data \(data)")
                return TransactionResult.success(withValue: currentData)
            }
            
            print("data is nill")
            return TransactionResult.success(withValue: currentData)
        },andCompletionBlock: {
            error, commited, snap in
            
            //if the transaction was commited, i.e. the data
            //under snap variable has the value of the counter after
            //updates are done
            if commited {
                
                print(snap?.value)
                let checkNill = snap?.value! as? [String:AnyObject]
                print(checkNill)
                if (checkNill == nil){
                    
                    let alert = UIAlertController(title: "Alert", message: "Sorry better luck next time", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {action in self.refresh()}))
                    self.present(alert, animated: true, completion: nil)
                    print("Sorry better luck next time")
                    //print(snap!)
                }
                else{
                    
                    let alert = UIAlertController(title: "Alert", message: "yeah you got the question", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {
                        (alert: UIAlertAction!) in
                        //Once user dismisses the alert: create a chat viewcontroller and embed it in a navigation controller. The navigation controller is then presented with a done button.
                        /*
                         let sessionController = EMChatViewController.init(requestorSid as String, EMConversationTypeChat)
                         sessionController.category = category
                         sessionController.key = qid
                         
                         let navC = UINavigationController(rootViewController: sessionController)
                         self.navigationController?.present(navC, animated: true, completion: nil)
                         */
                        let cwsVC = ConnectedWithStudentVC()
                        cwsVC.requestorSid = requestorSid
                        cwsVC.category = category
                        cwsVC.qid = qid
                        if let unwrappedimage = image {
                            cwsVC.image = unwrappedimage
                        }
                        if let unwrappeddescription = description{
                            cwsVC.questDescription = unwrappeddescription
                        }
                        self.navigationController?.pushViewController(cwsVC, animated: true)
                        
                        let addContactViewController = EMAddContactViewController.init(nibName: "EMAddContactViewController", bundle: nil)
                        addContactViewController.contactToAdd = requestorSid as String
                        addContactViewController.sendRequest(addContactViewController.contactToAdd)
                        //print(snap!)
                        print("yeah you got the question")
                    }))
                    
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }
            else{
                
                let alert = UIAlertController(title: "Alert", message: "Sorry better luck next time", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {action in self.refresh()}))
                self.present(alert, animated: true, completion: nil)
                print("Sorry better luck next time, not commit")
                //print(snap)
                
            }
        })
        
        
        //cwsVC means connectedwithstudentVC
    }
    */
    
    func expandimage(){
        if let image = questionImage.image{
            let agrume = Agrume(image: image, backgroundColor: .black)
            agrume.hideStatusBar = true
            agrume.showFrom(self)
        }
    }


}
