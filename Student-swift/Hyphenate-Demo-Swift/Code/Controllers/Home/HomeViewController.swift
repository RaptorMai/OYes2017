/*****************************
 HistoryTableViewController.swift
 ****************************/
import UIKit
/* uncomment if needed
 import Hyphenate
 */



class HomeViewController: UIViewController{
    
    var croppingEnabled: Bool = false
    var libraryEnabled: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.tabBarController?.navigationItem.title = "InstaSolve"
        let viewHeight = self.view.bounds.height
        let viewWidth = self.view.bounds.width
        
        //configuring snap button properties. When pressed snap() will be called
        let snapButton = UIButton(type: .custom)
        snapButton.frame = CGRect(x: 0, y: 0, width: viewWidth/2, height: viewWidth/2)
        snapButton.center = CGPoint(x: viewWidth/2, y: viewHeight/2)
        snapButton.layer.cornerRadius = 0.5 * snapButton.bounds.size.width
        snapButton.layer.borderColor = UIColor(red: 23.0/255.0, green: 81.0/255.0, blue: 110.0/255.0, alpha:1.0).cgColor
        snapButton.layer.borderWidth = 3
        snapButton.setImage(UIImage(named:"Snap.png"), for: .normal)
        let margin = 0.191 * snapButton.bounds.size.width
        snapButton.contentEdgeInsets = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        snapButton.addTarget(self, action: #selector(snap), for: .touchUpInside)
        self.view.addSubview(snapButton)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "InstaSolve"
        self.tabBarController?.tabBar.isHidden = false
        //reloadDataSource()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func snap() {
        let cameraViewController = CameraViewController(croppingEnabled: croppingEnabled, allowsLibraryAccess: libraryEnabled) { [weak self] image, asset in
            
            self?.dismiss(animated: true, completion: nil)
        }
        cameraViewController.view.backgroundColor = UIColor.black
        let postquestionNavVC = UINavigationController(rootViewController: cameraViewController)
        postquestionNavVC.isNavigationBarHidden = true
        postquestionNavVC.view.backgroundColor = UIColor.black
        present(postquestionNavVC, animated: true, completion: nil)
    }
    
}

