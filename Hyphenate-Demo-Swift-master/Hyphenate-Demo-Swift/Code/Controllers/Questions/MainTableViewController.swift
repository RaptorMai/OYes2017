//
//  MainTableViewController.swift
//
// Copyright (c) 21/12/15. Ramotion Inc. (http://ramotion.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import Firebase
import SDWebImage
import Hyphenate
import MBProgressHUD
//import FirebaseDatabase

protocol rescueButtonPressedProtocol {
    func rescueButtonPressed(requestorSid: NSString, category: NSString, qid: NSString, image: UIImage?, description: String?)
}

class MainTableViewController: UITableViewController, rescueButtonPressedProtocol, expandimageProtocol {
    let kCloseCellHeight: CGFloat = 179
    let kOpenCellHeight: CGFloat = 488
    var kRowsCount = 0
    var cellHeights: [CGFloat] = []
    var specialty = ["Basic Calculus"]
    var dictArray = [Dictionary<String,Any>]()
    var ref: DatabaseReference?
    var delegate: refreshSpinnerProtocol?
    
    //    var cache:NSCache<AnyObject, AnyObject>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dictArray.removeAll()
        self.automaticallyAdjustsScrollViewInsets = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh),name:NSNotification.Name(rawValue: "refresh"), object: nil)
        UIApplication.shared.applicationIconBadgeNumber = 0
        self.getData(completion: { (success) -> Void in
            
            if success{
                self.getPic(completion: {(success) -> Void in
                    
                    if success{
                        
                        //print(self.dictArray)
                        
                        
                        self.setup()
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        
                        }
                        print("done")
                        
                    }
                    else{return}
                    
                })
            }
            else{
                
                
                print("not")
                
                
            }
        })
        //    self.setup()
        print("hi")
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
            self.refresh()
    }
    
    func refresh(){
        super.viewDidLoad()
        self.dictArray.removeAll()
        self.automaticallyAdjustsScrollViewInsets = false
        self.getData(completion: { (success) -> Void in
            
            print(self.dictArray)
            if success{
                self.getPic(completion: {(success) -> Void in
                    
                    if success{
                        
                        //print(self.dictArray)
                        
                        
                        self.setup()
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        self.delegate?.removeSpinner()
                        print("done")
                        
                    }
                    else{return}
                    
                })
            }
            else{
                
                self.setup()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.delegate?.removeSpinner()
                print("refreshnot")
                
            }
        })
        //    self.setup()
        print("hi")
        //print(self.dictArray)
        
        
    }
    
    private func setup() {
        self.automaticallyAdjustsScrollViewInsets = false
        kRowsCount = dictArray.count
        cellHeights = Array(repeating: kOpenCellHeight, count: kRowsCount)
        tableView.estimatedRowHeight = kOpenCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor(hex: "F8F8F8")
    }
    
    
    func getData(completion:@escaping (_ success: Bool) -> ()){
        ref = Database.database().reference()
        for item in specialty{
            
            self.ref?.child("Request/active/\(item)").observeSingleEvent(of: .value, with: { (snapshot) in
                //                print(snapshot)
                if let snapDict = snapshot.value! as? [String:AnyObject]{
                    //print(snapDict)
                    for each in snapDict{
                        let checkStatus=each.value["status"] as? Int
                        if ( checkStatus == 0){
                            print(each.value)
                            self.dictArray.append(each.value as! Dictionary<String,Any>)
                        }
                        
                    }
                    print("yes")
                    completion(true)
                }
                else{completion(false)}
                
            })
        }
        
    }
    
    func getPic(completion:@escaping (_ success: Bool) -> ()){
        completion(true)
        
    }
    
    func expandimage(cellimageview: UIImageView){
        if let image = cellimageview.image{
            let agrume = Agrume(image: image, backgroundColor: .black)
            agrume.hideStatusBar = true
            agrume.showFrom(self)
        }
    }
    
    
}

