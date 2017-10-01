//
//  GradeViewController.swift
//  ProfileSetting
//
//  Created by Yi Jerry on 2017-09-23.
//  Copyright © 2017 Yi Jerry. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class GradeViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: - Firebase
    var ref = Database.database().reference()
    var uid = "+1" + EMClient.shared().currentUsername!

    override func viewDidLoad() {
        super.viewDidLoad()
        gradePickerView.delegate = self
        gradePickerView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Properties
    var grade = ["Grade 9", "Grade 10","Grade 11","Grade 12","Year 1","Year 2","Year 3","Year 4","Others"]
    
    //MARK: - Outlets
    @IBOutlet weak var gradePickerView: UIPickerView!
    @IBOutlet weak var gradeLabel: UILabel!
    
    //MARK: - Interactions
    @IBAction func dismissView(_ sender: UIBarButtonItem) {
        // Add the delegate method call
        uploadGrade(gradeLabel.text)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Functions
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return grade.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return grade[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gradeLabel.text = grade[row]
    }
    
    func uploadGrade(_ Grade: String?){
        self.ref.child("users/\(self.uid)").updateChildValues(["grade":Grade!])
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
