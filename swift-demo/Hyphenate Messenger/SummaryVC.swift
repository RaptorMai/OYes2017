import UIKit
import Firebase
import FirebaseDatabase
import Alamofire
import IHKeyboardAvoiding

enum TutorStatus: Int {
    case ready = 2
    case preparing = 1
}

class SummaryVC: UIViewController, UITextViewDelegate, ShopPurchaseStatusDelegate {
    //This class is a viewcontroller that gathers and displays the data inputted by the user about their question. This viewcontroler allows the user to double check the data, enter a description of their question, and send the request for help to our platform.
    
    var categorytitle: String = ""
    var ref: DatabaseReference!
    var key: String?
    var keyboardDisplayed = false
    var keyboardheight:CGFloat = 0
    var sid: String?
    var balance:Int = 0
    var threshold = 5
    var connected = false
    var ready = false
    var storyBoard = UIStoryboard(name: "TutorConnected", bundle: nil)
    var tcVC:TutorConnectedVC?
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
        tcVC = storyBoard.instantiateViewController(withIdentifier: "TutorConnected") as! TutorConnectedVC
        KeyboardAvoiding.avoidingView = self.view
        //        view.backgroundColor = UIColor.init(red: 239, green: 239, blue: 255, alpha: 1)
        view.backgroundColor = UIColor.init(hex: "EFEFF4")
        ref = Database.database().reference()
        self.key = self.ref?.child("request/active").childByAutoId().key
        //        navigationController?.navigationBar.tintColor = UIColor.black
        //        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        sid = EMClient.shared().currentUsername!
        //getBalance()
        self.balance = UserDefaults.standard.integer(forKey: DataBaseKeys.balanceKey)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.ref?.removeAllObservers()
        //  NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
    
/*    func getBalance(){
        let uidWithOne = "+1"+sid!
        ref?.child("users/\(uidWithOne)/balance").observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot.value as! Int)
            self.balance = snapshot.value as! Int
            
        }) { (error) in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let okay = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(okay)
            self.present(alert, animated: true, completion: nil)
        }
    }*/
    
    //flag variable monitors which screen we are on. States: -1 = not set, 0 = tutor connecting screen, 1 = tutor connected screen
    var flag = -1
    
    func presentShopView() {
        // present modally the shop VC for purchasing minutes
        let shopViewController = ShopTableViewController()
        shopViewController.delegate = self
        
        let shopNavVC = UINavigationController(rootViewController: shopViewController)
        shopNavVC.navigationBar.isTranslucent = false
        shopNavVC.navigationBar.topItem?.title = "Shop"
        
        // dismissShop is defined in ShopTableViewController, just to dissmiss modal present
        shopNavVC.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: shopViewController, action: Selector(("dismissShop")))
        shopNavVC.navigationBar.topItem?.leftBarButtonItem?.tintColor = UIColor(hex: "2EA2DC")
        
