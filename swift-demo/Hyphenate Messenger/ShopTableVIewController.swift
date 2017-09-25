//
//  ShopTableVIewController.swift
//
//  Created by Ming Yue on 2017-07-14.
//  All rights reserved.
//


import UIKit
import Stripe
import FirebaseDatabase
import Hyphenate


struct Theme {
    let primaryBackgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)//UIColor(red:0.96, green:0.96, blue:0.95, alpha:1.00)
    let secondaryBackgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
    let primaryForegroundColor = UIColor(red:0.35, green:0.35, blue:0.35, alpha:1.00)
    let secondaryForegroundColor = UIColor(red:0.66, green:0.66, blue:0.66, alpha:1.00)
    let accentColor = UIColor(red:0.09, green:0.81, blue:0.51, alpha:1.00)
    let errorColor = UIColor(red:0.87, green:0.18, blue:0.20, alpha:1.00)
    let font = UIFont.systemFont(ofSize: 18)
    let emphasisFont = UIFont.boldSystemFont(ofSize: 18)
    let buttonColor = UIColor(red: 45.0/255.0, green: 162.0/255.0, blue: 220.0/255.0, alpha: 1.0)
}

class ShopTableViewController: UITableViewController, STPAddCardViewControllerDelegate{
    
    var ref: DatabaseReference? = Database.database().reference()
    
    //var products = ["10min package", "30min package", "60min package", "120min package", "Unlimite Questions"]
    //var prices = [400, 1100, 2000, 3800, 9900]
    
    var products = [String]()
    var prices = [Int]()
    let theme = Theme()
    
    var uid = "+1" + EMClient.shared().currentUsername!
    var price = 0
    var product = ""
    var balance = 0
    var checkHide = 0
    
    /*let changeCardButton: UIButton = {
     let theme = Theme()
     let button = UIButton(type: .system)
     button.backgroundColor = UIColor.blue
     button.setTitle("Change Card", for: .normal)
     button.backgroundColor = .clear
     button.layer.cornerRadius = 5
     button.layer.borderWidth = 1
     button.layer.borderColor = theme.buttonColor.cgColor
     button.setTitleColor(theme.buttonColor, for:.normal)
     return button
     }()*/
    
