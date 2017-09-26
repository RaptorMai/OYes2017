//
//  webViewController.swift
//  Hyphenate-Demo-Swift
//
//  Created by Caryn Cheung on 2017-09-21.
//  Copyright © 2017 杜洁鹏. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import MBProgressHUD
class OpenUrlViewController: UIViewController, WKUIDelegate {
    
    var url : String?
    
    var webView: WKWebView!
    
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add a progressHUD when loading.
        let myHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.view.addSubview(myHUD!)
        myHUD?.isUserInteractionEnabled = false
        // Hide HUD after 8 seconds. (Cannot detect when the loading is finish)
        myHUD?.hide(true, afterDelay: 5)
        
        let myURL = URL(string: url!)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
    }
    
    
}
