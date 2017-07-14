
import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //HomeVC
        let homeViewController: HomeViewController = HomeViewController();
        let homeRootViewController:UINavigationController = UINavigationController(rootViewController: homeViewController)
        //HistoryVC
        let historyViewController:ConversationsTableViewController = ConversationsTableViewController()
        let historyRootViewController:UINavigationController = UINavigationController(rootViewController: historyViewController)
        //ShopVC
        let shopViewController:ShopTableViewController = ShopTableViewController()
        let shopRootViewController:UINavigationController = UINavigationController(rootViewController: shopViewController)
        //SettingVC
        let settingsViewController:SettingsTableViewController = SettingsTableViewController()
        let settingsRootViewController:UINavigationController = UINavigationController(rootViewController: settingsViewController)

        self.setViewControllers([homeRootViewController, historyRootViewController, shopRootViewController, settingsRootViewController], animated: true)
        
        let homeTabItem:UITabBarItem = self.tabBar.items![0]
        homeTabItem.title = "Home"
        homeTabItem.image = UIImage(named:  "HomeIcon")
        //contactsTabItem.selectedImage = UIImage(named:  "contactsTab_selected")
        //contactsTabItem.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0);
        
        let historyTabItem:UITabBarItem = self.tabBar.items![1]
        historyTabItem.title = "History"
        historyTabItem.image = UIImage(named:  "HistoryIcon")
        //conversationsTabItem.selectedImage = UIImage(named:  "chatsTab_selected")
        //conversationsTabItem.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0);
        
        //Ming: added session tab for past sessions
        let shopTabItem:UITabBarItem = self.tabBar.items![2]
        shopTabItem.title = "Shop"
        shopTabItem.image = UIImage(named: "ShopIcon")
        //sessionsTabItem.selectedImage = UIImage(named: "sessionsTab_selected")
        //sessionsTabItem.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0)

        let settingsTabItem:UITabBarItem = self.tabBar.items![3]
        settingsTabItem.title = "Settings"
        settingsTabItem.image = UIImage(named:  "SettingsIcon")
        //settingsTabItem.selectedImage = UIImage(named:  "settingsTab_selected")
        //settingsTabItem.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0);

        UITabBar.appearance().tintColor = UIColor.hiPrimary()
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.updateUnreadMessageCount), name: NSNotification.Name(rawValue: "kNotification_unreadMessageCountUpdated"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUnreadMessageCount()
    }

    func updateUnreadMessageCount() {
        let conversations: [EMConversation] = EMClient.shared().chatManager.getAllConversations() as! [EMConversation]
        var unreadCount: Int = 0
        conversations.forEach { (conversation) in
            unreadCount = unreadCount + Int(conversation.unreadMessagesCount)
        }
        
        if unreadCount > 0 {
            self.tabBar.items![1].badgeValue = "\(unreadCount)"
        } else {
            self.tabBar.items![1].badgeValue = nil
        }
        
        UIApplication.shared.applicationIconBadgeNumber = unreadCount
    }
}