// MARK: - TableView
extension MainTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kRowsCount
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as DemoCell = cell else {
            return
        }
        
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.unfold(false, animated: false, completion:nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        if !dictArray.isEmpty{
            cell.subject = dictArray[indexPath.row]["category"] as! String
            cell.closeDescription.text = dictArray[indexPath.row]["description"] as? String
            cell.openDescription.text = dictArray[indexPath.row]["description"] as? String
            // Downloads pictures, caches them and alllows for immediate loading of pictures
            let photoURL = dictArray[indexPath.row]["picURL"]
            cell.openQuestPic.sd_setImage(with: URL(string: photoURL as! String))
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        cell.delegate = self
        cell.tableDelegate = self
        cell.requestorSid = dictArray[indexPath.row]["sid"] as! NSString
        cell.category = dictArray[indexPath.row]["category"] as! NSString
        cell.qid = dictArray[indexPath.row]["qid"] as! NSString
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    
    func rescueButtonPressed(requestorSid: NSString, category: NSString, qid: NSString, image:UIImage?, description: String?) {
        
        let ref = Database.database().reference()
        let tid = EMClient.shared().currentUsername
        
        //print(tid)
        // TO DO: get current questionId from db
        let qid: String = (qid as String)
        let category: String = (category as String)
        let refStatus = ref.child("Request/active/" + category + "/" + qid)
        //let refInactive = ref.child("Request/inactive/" + category + "/" + qid)
        refStatus.runTransactionBlock ({ (currentData: MutableData) -> TransactionResult in
            //print(currentData.value)
            if var data = currentData.value as? [String: Any] {
                print("this is data \(data)")
                var status = data["status"] as? Int
                
                if status == 1 {
                    // TO DO: pop up window saying better luck next time
                    
                    return TransactionResult.abort()
                } else {
                    status = 1
                    data["status"] = status
                    data["tid"] = tid
                    // TO DO: assign tutorId to accepted question
                    // TO DO: connect to student to start session -> func startSession(sid)
                    
                }
                // update status on Firebase db
                currentData.value = data
                print("updated data \(data)")
                return TransactionResult.success(withValue: currentData)
            }
            
            print("data is nill")
            return TransactionResult.success(withValue: currentData)
        },andCompletionBlock: {
            error, commited, snap in
            
            //if the transaction was commited, i.e. the data
            //under snap variable has the value of the counter after
            //updates are done
            if commited {
                
                print(snap?.value)
                let checkNill = snap?.value! as? [String:AnyObject]
                print(checkNill)
                if (checkNill == nil){
                    
                    let alert = UIAlertController(title: "Alert", message: "Sorry better luck next time", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {action in self.refresh()}))
                    self.present(alert, animated: true, completion: nil)
                    print("Sorry better luck next time")
                    //print(snap!)
                }
                else{
                    
                    let alert = UIAlertController(title: "Alert", message: "yeah you got the question", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {
                        (alert: UIAlertAction!) in
                        //Once user dismisses the alert: create a chat viewcontroller and embed it in a navigation controller. The navigation controller is then presented with a done button.
                        /*
                        let sessionController = EMChatViewController.init(requestorSid as String, EMConversationTypeChat)
                        sessionController.category = category
                        sessionController.key = qid
                        
                        let navC = UINavigationController(rootViewController: sessionController)
                        self.navigationController?.present(navC, animated: true, completion: nil)*/
                        let cwsVC = ConnectedWithStudentVC()
                        cwsVC.requestorSid = requestorSid
                        cwsVC.category = category
                        cwsVC.qid = qid
                        if let unwrappedimage = image {
                            cwsVC.image = unwrappedimage
                        }
                        if let unwrappeddescription = description{
                            cwsVC.questDescription = unwrappeddescription
                        }
                        let navC = UINavigationController(rootViewController: cwsVC)
                        self.navigationController?.present(navC, animated: true, completion: nil)
                        //self.navigationController?.pushViewController(cwsVC, animated: true)
                        
                        let addContactViewController = EMAddContactViewController.init(nibName: "EMAddContactViewController", bundle: nil)
                        addContactViewController.contactToAdd = requestorSid as String
                        addContactViewController.sendRequest(addContactViewController.contactToAdd)
                        //print(snap!)
                        print("yeah you got the question")
                    }))
                    
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }
            else{
                
                let alert = UIAlertController(title: "Alert", message: "Sorry better luck next time", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {action in self.refresh()}))
                self.present(alert, animated: true, completion: nil)
                print("Sorry better luck next time, not commit")
                //print(snap)
                
            }
        })

        //cwsVC means connectedwithstudentVC
    }
    
    func dismissChatVC(){
        print("testing")
        dismiss(animated: true, completion: {print("testing 2")})
    }
    
}
