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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.title = "MAGIC"
//        self.view.backgroundColor = UIColor.white
        self.initData()
        self.automaticallyAdjustsScrollViewInsets = false
//        let myNav: UINavigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        let myNav: UINavigationBar = UINavigationBar()
        myNav.barTintColor = UIColor.blue
        view.addSubview(myNav)
        
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        
        if classifyTable?.categoryselected == true {
            print("hi")
        }
    }

    
    
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
        self.view.addSubview(classifyTable!)
    }

}

