//
//  SettingsVC.swift
//  TutorApp
//
//  Created by devuser on 2017-08-13.
//  Copyright © 2017 sul. All rights reserved.
//

import UIKit
import Firebase
import Hyphenate

class SettingsVC: UITableViewController {
/*
    @IBAction func LogOut(_ sender: Any) {
        try! Auth.auth().signOut()
        let LoginScreenNC = UINavigationController(rootViewController: LaunchViewController())
        LoginScreenNC.navigationBar.barStyle = .blackTranslucent
        present(LoginScreenNC, animated: true, completion: nil)
    }
    
*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        self.tableView.backgroundColor = UIColor.init(hex: "F0EFF5")
        self.tableView.separatorInset = .zero
        self.tableView.layoutMargins = .zero
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(UINib(nibName: "SwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "switchCell")
        self.tableView.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "labelCell")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let data = [[[#imageLiteral(resourceName: "Profile"),"Profile"]], [[#imageLiteral(resourceName: "Bank"),"Bank account"], [#imageLiteral(resourceName: "Cash"),"Cash out"]], [[#imageLiteral(resourceName: "Help"),"Help"], [#imageLiteral(resourceName: "Feedback"),"Feedback"], [#imageLiteral(resourceName: "About"),"About"]],[["Log out"]]]
    
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
            //let proVC = SettingsAboutTableViewController()
            //navigationController?.pushViewController(settingsAboutVC, animated: true)
            logoutAction()
            
        case 1:
            //let settingsNotificationVC = SettingsNotificationTableViewController()
            //navigationController?.pushViewController(settingsNotificationVC, animated: true)
            logoutAction()
        default:break
            
        }
    }

    func logoutAction() {
        
        try! Auth.auth().signOut()
        
        //TODO add hyphenate logout
        EMClient.shared().logout(true) { (error) in
            if let _ = error {
                let alert = UIAlertController(title:"Sign Out error", message: "Please try again later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "ok"), style: .cancel, handler: nil))
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            } else {
                let LoginScreenNC = UINavigationController(rootViewController: LaunchViewController())
                LoginScreenNC.navigationBar.barStyle = .blackTranslucent
                self.present(LoginScreenNC, animated: true, completion: nil)
                
            }
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
