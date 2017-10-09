import UIKit
import Stripe
import FirebaseDatabase
import Hyphenate
import BRYXBanner

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

protocol ShopPurchaseStatusDelegate {
    func didFinishPurchasingWith(status succ: Bool)
}

class ShopTableViewController: UITableViewController, STPAddCardViewControllerDelegate{
    
    var ref: DatabaseReference? = Database.database().reference()
    
    var productMinutes = [Int]()
    var prices = [Int]()
    let theme = Theme()
    let balanceLabel = UILabel()
    
    var uid = "+1" + EMClient.shared().currentUsername!
    var price = 0
    var product = ""
    var balance = 0
    var firstAppear = false
    
    private var isPaymentCardPresent = false
    
    var numDiscountAvailable: Int {
        get {
            return AppConfig.sharedInstance.numDiscountAvailable
        }
    }
    
    var discountRate: Double {
        get {
            return AppConfig.sharedInstance.discountRate
        }
    }
    
    var delegate: ShopPurchaseStatusDelegate?
 
    // set this flag when purchasing before starting chat, so it dismisses
    // itself after successfully purchasing a package
    var isPurchasingBeforeReqeusting = false
    func updatePaymentMethod() {
        ref?.child("users").child(uid).child("payments").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let val = snapshot.value as? NSDictionary {
                print(val)
                if (val["sources"] != nil){
                    print("Got payment value")
                    self.isPaymentCardPresent = true
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // MARK: VC life cyele
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.title = "Shop"
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorInset = .zero
        
        // Load user payment info
        updatePaymentMethod()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Shop"
        showHud(in: view, hint: "Loading")
        productMinutes.removeAll()
        prices.removeAll()

        ref?.child("users/\(uid)/balance").observeSingleEvent(of: .value, with: { (snapshot) in
            if let balance = snapshot.value as? Int {
                self.balance = balance
            }
            
            self.hideHud()
            self.tableView.reloadData()
        }){ (error) in
            //print(error.localizedDescription)
            self.hideHud()
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let okay = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(okay)
            self.present(alert, animated: true, completion: nil)
        }
 
        // get mapping from user defaults
        if let mapping = AppConfig.sharedInstance.getConfigForType(.ConfigTypePackage) as? NSDictionary {
            // Get minutes array from all keys of mapping dictionary
            for p in (mapping.allKeys) {
                productMinutes.append(Int("\(p)")!)
            }
            
            productMinutes = productMinutes.sorted()
            
            // Get products array by indexing mapping dictionary with minute plan, mapping should contain
            // ["10"(minutes):"400"]
            for minutes in productMinutes {
                prices.append(mapping["\(minutes)"]! as! Int)
            }
            
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // let theme = Theme()
        super.viewDidAppear(animated)
        view.backgroundColor = theme.primaryBackgroundColor
        navigationController?.navigationBar.barTintColor = theme.secondaryBackgroundColor
        navigationController?.navigationBar.tintColor = theme.accentColor
        let titleAttributes = [
            NSForegroundColorAttributeName: theme.primaryForegroundColor,
            NSFontAttributeName: theme.font,
            ] as [String : Any]
        let buttonAttributes = [
            NSForegroundColorAttributeName: theme.accentColor,
            NSFontAttributeName: theme.font,
            ] as [String : Any]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        navigationItem.leftBarButtonItem?.setTitleTextAttributes(buttonAttributes, for: UIControlState())
        navigationItem.backBarButtonItem?.setTitleTextAttributes(buttonAttributes, for: UIControlState())

        // set badge view to 0
        tabBarController?.tabBar.items![2].badgeValue = nil
        
        // display banner
        if numDiscountAvailable > 0 {
            let infoBanner = Banner(title: "Discount available!",
                                    subtitle: "Purchase any package at discounted price, \(numDiscountAvailable) times remaining",
                image: nil,
                backgroundColor: UIColor(red:48.00/255.0, green:174.0/255.0, blue:51.5/255.0, alpha:1.000))
            
            infoBanner.dismissesOnTap = true
            infoBanner.dismissesOnSwipe = true
            infoBanner.show(duration: 2.0)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.hideHud()
        productMinutes.removeAll()
        prices.removeAll()
    }
    
    func dismissShop() {
        // this function is writen for UIBarbuttonItem when using modal present
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: button in cell
    func addPurchaseButtonInCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
        let price = prices[indexPath.row]
        let priceButton = UIButton(type: .custom)
        priceButton.frame = CGRect(x: UIScreen.main.bounds.size.width * 0.81, y: 7, width: 60, height: 30)
        priceButton.backgroundColor = .clear
        // priceButton.backgroundColor = UIColor.blue

        priceButton.layer.cornerRadius = 5
        priceButton.layer.borderWidth = 1
        priceButton.layer.borderColor = theme.buttonColor.cgColor
        
        priceButton.setTitle("$\(Double(price)/100)", for: .normal)
        priceButton.titleLabel?.font = priceButton.titleLabel?.font.withSize(14)
        priceButton.setTitleColor(theme.buttonColor, for:.normal )
        
        priceButton.addTarget(self, action: #selector(ShopTableViewController.payAlert(_:)), for: .touchUpInside)
        
        // tag is used to locate package info when purchasing
        priceButton.tag = price
        cell.addSubview(priceButton)
        
        if numDiscountAvailable > 0 {
            // add discount label
            let discountLabelWidth: CGFloat = 60
            let discountLabel = UILabel(frame: CGRect(x: priceButton.frame.origin.x - discountLabelWidth,
                                                      y: priceButton.frame.origin.y, width: discountLabelWidth, height: 30))
            discountLabel.text = "30% off!"
            discountLabel.font = discountLabel.font.withSize(14)
            cell.addSubview(discountLabel)
        }
    }
    
    // MARK: Table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if productMinutes.count != 0{
            return productMinutes.count + 1
        }
        else{
            return productMinutes.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("yes")
        if indexPath.row < productMinutes.count {
            print(indexPath.row)
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .value1, reuseIdentifier: "Cell")
            //cell.subviews.forEach({ $0.removeFromSuperview() })
            let product = productMinutes[indexPath.row]
            let price = prices[indexPath.row]
            //let theme = self.settingsVC.settings.theme
            cell.backgroundColor = theme.secondaryBackgroundColor
            cell.textLabel?.text = "\(product) mins package"
            cell.textLabel?.font = theme.font
            cell.textLabel?.textColor = UIColor.black
            // cell.detailTextLabel?.text = "$\(price/100).00"
            // cell.accessoryType = .disclosureIndicator
            cell.accessoryType = .none
            // to make it non selectable
            cell.selectionStyle = .none;
            if firstAppear == false {
                firstAppear = true
                addPurchaseButtonInCell(cell, atIndexPath: indexPath)
            }
            else{
                for view in cell.subviews {
                    if view is UIButton{
                        view.removeFromSuperview()
                    }
                }
                addPurchaseButtonInCell(cell, atIndexPath: indexPath)
            }

            return cell
        }
        else{
            print(indexPath.row)
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .value1, reuseIdentifier: "Cell")
            cell.imageView?.image = #imageLiteral(resourceName: "creditcard")
            cell.textLabel?.text = isPaymentCardPresent ? "Change your card" : "Add payment card"
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.10)
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor).isActive = true
        view.backgroundColor = theme.buttonColor
        
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
        let range = ("Balance: \(self.balance) minutes" as NSString).range(of: "Balance: \(self.balance) minutes"
        )
        textAfterIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.white , range: range)
        completeText.append(textAfterIcon)
        balanceLabel.textAlignment = .center;
        balanceLabel.attributedText = completeText;
        balanceLabel.frame = CGRect(x:0, y: 0, width: UIScreen.main.bounds.size.width*0.8, height: UIScreen.main.bounds.size.height * 0.10*0.5)
        balanceLabel.center = view.center
        //label.backgroundColor = UIColor.white
        
        view.addSubview(balanceLabel)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.size.height * 0.10
    }
    
