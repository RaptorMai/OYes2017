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
    var imageview: UIImageView = UIImageView(frame: CGRect(x: 0, y: 68, width: screenWidth, height: screenHeight*0.37))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Category"
        self.view.backgroundColor = UIColor.white
        self.initData()
        self.automaticallyAdjustsScrollViewInsets = false

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(DismissMenu))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
//        navigationController?.navigationBar.barTintColor = UIColor.black
//        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        setupimageview()

    }

    func setupimageview(){
        imageview.contentMode = .scaleAspectFit
        imageview.image = picture
        imageview.backgroundColor = UIColor.white
        
        view.addSubview(imageview)
    }
    
    func DismissMenu(){
        self.dismiss(animated: true, completion: nil)
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
//            调用时传入frame和数据源
        classifyTable = GroupTableView(frame: CGRect(x: 0,y: 211,width: screenWidth,height: screenHeight-211), MenuTypeArr: productTypeArr, proNameArr: productNameArr)
        classifyTable?.navController = self.navController
        classifyTable?.picture.image = picture
        self.view.addSubview(classifyTable!)
    }
    
}