    //let settingsVC = SettingsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.title = "Shop"
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorInset = .zero
        // Grab price - amount mapping from db
        
    }
    /*func setupButton(){
     changeCardButton.translatesAutoresizingMaskIntoConstraints = false
     changeCardButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
     changeCardButton.bottomAnchor.constraint(equalTo: self.tableView.bottomAnchor).isActive = true
     changeCardButton.addTarget(self, action: #selector(ShopTableViewController.updateCard), for: .touchUpInside)
     let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .value1, reuseIdentifier: "Cell")
     changeCardButton.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 1)
     }*/
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Shop"
        showHud(in: view, hint: "loding")
        products.removeAll()
        prices.removeAll()
        checkHide = 0
        ref?.child("users/\(uid)/balance").observeSingleEvent(of: .value, with: { (snapshot) in
            self.balance = (snapshot.value as? Int)!
            self.tableView.reloadData()
            if self.checkHide == 1{
                self.hideHud()
            }
            else{self.checkHide = 1}
        }){ (error) in
            //print(error.localizedDescription)
            if self.checkHide == 1{
                self.hideHud()}
            else{self.checkHide = 1}
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let okay = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(okay)
            self.present(alert, animated: true, completion: nil)
        }
        ref?.child("price").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let mapping = snapshot.value as? NSDictionary
            
            // Get prices array from all keys of mapping dictionary
            for p in (mapping?.allKeys)!{
                self.prices.append(Int("\(p)")!)
            }
            
            self.prices = self.prices.sorted()
            
            // Get products array by indexing mapping dictionary with items in prices
            for i in self.prices{
                let temp = "\(i)"
                self.products.append("\((mapping?[temp])!) mins package")
            }
            if self.checkHide == 1{
                self.hideHud()}
            else{self.checkHide = 1}
            
            self.tableView.reloadData()
            
        }) { (error) in
            //print(error.localizedDescription)
            if self.checkHide == 1{
                self.hideHud()}
            else{self.checkHide = 1}
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let okay = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(okay)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // let theme = Theme()
        super.viewDidAppear(animated)
        self.view.backgroundColor = theme.primaryBackgroundColor
        self.navigationController?.navigationBar.barTintColor = theme.secondaryBackgroundColor
        self.navigationController?.navigationBar.tintColor = theme.accentColor
        let titleAttributes = [
            NSForegroundColorAttributeName: theme.primaryForegroundColor,
            NSFontAttributeName: theme.font,
            ] as [String : Any]
        let buttonAttributes = [
            NSForegroundColorAttributeName: theme.accentColor,
            NSFontAttributeName: theme.font,
            ] as [String : Any]
        self.navigationController?.navigationBar.titleTextAttributes = titleAttributes
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(buttonAttributes, for: UIControlState())
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes(buttonAttributes, for: UIControlState())
        //self.tableView.separatorColor = theme.primaryBackgroundColor
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.products.count != 0{
            return self.products.count + 1
        }
        else{
            return self.products.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < self.products.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .value1, reuseIdentifier: "Cell")
            let product = products[indexPath.row]
            let price = prices[indexPath.row]
            //let theme = self.settingsVC.settings.theme
            cell.backgroundColor = theme.secondaryBackgroundColor
            cell.textLabel?.text = product
            cell.textLabel?.font = theme.font
            cell.textLabel?.textColor = UIColor.black
            // cell.detailTextLabel?.text = "$\(price/100).00"
            // cell.accessoryType = .disclosureIndicator
            cell.accessoryType = .none
            
            // to make it non selectable
            cell.selectionStyle = .none;
            
            let priceButton = UIButton(type: .custom)
            
            priceButton.backgroundColor = .clear
            priceButton.layer.cornerRadius = 5
            priceButton.layer.borderWidth = 1
            priceButton.layer.borderColor = theme.buttonColor.cgColor
            // priceButton.backgroundColor = UIColor.blue
            priceButton.setTitle("$\(price/100)", for: .normal)
            priceButton.setTitleColor(theme.buttonColor, for:.normal )
            priceButton.addTarget(self, action: #selector(ShopTableViewController.payAlert(_:)), for: .touchUpInside)
            priceButton.frame = CGRect(x: UIScreen.main.bounds.size.width * 0.81, y: 7, width: 60, height: 30)
            priceButton.tag = price
            cell.addSubview(priceButton)
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .value1, reuseIdentifier: "Cell")
            cell.imageView?.image = #imageLiteral(resourceName: "creditcard")
            cell.textLabel?.text = "Change your card"
            return cell
        }
    }
    
    /*override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
     /*let changeCardButton = UIButton(type: .custom)
     changeCardButton.backgroundColor = UIColor.blue
     changeCardButton.setTitle("Change Card", for: .normal)
     changeCardButton.backgroundColor = .clear
     changeCardButton.layer.cornerRadius = 5
     changeCardButton.layer.borderWidth = 1
     changeCardButton.layer.borderColor = theme.buttonColor.cgColor
     changeCardButton.setTitleColor(theme.buttonColor, for:.normal )
     changeCardButton.addTarget(self, action: #selector(ShopTableViewController.updateCard), for: .touchUpInside)
     changeCardButton.frame = CGRect(x: 0, y: 200, width: UIScreen.main.bounds.size.width, height: 45)
     
     let footerView = UIView(frame: CGRect(x: 0, y: 200, width: UIScreen.main.bounds.size.width, height: 100))
     
     //UIScreen.main.bounds.size.height - 220
     print("UI main screen height \(UIScreen.main.bounds.size.height)")
     print("current view height \(view.bounds.size.height)")
     // footerView.backgroundColor = UIColor.black*/
     let footerView = UIView(frame: CGRect(x: 0, y: 200, width: UIScreen.main.bounds.size.width, height: 45))
     footerView.translatesAutoresizingMaskIntoConstraints = false
     changeCardButton.translatesAutoresizingMaskIntoConstraints = false
     footerView.addSubview(changeCardButton)
     
     let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .value1, reuseIdentifier: "Cell")
     footerView.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 1)
     changeCardButton.widthAnchor.constraint(equalTo: footerView.widthAnchor).isActive = true
     changeCardButton.topAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
     changeCardButton.addTarget(self, action: #selector(ShopTableViewController.updateCard), for: .touchUpInside)
     changeCardButton.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 1)
     footerView.backgroundColor = UIColor.red
     return footerView
     }*/
    
    /*override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
     return 200
     }*/
    
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        tableView.deselectRow(at: indexPath, animated: true)
    //        product = products[indexPath.row]
    //        price = prices[indexPath.row]
    //
    //        let title = "Confirm Purchase"
    //        let message = "Proceed to purchase \(product) package for $\(price/100).00)?"
    //        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    //        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
    //        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: {action in self.payButton()}))
    //
    //        self.present(alert, animated: true, completion: nil)
    //
    //    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.10)
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor).isActive = true
        view.backgroundColor = theme.buttonColor
        let label = UILabel()
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = UIImage(named:"Balance2")
        //Set bound to reposition
        let imageOffsetY:CGFloat = -8.0;
        imageAttachment.bounds = CGRect(x: -5, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        //Create string with attachment
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        //Initialize mutable string
        let completeText = NSMutableAttributedString(string: "")
        //Add image to mutable string
        completeText.append(attachmentString)
        //Add your text to mutable string
        let  textAfterIcon = NSMutableAttributedString(string: "Balance: \(self.balance) minutes")
        completeText.append(textAfterIcon)
        label.textAlignment = .center;
        label.attributedText = completeText;
        label.frame = CGRect(x:0, y: 0, width: UIScreen.main.bounds.size.width*0.8, height: UIScreen.main.bounds.size.height * 0.10*0.5)
        label.center = view.center
        //label.backgroundColor = UIColor.white
        
        view.addSubview(label)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.size.height * 0.10
    }
    
    func payAlert(_ sender: UIButton) {
        
        print("which button is pressed \(sender.tag)")
        
        let title = "Confirm Purchase"
        let message = "Proceed to purchase package for \(sender.currentTitle!)?"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        let amount:Int? = Int(sender.tag)
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: {action in self.payButton(amount!)}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateCard() {
        
        self.addCard()
    }
    
    
    func payButton(_ amount: Int) {
        print("pay button clicked")
        print(uid)
        
        _ = MKFullSpinner.show("Processing your payment now", view: self.view)
        
        ref = Database.database().reference()
        ref?.child("users").child(uid).child("payments").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let val = snapshot.value as? NSDictionary
            print(val!)
            if (val!["sources"] != nil){
                print("Charging Costomer Now")
                self.chargeUsingCustomerId(amount)
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
    
    func chargeUsingCustomerId(_ amount: Int){
        // Post data to Firebase
        print("charge using customerId----------------------")
        // ref = Database.database().reference()
        
        let paymentId = self.ref?.child("users").child(uid).child("payments/charges").childByAutoId().key
        
        print("paymentId\(String(describing: paymentId))")
        ref?.child("users").child(uid).child("payments/charges").child(paymentId!).setValue(["amount": amount])
        print("Done writing to db")
        
        // TO DO: add listener
        // add loading page
        // display alert
        
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
                    let message = "You have purchased \(self.product) package for $\(amount/100).00"
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    print("postDict\(String(describing: postDict))")
                    
                    MKFullSpinner.hide()
                    let title = "Payment Failed"
                    let message = "Please try again"
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
            
        })
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == self.products.count{
            updateCard()
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // detach all listener for db
        ref?.removeAllObservers()
    }
    
}
