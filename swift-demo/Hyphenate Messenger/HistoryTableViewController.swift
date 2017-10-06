/*****************************
 HistoryTableViewController.swift
 ****************************/
import UIKit
import Hyphenate

open class HistoryTableViewController: UITableViewController, EMChatManagerDelegate,ConversationListViewControllerDelegate, ConversationListViewControllerDataSource{
    
    var dataSource = [AnyObject]()
    var indexPathToDelete: IndexPath? = nil
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.navigationItem.title = "History"

        tableView.tableFooterView = UIView()

        definesPresentationContext = true
        
        let image = UIImage(named: "iconNewConversation")
        let imageFrame = CGRect(x: 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!)
        let newConversationButton = UIButton(frame: imageFrame)
        newConversationButton.setBackgroundImage(image, for: UIControlState())
        newConversationButton.addTarget(self, action: #selector(ConversationsTableViewController.composeConversationAction), for: .touchUpInside)
        newConversationButton.showsTouchWhenHighlighted = true
        let rightButtonItem = UIBarButtonItem(customView: newConversationButton)
        self.tabBarController?.navigationItem.rightBarButtonItem = rightButtonItem
        
        self.tableView.register(UINib(nibName: "ConversationTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataSource), name: NSNotification.Name(rawValue: kNotification_conversationUpdated), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataSource), name: NSNotification.Name(rawValue: kNotification_didReceiveMessages), object: nil)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "History"
        self.tabBarController?.tabBar.isHidden = false
        
        //reload button
        let image = UIImage(named: "iconNewConversation")
        let imageFrame = CGRect(x: 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!)
        let newConversationButton = UIButton(frame: imageFrame)
        newConversationButton.setBackgroundImage(image, for: UIControlState())
        newConversationButton.addTarget(self, action: #selector(ConversationsTableViewController.composeConversationAction), for: .touchUpInside)
        newConversationButton.showsTouchWhenHighlighted = true
        let rightButtonItem = UIBarButtonItem(customView: newConversationButton)
        self.tabBarController?.navigationItem.rightBarButtonItem = rightButtonItem
        
        reloadDataSource()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        
    }
    
    /// Reload table view data after processing
    ///
    /// The function removes sessions that does not have any messages inside,
    /// from DB. It then updates the table view UI
    func reloadDataSource(){
        self.dataSource.removeAll()
        
        var needRemoveConversations = [EMConversation]()
        if let conversations = EMClient.shared().chatManager.getAllConversations() as? [EMConversation]{
            for conversation: EMConversation in conversations {
                if conversation.latestMessage == nil {
                    needRemoveConversations.append(conversation)
                }
            }
        }
        if needRemoveConversations.count > 0 {
            EMClient.shared().chatManager.deleteConversations(needRemoveConversations, isDeleteMessages: true, completion: nil)
        }
        dataSource =  EMClient.shared().chatManager.getAllConversations() as [AnyObject]
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    func composeConversationAction() {
        let contactViewController = ComposeMessageTableViewController()
        let navigationController = UINavigationController(rootViewController: contactViewController)
        
        present(navigationController, animated: true, completion: nil)
    }
    
    open func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    // Mark: - Table view delegate
    // swipe to delete/unread
    open override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default,
                                                title: "Delete") { (action, indexPath) in
            // confirm delete conversation
            let alert = UIAlertController(title: "Confirm delete conversation",
                                          message: "Are you sure you want to permanentely delete this conversation?",
                                          preferredStyle: .actionSheet)
                                                    
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: self.handleDeleteSession)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            self.indexPathToDelete = indexPath
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true, completion: nil)
            })
        }
        
        let markAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal,
                                              title: "Mark as unread") { (action, indexPath) in
                                                let conversation = self.dataSource[indexPath.row] as! EMConversation
                                                let lastMessage = conversation.lastReceivedMessage()
                                                lastMessage?.isRead = false
                                                conversation.updateMessageChange(lastMessage, error: nil)
                                                DispatchQueue.main.async(execute: {
                                                    self.tableView.reloadData()
                                                })
        }
        return [deleteAction, markAction]
    }
    
    /// Handle deletion of session
    ///
    /// This function is called when user confirm row deletion in alert view, it'll remove the conversation from both data source and DB
    /// - Parameter alertAction: alertAction
    func handleDeleteSession(alertAction: UIAlertAction!) {
        if let indexPath = indexPathToDelete {
            let conversation = self.dataSource[indexPath.row] as! EMConversation
            let conversationID = conversation.conversationId
            EMClient.shared().chatManager.deleteConversation(conversationID, isDeleteMessages: true, completion: nil)
            // removing in data source as the data from EMClient is from local cache, the deletion of conversation might not have arrived yet
            self.dataSource.remove(at: indexPath.row)
            // remove the row with animation
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            indexPathToDelete = nil
        }
    }
    
    // MARK: - Table view data source
    
    open override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ConversationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ConversationTableViewCell
        
        let conversation = (dataSource[indexPath.row]) as! EMConversation
        
        if let sender = conversation.latestMessage?.from, let recepient = conversation.latestMessage?.to {
            cell.senderLabel.text = sender != EMClient.shared().currentUsername ? sender : recepient
        }
        
        if let latestMessage: EMMessage = conversation.latestMessage {
            let timeInterval: Double = Double(latestMessage.timestamp)
            let date = Date(timeIntervalSince1970:timeInterval)
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            let dateString = formatter.string(from: date)
            cell.timeLabel.text = dateString
            
            if let textMessageBody = latestMessage.body as? EMTextMessageBody {
                cell.lastMessageLabel.text = textMessageBody.text
            }
            else{
                cell.lastMessageLabel.text = "[image]"
            }
            
            if conversation.unreadMessagesCount > 0 && conversation.unreadMessagesCount < 100 {
                cell.badgeView.text = "\(conversation.unreadMessagesCount)"
            } else if conversation.unreadMessagesCount > 0 {
                cell.badgeView.text = ".."
            } else {
                cell.badgeView.isHidden = true
            }
        }
        
        return cell
    }
    
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let conversation:EMConversation = dataSource[(indexPath as NSIndexPath).row] as? EMConversation {
            //let sessionController = SessionTableViewController(conversationID: conversation.conversationId, conversationType: conversation.type)
            let timeStamp = ["SessionId":String(Date().ticks)]
            let sessionController = SessionTableViewController(conversationID: conversation.conversationId, conversationType: conversation.type, initWithExt: timeStamp)
            
            print(conversation.conversationId)
            
            sessionController?.title = conversation.latestMessage.from
            sessionController?.hidesBottomBarWhenPushed = true
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
            //self.navigationController!.pushViewController(sessionController!, animated: true)
            self.tabBarController?.navigationController?.pushViewController(sessionController!, animated: true)
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "setupUnreadMessageCount"), object: nil)
        self.tableView.reloadData()
    }
    
    
    open func conversationListViewController(_ conversationListViewController:ConversationsTableViewController, didSelectConversationModel conversationModel: AnyObject){
    }
    
    open func conversationListViewController(_ conversationListViewController: ConversationsTableViewController, modelForConversation conversation: EMConversation) -> AnyObject
    {
        return String() as AnyObject
    }
    
    open func conversationListViewController(_ conversationListViewController:ConversationsTableViewController, latestMessageTitleForConversationModel conversationModel: AnyObject) -> String
    {
        return String()
    }
    
    open func conversationListViewController(_ conversationListViewController: ConversationsTableViewController, latestMessageTimeForConversationModel conversationModel: AnyObject) -> String
    {
        return String()
    }
    
    @nonobjc open func messagesDidReceive(_ aMessages: [AnyObject]!) {
        HyphenateMessengerHelper.sharedInstance.messagesDidReceive(aMessages)
    }
    
    @nonobjc open func didReceiveMessages(_ aMessages: [AnyObject]!) {
        HyphenateMessengerHelper.sharedInstance.messagesDidReceive(aMessages)
    }
    
}

