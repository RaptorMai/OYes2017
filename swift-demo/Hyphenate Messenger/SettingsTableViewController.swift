
import UIKit
import Firebase
import FirebaseDatabase

class SettingsTableViewController: UITableViewController {
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Database
        ref = Database.database().reference()
        var uid = "+1" + EMClient.shared().currentUsername!
        
        self.tabBarController?.navigationItem.title = "Settings"
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        self.tableView.backgroundColor = UIColor.init(hex: "F0EFF5")
        self.tableView.separatorInset = .zero
        self.tableView.layoutMargins = .zero
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(UINib(nibName: "SwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "switchCell")
        self.tableView.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "labelCell")
        self.tableView.register(UINib(nibName: "ConversationTableViewCell", bundle: nil), forCellReuseIdentifier: "conversationCell")
       
        

        
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Settings"
        self.tabBarController?.tabBar.isHidden = false
    }
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Table view data source
    
    let data = [[[#imageLiteral(resourceName: "profile"),"Profile"]], [[#imageLiteral(resourceName: "balance"),"My balance"], [#imageLiteral(resourceName: "-points"),"My points"]], [[#imageLiteral(resourceName: "HelpIcon"),"Help"], [#imageLiteral(resourceName: "Feedback"),"Feedback"], [#imageLiteral(resourceName: "Rate"),"Rate us"], [#imageLiteral(resourceName: "FaceBook"),"Like us on Facebook"]],[["Log out"]]]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0 {
            return 100
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            // My Profile TODO: don't use conversation table view cell, better make a new one
            let cell:ConversationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as! ConversationTableViewCell
            cell.senderLabel.text = "Jerry"
            cell.badgeView.isHidden = true
            cell.timeLabel.isHidden = true
            cell.senderImageView.image = UIImage(named: "jerryProfile")
            cell.lastMessageLabel.isHidden = true
            return cell
        }
        else if indexPath.section < 3 {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = self.data[indexPath.section][indexPath.row][1] as? String
            cell.imageView?.image = self.data[indexPath.section][indexPath.row][0] as? UIImage
            
            cell.accessoryType = .disclosureIndicator
            return cell}
        else{
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = self.data[indexPath.section][indexPath.row][0] as? String
            cell.textLabel?.textAlignment = .center
            return cell
            
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            // My Profile
            let StoryBoard = UIStoryboard(name:"ProfileMain",bundle:nil)
            let myProfileVC = StoryBoard.instantiateViewController(withIdentifier: "myProfileVC") 

            tabBarController?.navigationController?.pushViewController(myProfileVC, animated: true)
        case 1:
            let settingsAboutVC = SettingsAboutTableViewController()
            navigationController?.pushViewController(settingsAboutVC, animated: true)
            
        case 2:
            let settingsNotificationVC = SettingsNotificationTableViewController()
            navigationController?.pushViewController(settingsNotificationVC, animated: true)
        default:break
            
        }
    }
    
    func logoutAction() {
        EMClient.shared().logout(false) { (error) in
            if let _ = error {
                let alert = UIAlertController(title:"Sign Out error", message: "Please try again later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .cancel, handler: nil))
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            } else {
                let loginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginScene")
                UIApplication.shared.keyWindow?.rootViewController = loginController
                
            }
        }
    }
    
}
