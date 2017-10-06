//
//  ProfileSettingViewController.swift
//  Hyphenate Messenger
//
//  Created by Yi Jerry on 2017-09-26.
//  Copyright © 2017 Hyphenate Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MBProgressHUD
class ProfileSettingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Firebase
    //var ref: DatabaseReference!
    var ref = Database.database().reference()
    var uid = "+1" + EMClient.shared().currentUsername!
    
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.size.width/1.8
        
        imageView.clipsToBounds = true
        if let data = UserDefaults.standard.data(forKey: "profilePicture"){
            let imageUIImage: UIImage = UIImage(data: data)!
            imageView.image = imageUIImage
        }else{
            imageView.image = UIImage(named:"placeholder")
        }
    }
    
    
    // MARK: - Title
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
 
    
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK - Interaction
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let imageData: Data = UIImagePNGRepresentation(imageView.image!)!
        
        // Upload Profile Picture to DB
        uploadPicture(imageData, completion:{ (url) -> Void in
            print("Uploading profile pic")
            self.ref.child("users/\(self.uid)").updateChildValues(["profilepicURL": url!])
//            MBProgressHUD.hide(for: self.view, animated: true)
//            self.navigationController?.popViewController(animated: true)
            print("Finished upload")
            print("Going to download from DB")
            // Retrive Profile Picture from DB
            // Store data to UserDefaults
            self.ref.child("users").child(self.uid).child("profilepicURL").observeSingleEvent(of: .value, with: {(snapshot) in
                
                print("downloaded from DB")
                var imageBuffer: UIImage
                
                if snapshot.exists(){
                    let val = snapshot.value as? String
                    print(val)
                    if (val == nil){
                        imageBuffer = #imageLiteral(resourceName: "profile")
                        let imgData = UIImageJPEGRepresentation(imageBuffer, 1)
                        UserDefaults.standard.set(imgData, forKey: "profilePicture")
                    }
                    else{
                        print("Recieve Non-null image")
                        print("Setting UsersDefault")
                        let imgData = UIImageJPEGRepresentation(self.imageView.image!, 1)
                        UserDefaults.standard.set(imgData, forKey: "profilePicture")
                        //let profileUrl = URL(string: val!)
                        //print(val)
                        //self.imageView.sd_setImage(with: profileUrl)
                        //imageBuffer = self.imageView.image!
                        
                    }
                }
                
                MBProgressHUD.hide(for: self.view, animated: true)
                print("Dimiss VC")
                self.navigationController?.popViewController(animated: true)
            }) { (error) in print(error.localizedDescription)}
            
            
            
        })
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as! UIImage?
        //self.profilePic = info[UIImagePickerControllerOriginalImage] as! UIImage?
        dismiss(animated: true, completion: nil)
    }
    
    
    func uploadPicture(_ data: Data, completion:@escaping (_ url: String?) -> ()) {
        let storageRef = Storage.storage().reference()
        storageRef.child("image/profilePicture/\(self.uid)").putData(data, metadata: nil){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            }else{
                //store downloadURL
                completion((metaData?.downloadURL()?.absoluteString)!)
            }
        }
    }
    
    func handleTap(_ tapGesture: UITapGestureRecognizer) {
        let actionSheet = UIAlertController(title: "Upload Profile Picture", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title:"Choose from Albumn", style: .default, handler:{(action:UIAlertAction) in self.pickPhoto()}))
        
        actionSheet.addAction(UIAlertAction(title:"Cancel", style: .cancel, handler:nil))
        self.present(actionSheet, animated: true, completion: nil)

    }

    
    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let actionSheet = UIAlertController(title: "Upload Profile Picture", message: nil, preferredStyle: .actionSheet)
//        
//        actionSheet.addAction(UIAlertAction(title:"Choose from Albumn", style: .default, handler:{(action:UIAlertAction) in self.pickPhoto()}))
//        
//        actionSheet.addAction(UIAlertAction(title:"Cancel", style: .cancel, handler:nil))
//        self.present(actionSheet, animated: true, completion: nil)
//        
//    }
    
    func pickPhoto(){
        let imagePicker = UIImagePickerController()
        present(imagePicker, animated: true, completion: nil)
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
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