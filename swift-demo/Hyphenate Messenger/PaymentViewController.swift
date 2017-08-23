//
//  ViewController.swift
//  PayMe
//
//  Created by Emma Chen on 2017-07-21.
//  Copyright © 2017 Emma Chen. All rights reserved.
//

import UIKit
import Stripe
import FirebaseDatabase
import Hyphenate

class PaymentViewController: UIViewController, STPAddCardViewControllerDelegate {
    
    var price = 0
    var product = ""
    var ref: DatabaseReference?
    var uid = "+1" + EMClient.shared().currentUsername!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func updateCard(_ sender: Any) {
        
        // Here need to delete old card first
        self.addCard()
    }
    
    @IBAction func payButton(_ sender: Any) {
        print("pay button clicked")
        print(uid)
        
        ref = Database.database().reference()
        ref?.child("users").child(uid).child("payments").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let val = snapshot.value as? NSDictionary
            print(val!)
            if (val!["sources"] != nil){
                print("Charging Costomer Now")
                self.chargeUsingCustomerId()
            }
            else{
                print("Please add a card first")
                self.addCard()
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }

    func addCard(){
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        // STPAddCardViewController must be shown inside a UINavigationController.
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: STPAddCardViewControllerDelegate
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        print("generating token-------------")
        print(token)
        // Use token for backend process
        ref?.child("users").child(uid).child("payments/sources/token").setValue(token.tokenId)
        self.dismiss(animated: true, completion: {
            completion(nil)
        })
    }

    func chargeUsingCustomerId(){
        // Post data to Firebase
        print("charge using customerId----------------------")
        // ref = Database.database().reference()
        
        let paymentId = self.ref?.child("users").child(uid).child("payments/charges").childByAutoId().key
        
        print("paymentId\(String(describing: paymentId))")
        ref?.child("users").child(uid).child("payments/charges").child(paymentId!).setValue(["amount": price])
        print("Done writing to db")
        
        // TO DO: add listener
        // add loading page
        // display alert
        _ = MKFullSpinner.show("Processing your payment now", view: self.view)
        
        let postRef = ref?.child("users").child(uid).child("payments/charges").child(paymentId!).child("status")
        
        _ = postRef?.observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? String
            // let status = postDict["status"] as? String ?? ""
            if (postDict != nil){
                
                if (postDict == "succeeded"){
                    // dismiss loading page
                    
                    MKFullSpinner.hide()
                    
                    // send alert
                    let title = "Payment Successed"
                    let message = "You have purchased packages " + String(self.price)
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
                    self.present(alert, animated: true, completion: nil)

                } else {
                    print("postDict\(String(describing: postDict))")
                    MKFullSpinner.hide()
                    let title = "Payment Failed"
                    let message = "Please try again"
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
            
        })
        
    }

}

