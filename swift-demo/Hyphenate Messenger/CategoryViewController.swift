//
//  ViewController.swift
//  MenuChoice
//
//  Created by juanmao on 16/2/16.
//  Copyright © 2016年 juanmao. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    var productTypeArr: [String] = []
    var productNameArr: [ [(area: String, enabled: Bool)] ] = []
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
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
//        self.navigationController?.navigationBar.tintColor = UIColor.white
//        self.navigationBar.barStyle = UIBarStyle.Black
//        self.navigationBar.tintColor = UIColor.whiteColor()
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
    
    //This is code from online. It is gathering the data from MenuData.json to know what categories to display.
    func  initData()
    {
        // sample json: [{"category": "Math",
        //                "subCate" : { "calculus" : 1 }
        //                }]
        // load json from config
        
        var data = AppConfig.sharedInstance.getConfigForType(.ConfigTypeCategory) as? Data
        if data == nil {
            // load json locally
            let path:String = (Bundle.main.path(forResource: "MenuData", ofType: "json"))!
            data = try! Data(contentsOf: URL(fileURLWithPath: path))
        }
        
        let json = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        // json.count: number of subjects, math, physics, etc
        for i in 0 ..< json.count {
            let subjectDict = json[i] as! NSDictionary
            let subjectName = subjectDict.value(forKey: "category")! as! String
            let areaDict = subjectDict.value(forKey: "subCate")! as! Dictionary<String, Int>
            
            // an array of all area in the subject, like [(calculus, 1)]
            var subjectAreaList:[(area: String, enabled: Bool)] = []
            
            for (areaName, enabled) in areaDict {
                let areaDetail = (area: areaName, enabled: Bool(enabled as NSNumber))
                subjectAreaList.append(areaDetail)
            }
            
            // sort the subjectArea, enabled ones come first
            productNameArr.append(subjectAreaList.sorted(by: {$0.enabled && !$1.enabled}))
            productTypeArr.append(subjectName)
        }
        // Once the data is gathered call the addSubView() function.
        self.addGroupTableView()
    }

//  Create the GroupTableView and present it. GroupTableView is the double menu table style.
    func addGroupTableView(){
//            调用时传入frame和数据源
        classifyTable = GroupTableView(frame: CGRect(x: 0,y: 211,width: screenWidth,height: screenHeight-211), MenuTypeArr: productTypeArr, proNameArr: productNameArr)
        classifyTable?.navController = self.navController
        classifyTable?.picture.image = picture
        self.view.addSubview(classifyTable!)
    }
    
}