    func payAlert(_ sender: UIButton) {
        if isPaymentCardPresent {
            updatePaymentMethod()
            print("which button is pressed \(sender.tag)")
            
            let title = "Confirm Purchase"
            let message = "Proceed to purchase package for \(sender.currentTitle!)?"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
            let amount:Int? = Int(sender.tag)
            alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: {action in self.payButton(amount!)}))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            // no payment method
            let alertView = UIAlertController(title: "No payment method", message: "There's no payment method linked to your card, please add a card before proceeding", preferredStyle: .alert)
            
            alertView.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            alertView.addAction(UIAlertAction(title: "Add card", style: .default, handler: { (_) in
                self.addCard()
            }))

            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    func updateCard() {
        self.addCard()
    }
    
    
    func payButton(_ amount: Int) {
        print("pay button clicked")
        print(uid)
        
        showHud(in: view, hint: "Purchasing")
        chargeUsingCustomerId(amount)
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
        
        self.isPaymentCardPresent = true
        
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
        
        // discount is available if discountrate < 1 and there are available discount for this user
        let isPriceAfterDiscount = (discountRate < 1 && numDiscountAvailable > 0)
        // here amount should be before discount

        ref?.child("users").child(uid).child("payments/charges/\(paymentId!)/content").setValue(["amount": amount,"discount": isPriceAfterDiscount ? 1 : 0])
        print("Done writing to db")
        
        // TODO: add listener
        // add loading page
        // display alert
        
        let postRef = ref?.child("users").child(uid).child("payments/charges").child(paymentId!).child("paymentDetail").child("status")
        
        _ = postRef?.observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? String
            // let status = postDict["status"] as? String ?? ""
            if (postDict != nil){
                
                if (postDict == "succeeded"){
                    // dismiss loading page
                    
                    //MKFullSpinner.hide()
                    self.ref?.child("users/\(self.uid)/balance").observe(DataEventType.value, with: { (snapshot) in
                        self.balance = (snapshot.value as? Int)!
                        self.tableView.reloadData()
                    }){ (error) in
                        //print(error.localizedDescription)
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        let okay = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alert.addAction(okay)
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    // if discount available, decrement discount
                    if self.numDiscountAvailable > 0 {
                        try! AppConfig.sharedInstance.decrementCountForConfigType(.ConfigTypeDiscountAvailability)
                    }
                    
                    self.hideHud()

                    // send alert
                    let title = "Payment Successed"
                    let message = "You have purchased \(self.product) package for $\(Double(amount)/100)"
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {(action) in
                        if self.isPurchasingBeforeReqeusting {
                            // if is presented modally before requesting tutor, want to dismiss self and let
                            // the summaryVC know about it
                            self.delegate?.didFinishPurchasingWith(status: true)
                            self.dismiss(animated: true, completion: nil)
                        }
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                } else {
                    print("postDict\(String(describing: postDict))")
                    
                    //MKFullSpinner.hide()
                    self.hideHud()
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
        if indexPath.row == productMinutes.count{
            updateCard()
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // detach all listener for db
        ref?.removeAllObservers()
    }
    
}
