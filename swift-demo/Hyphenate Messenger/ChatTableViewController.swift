
import UIKit
import Hyphenate
import Firebase

protocol DismissProtocol {
    func dismissParentVC()
}


class ChatTableViewController: EaseMessageViewController,EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource,EMClientDelegate, DismissProtocol {
    
    var timerLabel = UILabel()
    //var endSessionButton = UIButton(type: UIButtonType.custom)
    var navigationBar = UINavigationBar()
    var time: Double = 0
    var timer:Timer?
    var category: String = ""
    var key: String = ""
    var beginTime = Date()
    //let calendar = Calendar.current

    var ref: DatabaseReference!
   
    
    var dismissable = false
    override func viewDidLoad() {
        super.viewDidLoad()

        self.showRefreshHeader = true
        self.delegate = self
        self.dataSource = self
        self.ref = Database.database().reference()
        
        /* end session button*/
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationItem.title = ""
        let endSessionButton: UIBarButtonItem = UIBarButtonItem.init(title: "End Session", style: .plain, target: self, action: #selector(self.exitAlert))
        endSessionButton.tintColor = UIColor.red
        self.navigationItem.leftBarButtonItem = endSessionButton
        
        /* added timer UILabel ********/
        timerLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        timerLabel.font = UIFont.systemFont(ofSize: 20)
        timerLabel.adjustsFontSizeToFitWidth = true
        timerLabel.textColor = .red
        timerLabel.center = CGPoint(x: self.view.frame.width - 50, y: 40)
        timerLabel.textAlignment = .center
        self.view.addSubview(timerLabel)
        view.bringSubview(toFront: timerLabel)
        timerLabel.text = String(time) + " min"
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        self.navigationItem.titleView = timerLabel
        
        if dismissable == true {
            let rightButtonItem:UIBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ChatTableViewController.cancelAction))
            navigationItem.leftBarButtonItem = rightButtonItem
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "kNotification_unreadMessageCountUpdated"), object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //removeTimerLable()
        HyphenateMessengerHelper.sharedInstance.chatVC = nil
    }
    
    func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Mark: EaseMessageViewControllerDelegate
    
    func messageViewController(_ viewController: EaseMessageViewController!, canLongPressRowAt indexPath: IndexPath!) -> Bool {
        return false
    }

    func messageViewController(_ viewController: EaseMessageViewController!, modelFor message: EMMessage!) -> IMessageModel! {
       
        let model = EaseMessageModel(message: message)
        model?.avatarImage = UIImage(named: "placeholder")
        model?.failImageName = "imageDownloadFail";
        
        return model;
    }
    
    
    // Ming: functions for timer
    func updateTimer() {
        //display time with floor
        time = Date().timeIntervalSince(beginTime)
        timerLabel.text = String(Int(floor(Double(time)/60))) + " min"

        //TODO: check balance with server every minute, cut session if fund not enough
        
    }
    
    private func removeTimerLable() {
        timerLabel.text = ""
        timerLabel.removeFromSuperview()
        timer?.invalidate()
        timer = nil
    }
    
    func exitAlert(){
        let title = "Exit Session"
        let message = "Press Exit to end current session."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Exit", style: UIAlertActionStyle.destructive, handler: {action in self.endSession()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func endSession(){
        
        //calculate time with ceil
        let ratingViewController = UIStoryboard(name: "Rating", bundle: nil).instantiateViewController(withIdentifier: "rateSession") as! RatingViewController
        ratingViewController.category = self.category
        ratingViewController.key = self.key
        removeTimerLable()
        time = Date().timeIntervalSince(beginTime)
        let sessionDuration = Int(ceil(Double(time)/60))
        //TODO: charge time to balance here
        print(sessionDuration)
        self.ref?.child("Request/active/\(self.category)/\(self.key)").updateChildValues(["duration":sessionDuration ])
        ratingViewController.delegate = self
        self.present(ratingViewController, animated: true)
        
//        let newConvId: String = (self.conversation.conversationId + String(Date().ticks))
//        self.conversation.conversationId = newConvId
    }
    
    func dismissParentVC() {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}
