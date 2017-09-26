//
//  OpenUrlController.swift
//  Hyphenate Messenger
//
//  Created by Yi Jerry on 2017-09-20.
//  Copyright © 2017 Hyphenate Inc. All rights reserved.
//

import UIKit
import WebKit

class OpenUrlViewController: UIViewController, WKUIDelegate {
    
    var url : String?
    
    var webView: WKWebView!
    
    // MARK: - Navigation Bar and Tab Bar
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Help"
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: url!)
        let myRequest = URLRequest(url: myURL!)
    
        webView.load(myRequest)
    }}

