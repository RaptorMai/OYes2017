
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
        switch indexPath.section{
        // section 0
        case 0:
            if indexPath.row == 0{
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let controller = storyboard.instantiateViewController(withIdentifier: "MyProfileViewControllerTableViewController")
//                self.present(controller, animated: true, completion: nil)
                let profilePageVc = MyProfileViewControllerTableViewController()
                self.navigationController?.pushViewController(profilePageVc, animated: true)
                
            }
        // section 1
        case 1:
            break //TODO
        // section 2
        case 2:
            switch indexPath.row{
            // Help
            case 0:
                let openMainPageVc = OpenUrlViewController()
                openMainPageVc.url = "https://www.instasolve.ca/"
                self.navigationController?.pushViewController(openMainPageVc, animated: true)
            // Feedback
            case 1:
            
                let sendFeedbackVC = SendFeedbackController()
                //navigationController?.pushViewController(sendFeedbackVC, animated: false)
                self.present(sendFeedbackVC, animated: true, completion: nil)
                //self.present(sendFeedbackVC, animated: true, completion: nil)
            // Rate us
            case 2:
                break
            // Like us on Facebook
            case 3:
                openFacebookPage()
                tableView.deselectRow(at: indexPath, animated: true)
            default:break
            }
        // section 3
        case 3:
            tableView.deselectRow(at: indexPath, animated: true)
            createAlert()
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
    
    func presentSettingPage(){
        let settingVC = SettingsTableViewController()
        self.present(settingVC, animated: true, completion: nil)
    }
    
    func createAlert (){
        let alert = UIAlertController(title: "Log Out InstaSolve?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title:"Yes", style: UIAlertActionStyle.default, handler:{(action:UIAlertAction) in self.logoutAction()}))
        
        alert.addAction(UIAlertAction(title:"Cancel", style: UIAlertActionStyle.default, handler:nil))
        
        self.present(alert, animated: true, completion: nil)

        
        
    }
    
    
}
    

    