        shopViewController.isPurchasingBeforeReqeusting = true
        self.present(shopNavVC, animated: true, completion: nil)
    }
    
    func requestHelpPressed(button: UIButton) {
        
        let time = Date().timeIntervalSince1970
        if self.balance < self.threshold && self.balance > 0{
            let alertController = UIAlertController(title: "Warning", message:
                "Your balance is less than \(self.threshold) mins. Your session will terminate when your balance is 0 ", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "Purchase minutes", style: UIAlertActionStyle.default, handler: { _ in
                self.presentShopView()
            }))
            
            alertController.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: {_ in
                self.requestTutor(time)
            }))
            
            present(alertController, animated: true, completion: nil)
        } else if self.balance <= 0 {
            let alertController = UIAlertController(title: "Warning", message:
                "Your balance is 0", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "Purchase minutes", style: UIAlertActionStyle.default, handler: { _ in
                self.presentShopView()
            }))
             present(alertController, animated: true, completion: nil)
        } else {
            // if the balance is sufficient, just request
            requestTutor(time)
        }
    }
    
    /// Call this function to request a tutor
    func requestTutor(_ time: TimeInterval) {
        //check if keyboard is displayed and if it is then dismiss before continuing
        dismissKeyboard()
        //Check if description was entered. If a description was not entered modify text uploaded to database.
        if self.questionDescription.text == "Add Description Here..." {
            self.questionDescription.text = "No Description Available"
        }
        //write question to firebase
        var data = Data()
        data = UIImageJPEGRepresentation(questionPic.image!, 0.8)!
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let spinner = MKFullSpinner.show("Uploading question...", view: self.view)
        self.flag = 0
        
        //let label = createlabel()
        //self.view.addSubview(label)
        //setuplabel(label: label)
        let button = UIButton(frame: CGRect(x: 0, y: 20, width: 100, height: 50))
        button.setTitle("Cancel", for: .normal)
        button.addTarget(self, action: #selector(self.cancelAction), for: .touchUpInside)
        self.view.addSubview(button)
        
        uploadPicture(data, completion:{ (url) -> Void in
            spinner.title = "Your tutor is on the way"
            let addRequest = ["sid": self.sid!, "picURL":url!, "category": self.categorytitle, "description":
                self.questionDescription.text as String, "status": 0, "qid": self.key!, "tid":"", "duration": "", "rate":"", "time":time] as [String : Any]
            self.ref?.child("Request/active/\(self.categorytitle)/\(String(describing: self.key!))").setValue(addRequest)
            //label.removeFromSuperview()
        })
        
        //handle is the observer, used to remove observer
        var handle:UInt = 0
        handle = (self.ref?.child("Request/active/\(self.categorytitle)/\(String(describing: self.key!))/status").observe(DataEventType.value, with: { (snapshot) in
            if let status = snapshot.value as? Int{
                //if status is 1, tutor is connected, push tutorConnectedVC
                if status == TutorStatus.preparing.rawValue && !self.connected{
                    self.connected = true
                    self.ref?.removeObserver(withHandle: handle)
                    //get the tutor id, used to start chat
                    self.ref?.child("Request/active/\(self.categorytitle)/\(String(describing: self.key!))/tid").observeSingleEvent(of: .value, with: { (snapshot) in
                        if let tid = snapshot.value as? String{
                            //push tutorconnectedVC
                            MKFullSpinner.hide()
                            self.tcVC?.questionDescription = self.questionDescription.text
                            self.tcVC?.questionImage = self.questionPic.image
                            self.tcVC?.category = self.categorytitle
                            self.tcVC?.qid = String(describing: self.key!)
                            self.tcVC?.tid = tid
                            self.navigationController?.pushViewController(self.tcVC!, animated: true)
                        }
                        
                    }){ (error) in
                        print(error.localizedDescription)
                    }
                }
                //check if status is 2, if 2, tutor is ready to chat, push chatVC
                else if status == TutorStatus.ready.rawValue  && !self.ready{
                    self.ready = true
                    //use this flag in tutorconnectedVC to show tutor is ready can push chatVC
                    self.tcVC?.didTutorReady = true
                    
                    /*self.ref?.removeObserver(withHandle: handle)
                    self.ref?.child("Request/active/\(self.categorytitle)/\(String(describing: self.key!))/tid").observeSingleEvent(of: .value, with: { (snapshot) in
                        ///get the tutor id, used to start chat
                        if let tid = snapshot.value as? String{
                            self.startChatting(tid: tid, image: self.questionPic.image!, description: self.questionDescription.text!)
                        }
                        
                    }){ (error) in
                        print(error.localizedDescription)
                    }*/
                }
            }
            
        }){ (error) in
            print(error.localizedDescription)
            })!
    }
    
    func startChatting(tid: String, image: UIImage, description: String){
        let timeStamp = ["SessionId":String(Date().ticks)]
        let sessionController = ChatTableViewController(conversationID: tid, conversationType: EMConversationTypeChat, initWithExt: timeStamp)
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
        Alamofire.request(urlForNetworkAPI(.cancel)!, method:.get, parameters: parameters, encoding: URLEncoding.default)
            .responseString { response in
                print(response.result.value!)
                
        }
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        sender.removeFromSuperview()
        MKFullSpinner.hide()
        self.flag = -1
    }
    
    ///Use onDisconnect class to cancel question if the app is terminated during waiting
    func cancelFromAppTermination(){
        // This function is called when a cancel order needs to be put through because the app is terminated. It is the same function as cancel action but deleted one line of code "sender.removeFromSuperview()" since there is no sender.
        self.ref?.child("Request/active/\(self.categorytitle)/\(String(describing: self.key!))").onDisconnectRemoveValue()

    }
    
    func uploadPicture(_ data: Data, completion:@escaping (_ url: String?) -> ()) {
        let storageRef = Storage.storage().reference()
        storageRef.child("image/\(self.categorytitle)/\(self.key!)").putData(data, metadata: nil){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                
            } else {
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
    
    let categoryLabelScaleFactor:CGFloat = 0.08
    
    func setupCategoryLabel() {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        categoryLabel.heightAnchor.constraint(equalToConstant: screenHeight*categoryLabelScaleFactor).isActive = true
        
        categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: questionPic.bottomAnchor, constant: 12).isActive = true
        categoryLabel.text = "    Category:"
    }
    
    let subjectLabelWidthScaleFactor:CGFloat = 0.6

    func setupSubjectLabel() {
        subjectLabel.translatesAutoresizingMaskIntoConstraints = false
        subjectLabel.widthAnchor.constraint(equalToConstant: screenWidth * subjectLabelWidthScaleFactor).isActive = true
        subjectLabel.heightAnchor.constraint(equalToConstant: screenHeight*categoryLabelScaleFactor).isActive = true
        
//        subjectLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subjectLabel.rightAnchor.constraint(equalTo: categoryLabel.rightAnchor, constant: -10).isActive = true
//        subjectLabel.topAnchor.constraint(equalTo: questionPic.bottomAnchor, constant: 15).isActive = true
        subjectLabel.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor, constant: 0).isActive = true
        subjectLabel.text = "\(categorytitle)"
        subjectLabel.minimumScaleFactor = 0.5
        subjectLabel.adjustsFontSizeToFitWidth = true
        subjectLabel.sizeToFit()
    }
    
    let descriptionBoxScaleFactor:CGFloat = 0.25
    
    func setupQuestionDescription() {
        questionDescription.translatesAutoresizingMaskIntoConstraints = false
        questionDescription.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        questionDescription.heightAnchor.constraint(equalToConstant: screenHeight*descriptionBoxScaleFactor).isActive = true
        
        questionDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        questionDescription.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10).isActive = true
        questionDescription.text = placeholdertext
        questionDescription.delegate = self
    }
    
    let nextButtonScaleFactor:CGFloat = 0.08
    
    func setupNextButton() {
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: screenHeight*nextButtonScaleFactor).isActive = true
        
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
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text == "")
        {
            textView.text = placeholdertext
            textView.textColor = .lightGray
        }
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
    
    
    
    func keyboardWillHide(notification: NSNotification) {
        print("hide")
        self.view.frame.origin.y = 0
        keyboardheight = 0
        keyboardDisplayed = false
    }
    
    // MARK: ShopViewDelegate
    func didFinishPurchasingWith(status succ: Bool) {
        if succ {
            let time = Date().timeIntervalSince1970
            requestTutor(time)
        }
    }
}


