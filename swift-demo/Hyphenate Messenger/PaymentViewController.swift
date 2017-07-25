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

class PaymentViewController: UIViewController, STPPaymentCardTextFieldDelegate {
    
    var price = 0
    var product = ""
    let paymentTextField = STPPaymentCardTextField()
    var ref: DatabaseReference?
    
    @IBOutlet weak var payButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        paymentTextField.frame = CGRect(x: 15, y: 199, width: self.view.frame.width - 30, height: 44)
        paymentTextField.delegate = self
        view.addSubview(paymentTextField)
        payButtonOutlet.isHidden = true;
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        if textField.valid{
            payButtonOutlet.isHidden = false
        }
    }

    @IBAction func payButtonAction(_ sender: Any) {
        let card = paymentTextField.cardParams
        STPAPIClient.shared().createToken(withCard: card, completion: {(token, error) -> Void in
            if let error = error {
                print(error)
            }
            else if let token = token {
                print("----------------generating token from stripe------------------")
                print(token)
                self.chargeUsingToken(token: token)
            }
        })
    }
    
    func chargeUsingToken(token: STPToken){
        // Post data to Firebase
        print("--------------------------writing to database--------------------------")
        ref = Database.database().reference()
        ref?.child("payments").childByAutoId().setValue(["token": token.tokenId,"amount": 20000])
    }
}

