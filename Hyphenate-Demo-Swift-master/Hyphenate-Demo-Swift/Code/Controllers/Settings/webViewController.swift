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
        
        let myURL = URL(string: url!)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }}
