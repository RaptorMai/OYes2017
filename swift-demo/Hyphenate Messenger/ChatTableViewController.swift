 
import UIKit
import Hyphenate
import Firebase

protocol DismissProtocol {
    func dismissParentVC()
}

/**
 
 Class used to show conversation view
 
 Most features and functionalities are from:
 EaseMessageViewController,EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource
 
 These are from EaseUI written in Objective C
 */

class ChatTableViewController: EaseMessageViewController,EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource,EMClientDelegate, DismissProtocol {
    let CONVERSATION_ID_LENGTH: UInt32 = 10
    let MAX_MESSAGE_LOAD_COUNT: Int32 = 500
    
    var timerLabel = UILabel()
    //var endSessionButton = UIButton(type: UIButtonType.custom)
    var navigationBar = UINavigationBar()
    var time: Double = 0
    var timer:Timer?
    var category: String = ""
    var key: String = ""
    var beginTime = Date()
    //let calendar = Calendar.current

    //questionimage and question description are automatically sent when the view loads. didFirstMessageSend keeps track of if the first message was sent.
    var questionimage: UIImage?
    var questiondescription: String?
    var didFirstMessageSend = false
 
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
        navigationController?.navigationBar.barStyle = .default
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
        
        if didFirstMessageSend == false {
            sendImageMessage(questionimage)
            if questiondescription != nil{
                sendTextMessage(questiondescription)
            }
            didFirstMessageSend = true
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
        //timerLabel.text = String(Int(floor(Double(time)))) + " min"
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
        self.ref?.child("Request/active/\(self.category)/\(self.key)").updateChildValues(["duration":sessionDuration])
        ratingViewController.delegate = self
        self.present(ratingViewController, animated: true)
        
//        let newConvId: String = (self.conversation.conversationId + String(Date().ticks))
//        self.conversation.conversationId = newConvId
        processSession()
    }
    
    func endSessionfromAppTermination(){
        // get time of chat session
        time = Date().timeIntervalSince(beginTime)
        let sessionDuration = Int(ceil(Double(time)/60))
        //TODO: charge time to balance here
        print(sessionDuration)
        //store duration
        self.ref?.child("Request/active/\(self.category)/\(self.key)").updateChildValues(["duration":sessionDuration])
        
        // add rating to tutor
        self.ref?.child("Request/active/\(self.category)/\(self.key)").updateChildValues(["rate": 5.0])
        //calldismiss to dismiss chatVC
        dismissParentVC()
    }
    
    func dismissParentVC() {
        //Dismiss Keyboard
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        //Dismiss Chat
        dismiss(animated: true, completion: nil)
    }

    func processSession() {
        // after a session ends, get the last session and copies all messages over to a new session
        let chatManager = EMClient.shared().chatManager

        // create a new conversation
        let newConversationID = String(Int(arc4random_uniform(CONVERSATION_ID_LENGTH)))
        let newConversation = chatManager?.getConversation(newConversationID, type: EMConversationTypeChat, createIfNotExist: true)

        // get all messages from current conversation
        let sessionEndTime = Int64(Date().timeIntervalSince1970) * 1000  // convert to millisecond
        let sessionStartTime = Int64(beginTime.timeIntervalSince1970) * 1000
        conversation?.loadMessages(from: sessionStartTime, to: sessionEndTime, count: MAX_MESSAGE_LOAD_COUNT, completion: { (messages, nil) in
            // copy all messages to new conversation
            if messages != nil {
                for case let message as EMMessage in messages! {
                    let newMessage = EMMessage(conversationID: newConversationID,
                                               from: message.from,
                                               to: message.to,
                                               body: message.body,
                                               ext: nil)
                    newMessage?.direction = message.direction
                    newMessage?.status = message.status
                    newConversation?.insert(newMessage, error: nil)
                }
            }
            newConversation?.lastReceivedMessage()?.from = newConversationID
        })
        
        // remove the current conversation from database
        chatManager?.deleteConversation(conversation.conversationId, isDeleteMessages: true, completion: nil)
    }
}
