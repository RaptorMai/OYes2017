//
//  MyProfileViewControllerTableViewController.swift
//  ProfileSetting
//
//  Created by Yi Jerry on 2017-09-23.
//  Copyright © 2017 Yi Jerry. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class MyProfileViewControllerTableViewController: UITableViewController{
    
    // MARK: - Properties
    var ref = Database.database().reference()
    var uid = "+1" + EMClient.shared().currentUsername!

    // MARK: - Override Functions

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table navigation bar
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // color of the back button
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.tableView.reloadData()
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
                self.ref.child("users").child(uid).child("profilepicURL").observeSingleEvent(of: .value, with: {(snapshot) in
                    if snapshot.exists(){
                        let val = snapshot.value as? String
                        if (val == nil){
                            cell.profileImageView.image = #imageLiteral(resourceName: "profile")
                        }
                        else{
                            let profileUrl = URL(string: val!)
                            cell.profileImageView.sd_setImage(with: profileUrl)
                        }
                    }
                }) { (error) in print(error.localizedDescription)}
                
                cell.profilePhotoLabel.text = "Profile Photo"
                return cell
            // Name
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath) as! nameTableViewCell
                // get username from DB
                self.ref.child("users").child(uid).child("username").observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.exists(){
                        let val = snapshot.value as? String
                        if (val! != ""){
                            cell.userNameLabel.text = val!
                        }
                        else{
                            print("Username is an empty string!")
                            cell.userNameLabel.text = "Unknown"
                        }
                    }
                }) { (error) in print(error.localizedDescription)}
                cell.nameCellLabel.text = "Name"
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

                
                // Retrive Grade from firebase
                var updatedGrade:String?
                self.ref.child("users").child(self.uid).child("grade").observeSingleEvent(of: .value, with: {
                    (snapshot) in
                    updatedGrade = snapshot.value as? String
                    if updatedGrade == nil{
                        cell.userGraderLabel.text = "Unknown"
                    } else {
                        cell.userGraderLabel.text = updatedGrade
                    }
                }) {
                    (error) in print (error.localizedDescription)
                }

                return cell
                
            // Email
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "emailCell", for: indexPath) as! emailTableViewCell
                // get email from DB
                self.ref.child("users").child(uid).child("email").observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.exists(){
                        let val = snapshot.value as? String
                        if (val! != ""){
                            cell.userEmailLabel.text = val!
                        }
                        else{
                            print("Username is an empty string!")
                            cell.userEmailLabel.text = "Unknown"
                        }
                    }
                }) { (error) in print(error.localizedDescription)}
                cell.emailCellLabel.text = "Email"
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
            return 90

        }
        return 40
    }
    

    func downloadProfilePic(){
        var url: String!
        self.ref.child("users").child(self.uid).child("profilepicURL").observeSingleEvent(of: .value, with: {
            (snapshot) in
            url = snapshot.value as? String
        }){
            (error) in print(error.localizedDescription)
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
    
    // MARK: - NOTES
    /*
     - to make headers non sticky: go to main storyboard and chage tableview style to: group
 
    */

}
