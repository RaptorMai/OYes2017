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
//import FirebaseDatabase

protocol rescueButtonPressedProtocol {
    func rescueButtonPressed()
}

class MainTableViewController: UITableViewController, rescueButtonPressedProtocol {
    let testarray: [[String:Any]] = [["sid":"6475290310", "pic": "unknown", "category": "Math", "description": "some random description that is sort of long", "status": true],["sid":"6475291234", "pic": "unkown", "category": "Science", "description": "some random description that is sort of long but actually even longer for testing long strings. some random description that is sort of long but actually even longer for testing long strings.", "status": true] ]
    let kCloseCellHeight: CGFloat = 179
    let kOpenCellHeight: CGFloat = 488
    var kRowsCount = 0
    var cellHeights: [CGFloat] = []
    //    var cache:NSCache<AnyObject, AnyObject>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dictArray.removeAll()
        self.automaticallyAdjustsScrollViewInsets = false
        self.getData(completion: { (success) -> Void in
            
            if success{
                self.getPic(completion: {(success) -> Void in
                    
                    if success{
                        
                        print(self.dictArray)
                        
                        
                        self.setup()
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        print("done")
                        
                    }
                    else{return}
                    
                })
            }
            else{self.setup()}
        })
        //    self.setup()
        print("hi")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh),name:NSNotification.Name(rawValue: "refresh"), object: nil)
    }
    
    func refresh(){
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.dictArray.removeAll()
        self.getData(completion: { (success) -> Void in
            
            print(self.dictArray)
            if success{
                self.getPic(completion: {(success) -> Void in
                    
                    if success{
                        
                        print(self.dictArray)
                        
                        
                        self.setup()
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        print("done")
                        
                    }
                    else{return}
                    
                })
            }
            else{self.setup()}
        })
        //    self.setup()
        print("hi")
        print(self.dictArray)
        
        
    }
    
    private func setup() {
        self.automaticallyAdjustsScrollViewInsets = false
        kRowsCount = dictArray.count
        cellHeights = Array(repeating: kOpenCellHeight, count: kRowsCount)
        tableView.estimatedRowHeight = kOpenCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor(hex: "F8F8F8")
    }
    
    // code for fetching
    var specialty = ["Basic Calculus"]
    var dictArray = [Dictionary<String,Any>]()
    var ref: DatabaseReference?
    
    func getData(completion:@escaping (_ success: Bool) -> ()){
        ref = Database.database().reference()
        for item in specialty{
            
            self.ref?.child("Request/active/\(item)").observeSingleEvent(of: .value, with: { (snapshot) in
                //                print(snapshot)
                if let snapDict = snapshot.value! as? [String:AnyObject]{
                    //print(snapDict)
                    for each in snapDict{
                        //                        print(each)
                        self.dictArray.append(each.value as! Dictionary<String,Any>)
                        
                        
                    }
                    print("yes")
                    completion(true)
                }
                
            })
        }
        
    }
    
    func getPic(completion:@escaping (_ success: Bool) -> ()){
        //
        //        for index in 0..<self.dictArray.count{
        //
        //            let url = self.dictArray[index]["picURL"]!
        //            //print (url)
        //            let storageRef = Storage.storage().reference(forURL:url as! String)
        //            storageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
        //                if let error = error {
        //                    print(error)
        //                } else {
        //
        //
        //                    self.dictArray[index]["picURL"] = data
        //
        //                    //print(dic)
        //                }
        //            }
        //        }
        completion(true)
        
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
        
        cell.subject = dictArray[indexPath.row]["category"] as! String
        cell.closeDescription.text = dictArray[indexPath.row]["description"] as? String
        cell.openDescription.text = dictArray[indexPath.row]["description"] as? String
        //    if let imageData = dictArray[indexPath.row]["picURL"] as? Data {
        //        if let image = UIImage(data:imageData) {
        ////            img = UIImage(data:imageData)
        //            cell.closeQuestPic.image = image
        //            cell.openQuestPic.image = image
        ////            if let updateCell = tableView.cellForRow(at: indexPath) {
        ////                //        let img:UIImage! = UIImage(data: data)
        ////                updateCell.imageView?.image = img
        ////                self.cache.setObject(img!, forKey: (indexPath as NSIndexPath).row as AnyObject)
        ////            }
        //
        //        }
        //    }
        
        // Downloads pictures, caches them and alllows for immediate loading of pictures
        let photoURL = dictArray[indexPath.row]["picURL"]
        cell.openQuestPic.sd_setImage(with: URL(string: photoURL as! String))
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        //    var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
        if cellIsCollapsed {
            //      cellHeights[indexPath.row] = kOpenCellHeight
            //      cell.unfold(true, animated: true, completion: nil)
            //      duration = 0.5
        } else {
            //      cellHeights[indexPath.row] = kCloseCellHeight
            //      cell.unfold(false, animated: true, completion: nil)
            //      duration = 0.8
        }
        
        //    UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
        //      tableView.beginUpdates()
        //      tableView.endUpdates()
        //    }, completion: nil)
        
    }
    
    func rescueButtonPressed() {
        let addContactViewController = EMAddContactViewController.init(nibName: "EMAddContactViewController", bundle: nil)
        let nav = UINavigationController.init(rootViewController: addContactViewController)
        present(nav, animated: true, completion: nil)
    }
    
}
