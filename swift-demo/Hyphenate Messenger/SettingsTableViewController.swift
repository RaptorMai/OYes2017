
import UIKit

class SettingsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.title = "Settings"
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        self.tableView.backgroundColor = UIColor.init(hex: "F0EFF5")
        self.tableView.separatorInset = .zero
        self.tableView.layoutMargins = .zero
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(UINib(nibName: "SwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "switchCell")
        self.tableView.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "labelCell")
        

        
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Settings"
    }
    
    // MARK: - Table view data source
    
    let data = [[[#imageLiteral(resourceName: "profile"),"Profile"]], [[#imageLiteral(resourceName: "balance"),"My balance"], [#imageLiteral(resourceName: "-points"),"My points"]], [[#imageLiteral(resourceName: "HelpIcon"),"Help"], [#imageLiteral(resourceName: "Feedback"),"Feedback"], [#imageLiteral(resourceName: "Rate"),"Rate us"], [#imageLiteral(resourceName: "FaceBook"),"Like us on Facebook"]],[["Log out"]]]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section != 3{
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
            let settingsAboutVC = SettingsAboutTableViewController()
            navigationController?.pushViewController(settingsAboutVC, animated: true)
            
        case 1:
            let settingsNotificationVC = SettingsNotificationTableViewController()
            navigationController?.pushViewController(settingsNotificationVC, animated: true)
        case 2:
            let sendFeedbackVC = SendFeedbackController()
            navigationController?.pushViewController(sendFeedbackVC, animated: false)
        case 3:
            openFacebookPage()
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
    
    // MARK: - Functions
    func openFacebookPage() {
        let page = "https://www.facebook.com/InstaSolve/"
        UIApplication.shared.openURL(NSURL(string: page)! as URL)
    }
    
}
