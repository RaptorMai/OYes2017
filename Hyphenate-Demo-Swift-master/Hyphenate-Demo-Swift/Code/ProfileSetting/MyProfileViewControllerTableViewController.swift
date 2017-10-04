//
//  MyProfileViewControllerTableViewController.swift
//  ProfileSetting
//
//  Created by Yi Jerry on 2017-09-23.
//  Copyright © 2017 Yi Jerry. All rights reserved.
//

import UIKit

class MyProfileViewControllerTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table navigation bar
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tabBarController?.navigationItem.title = "My Profile"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        // Section: PROFILE
        case 0:
            return 2
        // Section: INFORMATION
        case 1:
            return 3
        default:
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Section: PROFILE
        if indexPath.section == 0{
            switch indexPath.row {
            // Profile Picture
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "profilePictureCell", for: indexPath) as! profilePictureTableViewCell
                //cell.profileImageView.image = UIImage(named: "jerryProfile")
                cell.profilePhotoLabel.text = "Profile Photo"
                return cell
            // Name
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath) as! nameTableViewCell
                cell.nameCellLabel.text = "Name"
                cell.userNameLabel.text = "JerryGor"
                return cell
            // Should Never Reach
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
                return cell
            }
        // Section: INFORMARION
        } else {
            switch indexPath.row {
            // Grade
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "gradeCell", for: indexPath) as! gradeTableViewCell
                cell.gradeCellLabel.text = "Grade"
                cell.userGraderLabel.text = "Gr.12"
                return cell
                
            // Email
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "emailCell", for: indexPath) as! emailTableViewCell
                cell.emailCellLabel.text = "Email"
                cell.userEmailLabel.text = "123@gmail.com"
                return cell
            // More
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "moreCell", for: indexPath) as! moreTableViewCell
                cell.moreCellLabel.text = "More"
                return cell
            // Should Never Reach
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileHeaderCell") as! profileHeaderTableViewCell
        switch section {
        case 0:
            cell.headerLabel.text = "PROFILE"
        case 1:
            cell.headerLabel.text = "INFORMATION"
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // change Height of Profile Picture Cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0 && indexPath.row == 0){
            return 80
        }
        return 40
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - NOTES
    /*
     - to make headers non sticky: go to main storyboard and chage tableview style to: group
 
    */

}
