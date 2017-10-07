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
    var balance: Int = 1
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
        
        getBalance()
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
    func getBalance(){
        let sid = EMClient.shared().currentUsername!
        let uidWithOne = "+1"+sid
        ref?.child("users/\(uidWithOne)/balance").observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot.value as! Int)
            self.balance = snapshot.value as! Int
            
        }) { (error) in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let okay = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(okay)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
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
        let minutes = Int(floor(Double(time)/60))
        timerLabel.text = String(minutes) + " min"
        if minutes >= self.balance{
            let alert = UIAlertController(title: "Session finished", message: "Your balance is 0", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Ok", style: .cancel, handler:{_ in self.endSession(minutes)})
            alert.addAction(okay)
            self.present(alert, animated: true, completion: nil)
        }
        
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
        time = Date().timeIntervalSince(beginTime)
        let sessionDuration = Int(ceil(Double(time)/60))
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Exit", style: UIAlertActionStyle.destructive, handler: {action in self.endSession(sessionDuration)}))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func endSession(_ duration: Int){
        //calculate time with ceil
        let ratingViewController = UIStoryboard(name: "Rating", bundle: nil).instantiateViewController(withIdentifier: "rateSession") as! RatingViewController
        ratingViewController.category = self.category
        ratingViewController.key = self.key
        removeTimerLable()
        //time = Date().timeIntervalSince(beginTime)
        //let sessionDuration = Int(ceil(Double(time)/60))
        //print(sessionDuration)
        self.ref?.child("Request/active/\(self.category)/\(self.key)").updateChildValues(["duration":duration])
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
        processSession()
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
        // create a new conversation, generate a random numerical id first
        let letters : NSString = "0123456789"
        let len = UInt32(letters.length)
        
        var newConversationID = ""
        
        for _ in 0..<CONVERSATION_ID_LENGTH {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            newConversationID += NSString(characters: &nextChar, length: 1) as String
        }

        // TODO: as new messageID tweak is found, consider rewrite this section of code
        let newConversation = chatManager?.getConversation(newConversationID, type: EMConversationTypeChat, createIfNotExist: true)

        // get all messages from current conversation
        let sessionEndTime = Int64(Date().timeIntervalSince1970) * 1000  // convert to millisecond
        let sessionStartTime = Int64(beginTime.timeIntervalSince1970 - 120) * 1000
        conversation?.loadMessages(from: sessionStartTime, to: sessionEndTime, count: MAX_MESSAGE_LOAD_COUNT, completion: { (messages, nil) in
            // copy all messages to new conversation
            if messages != nil {
                for case let message as EMMessage in messages! {
                    // change the message's conversation ID to new, so that old message will not be loaded when the same
                    // conversation ID comes again (because conversatoinID is essentially username, it'll show up again when
                    // connected with the same tutor)
                    let model = EaseMessageModel(message: message)
                    if model?.bodyType == EMMessageBodyTypeImage {
                        // if dealing with image, download them if not yet downloaded
                        let body = message.body as! EMImageMessageBody
                        if body.downloadStatus != EMDownloadStatusSuccessed {
                            EMClient.shared().chatManager.downloadMessageAttachment(message, progress: nil, completion: nil)
                        }
                    }
                    
                    message.conversationId = newConversationID
                    self.conversation.updateMessageChange(message, error: nil)
                }
            }
            
            // new message for ext
            // create thumbnail image
            let thumbnail = self.questionimage?.scaledImage(toSize:CGSize(width: 100, height: 50))
            let textMessageBody = EMTextMessageBody(text: "End of chat")
            let newMessage = EMMessage(conversationID: newConversationID,
                                       from: newConversationID,
                                       to: "Me",
                                       body: textMessageBody,
                                       ext: ["cat": self.category,
                                             "pic": UIImagePNGRepresentation(thumbnail!)?.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)])
            newMessage?.status = EMMessageStatusSucceed
            
            newConversation?.insert(newMessage, error: nil)
        })
        
        // remove the current conversation from database
        chatManager?.deleteConversation(conversation.conversationId, isDeleteMessages: false, completion: nil)
    }
}
