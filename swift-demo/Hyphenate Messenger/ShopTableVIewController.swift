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
    
    // let products = ["10min package", "30min package", "60min package", "120min package", "Unlimite Questions"]
    // let prices = [400, 1100, 2000, 3800, 9900]
    var products = [String]()
    var prices = [Int]()
    let theme = Theme()
    
    var uid = "+1" + EMClient.shared().currentUsername!
    var price = 0
    var product = ""
    
    //let settingsVC = SettingsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.title = "Shop"
        self.tableView.tableFooterView = UIView()
        
        // Grab price - amount mapping from db
        ref?.child("price").observeSingleEvent(of: .value, with: { (snapshot) in

            let mapping = snapshot.value as? NSDictionary
            
            for p in (mapping?.allKeys)!{
                self.prices.append(Int("\(p)")!)
            }
            
            self.prices = self.prices.sorted()
            
            for i in self.prices{
                let temp = "\(i)"
                self.products.append("\((mapping?[temp])!) mins package")
            }

            // TO DO: add hub close
            
        }) { (error) in
            print(error.localizedDescription)
            // TO DO: add hub close + alert
        }
        
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Shop"
        // TO DO: add hud loading
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
        return self.products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        let product = products[indexPath.row]
        let price = prices[indexPath.row]
        //let theme = self.settingsVC.settings.theme
        cell.backgroundColor = theme.secondaryBackgroundColor
        cell.textLabel?.text = product
        cell.textLabel?.font = theme.font
        cell.textLabel?.textColor = theme.primaryForegroundColor
        // cell.detailTextLabel?.text = "$\(price/100).00"
        // cell.accessoryType = .disclosureIndicator
        cell.accessoryType = UITableViewCellAccessoryType.none
        
        // to make it non selectable
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        
        let priceButton = UIButton(type: .custom)
        
        priceButton.backgroundColor = .clear
        priceButton.layer.cornerRadius = 5
        priceButton.layer.borderWidth = 1
        priceButton.layer.borderColor = theme.buttonColor.cgColor
        // priceButton.backgroundColor = UIColor.blue
        priceButton.setTitle("$\(price/100)", for: .normal)
        priceButton.setTitleColor(theme.buttonColor, for:.normal )
        priceButton.addTarget(self, action: #selector(ShopTableViewController.payAlert(_:)), for: .touchUpInside)
        priceButton.frame = CGRect(x: 300, y: 7, width: 60, height: 30)
        priceButton.tag = price
        cell.addSubview(priceButton)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let logoutButton = UIButton(type: .custom)
        logoutButton.backgroundColor = UIColor.blue
        logoutButton.setTitle("Change Card", for: .normal)
        logoutButton.backgroundColor = .clear
        logoutButton.layer.cornerRadius = 5
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.borderColor = theme.buttonColor.cgColor
        logoutButton.setTitleColor(theme.buttonColor, for:.normal )
        logoutButton.addTarget(self, action: #selector(ShopTableViewController.updateCard), for: .touchUpInside)
        logoutButton.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - 345, width: UIScreen.main.bounds.size.width, height: 45)
        
        let footerView = UIView(frame: CGRect(x: 0, y: 300, width: UIScreen.main.bounds.size.width, height: 300))
        
        //UIScreen.main.bounds.size.height - 220
        print("UI main screen height \(UIScreen.main.bounds.size.height)")
        print("current view height \(view.bounds.size.height)")
        // footerView.backgroundColor = UIColor.black
        footerView.addSubview(logoutButton)
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.size.height - 300
    }
    
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
    
    func payAlert(_ sender: UIButton) {
        
        print("which button is pressed \(sender.tag)")
        
        let title = "Confirm Purchase"
        let message = "Proceed to purchase package for \(String(describing: String(sender.currentTitle!)))?"
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // detach all listener for db
        ref?.removeAllObservers()
    }

}
