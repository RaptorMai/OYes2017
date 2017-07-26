//
//  ViewController.swift
//  MenuChoice
//
//  Created by juanmao on 16/2/16.
//  Copyright © 2016年 juanmao. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    var productTypeArr:[String] = []
    var productNameArr:[AnyObject] = []
    var classifyTable: GroupTableView?
    var navController: UINavigationController? = nil
    var picture: UIImage? = nil
//    let myNav: UINavigationBar = UINavigationBar()
    
    let cancel: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "MAGIC"
        self.view.backgroundColor = UIColor.white
        self.initData()
        self.automaticallyAdjustsScrollViewInsets = false
        view.addSubview(cancel)
    }

//    func setupNavBar(){
//        myNav.translatesAutoresizingMaskIntoConstraints = false
//        myNav.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        myNav.topAnchor.constraint(equalTo: view.topAnchor, constant: 17).isActive = true
//        myNav.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        myNav.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        myNav.barTintColor = UIColor.white
////        let BackButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(GoBack))
////        myNav.topItem?.backBarButtonItem = BackButton
//
//    }
//    
//    func GoBack(){
//        print("hi")
//    }
    
    func  initData()
    {
        let path:String = (Bundle.main.path(forResource: "MenuData", ofType: "json"))!
        let data:Data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let json:AnyObject = try!JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
        let resultDict = json.object(forKey: "data") as! Dictionary<String,AnyObject>
        let productMenuArr:[NSDictionary] = resultDict["productType"] as! Array
        for i:Int in 0 ..< productMenuArr.count
        {
            productTypeArr.append(productMenuArr[i]["typeName"] as! String)
            productNameArr.append(productMenuArr[i]["productName"] as! [String] as AnyObject)
        }
        
        self.addSubView()
    }

    
    func addSubView(){
            ///调用时传入frame和数据源
        classifyTable = GroupTableView(frame: CGRect(x: 0,y: 64,width: screenWidth,height: screenHeight-64), MenuTypeArr: productTypeArr, proNameArr: productNameArr)
        classifyTable?.navController = self.navController
        //let pic = UIImage(named: "name.png")
        classifyTable?.picture.image = picture
        self.view.addSubview(classifyTable!)
    }
    
}

