//
//  ProfileSettingViewController.swift
//  Hyphenate Messenger
//
//  Created by Yi Jerry on 2017-09-26.
//  Copyright © 2017 Hyphenate Inc. All rights reserved.
//

import UIKit

class ProfileSettingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "jerryProfile")

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Title
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
 
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK - Interaction
    @IBAction func tapCameraButton(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        present(imagePicker, animated: true, completion: nil)
        imagePicker.delegate = self
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as! UIImage?
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARL: - Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let actionSheet = UIAlertController(title: "Upload Profile Picture", message: nil, preferredStyle: .actionSheet)
        
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let takePhotos = UIAlertAction(title: "Take a Photo", style: .destructive, handler: nil)
        
        let selectPhotos = UIAlertAction(title: "Choose from Albumn", style: .default, handler: nil)
        
        actionSheet.addAction(cancelBtn)
        actionSheet.addAction(takePhotos)
        actionSheet.addAction(selectPhotos)
        self.present(actionSheet, animated: true, completion: nil)
        
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
