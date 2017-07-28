
import UIKit
import Hyphenate

class ChatTableViewController: EaseMessageViewController,EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource,EMClientDelegate {
    
    var timerLabel = UILabel()
    var endSessionButton = UIButton(type: UIButtonType.custom)
    var navigationBar = UINavigationBar()
    var time = 1
    var timer:Timer?
    
    var dismissable = false
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.showRefreshHeader = true
        self.delegate = self
        self.dataSource = self
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        self.view.addSubview(navBar);
        let navItem = UINavigationItem(title: "");
        navBar.setItems([navItem], animated: false);
        
        if dismissable == true {
            let rightButtonItem:UIBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ChatTableViewController.cancelAction))
            navigationItem.leftBarButtonItem = rightButtonItem
        }
        
        /* ming: added timer UILabel ********/
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
        
        /* ming: added end session button ***/
        endSessionButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let backIcon = UIImage(named: "back.png")
        endSessionButton.setImage(backIcon, for: .normal)
        endSessionButton.contentVerticalAlignment = .fill
        endSessionButton.contentHorizontalAlignment = .fill
        endSessionButton.center = CGPoint(x: 30, y: 40)
        endSessionButton.addTarget(self, action: #selector(exitAlert), for: .touchUpInside)
        self.view.addSubview(endSessionButton)
        /************************************/
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "kNotification_unreadMessageCountUpdated"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeTimerLable()
        HyphenateMessengerHelper.sharedInstance.chatVC = nil
    }
    
    func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Mark: EaseMessageViewControllerDelegate
    
    func messageViewController(_ viewController: EaseMessageViewController!, canLongPressRowAt indexPath: IndexPath!) -> Bool {
        return false
    }
    
    //TODO: add tap avatar function for rating the tutor
//    func messageViewController(_ viewController: EaseMessageViewController!, didSelectAvatarMessageModel messageModel: IMessageModel!) {
//        
//        let profileController = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController() as! ProfileViewController
//        profileController.username = messageModel.message.from
//        self.navigationController!.pushViewController(profileController, animated: true)
//    }
    
    // Mark: EaseMessageViewControllerDataSource

    func messageViewController(_ viewController: EaseMessageViewController!, modelFor message: EMMessage!) -> IMessageModel! {
       
        let model = EaseMessageModel(message: message)
        model?.avatarImage = UIImage(named: "placeholder")
        model?.failImageName = "imageDownloadFail";
        
        return model;
    }
    
    
    // Ming: functions for timer
    func updateTimer() {
        //timerLabel.text = String(time) + " min"
        timerLabel.text = String(Int(ceil(Double(time)/60))) + " min"
        time += 1 //+1s
        //check balance with server every minute
        
    }
    
    private func removeTimerLable() {
        time = 0
        timerLabel.text = ""
        timerLabel.removeFromSuperview()
        timer?.invalidate()
        timer = nil
    }
    
    func exitAlert(){
        let title = "Exit Session"
        let message = "Press Exit to end current session."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Exit", style: UIAlertActionStyle.destructive, handler: {(action) in self.dismiss(animated: true, completion: nil)}))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
    
}
