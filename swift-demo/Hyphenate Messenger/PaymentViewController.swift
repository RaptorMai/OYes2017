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
    // let paymentTextField = STPPaymentCardTextField()
    var ref: DatabaseReference?
    var uid = "+1" + EMClient.shared().currentUsername!
    
//    @IBOutlet weak var payButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        paymentTextField.frame = CGRect(x: 15, y: 0.35 * self.view.frame.height, width: self.view.frame.width - 30, height: 44)
//        paymentTextField.delegate = self
//        view.addSubview(paymentTextField)
//        payButtonOutlet.isHidden = true;
//        
//        let paymentInfoLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 30, height: 800))
//        paymentInfoLabel.center = CGPoint(x: self.view.frame.width/2, y: 0.191 * self.view.frame.height)
//        paymentInfoLabel.text = "Please enter card information to confirm your purchase:\n \"" + product + "\" for $\(self.price/100).00."
//        paymentInfoLabel.adjustsFontSizeToFitWidth = true
//        paymentInfoLabel.numberOfLines = 2
//        //paymentInfoLabel.layer.borderColor = (UIColor.black as! CGColor)
//        //paymentInfoLabel.layer.borderWidth = 2
//        view.addSubview(paymentInfoLabel)
    }
    
//    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
//        if textField.isValid{
//            payButtonOutlet.isHidden = false
//            view.endEditing(true)
//        }
//    }

//    @IBAction func payButtonAction(_ sender: Any) {
//        let card = paymentTextField.cardParams
//        STPAPIClient.shared().createToken(withCard: card, completion: {(token, error) -> Void in
//            if let error = error {
//                print(error)
//            }
//            else if let token = token {
//                print("----------------generating token from stripe------------------")
//                print(token)
//                self.chargeUsingToken(token: token)
//            }
//        })
//    }
    
//    func chargeUsingToken(token: STPToken){
//        // Post data to Firebase
//        print("--------------------------writing to database--------------------------")
//        ref = Database.database().reference()
//        //assert(self.price > 0, "error: invalid price")
//        ref?.child("payments").childByAutoId().setValue(["token": token.tokenId,"amount": self.price])
//    }
    
    // let userID = Auth.auth().currentUser?.uid
    // let uid = "x7JaMs1gKNYbg1mIxRIqDsDBYp42"
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//    }
    
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
        ref?.child("users").child(uid).child("payments/charges").childByAutoId().setValue(["amount": price])
        print("Done writing to db")
    }

}

