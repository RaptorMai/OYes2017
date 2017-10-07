//
//  GroupTableView.swift
//  FilterDemo
//
//  Created by juanmao on 16/1/25.
//  Copyright © 2016年 juanmao. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class GroupTableView: UIView,UITableViewDelegate,UITableViewDataSource {
    var groupTableView:UITableView!
    var classifyTableView:UITableView!
    var productTypeArr:[String] = []
    var productNameArr:[ [(area: String, enabled: Bool)] ] = []
    var currentExtendSection:Int = 0
    var isScrollSetSelect = false
    var isScrollClassiftyTable = false
    var picture:UIImageView = UIImageView(frame: CGRect(x: 0, y: 64, width: screenWidth, height: screenHeight*0.23))
    var categoryselected = false
    var navController:UINavigationController? = nil
    
    
    /// Initialize the group table view with the data array
    ///
    /// - Parameters:
    ///   - frame: Frame of the group table view
    ///   - MenuTypeArr: all the types, like [math, phys]
    ///   - proNameArr: product for each category, like [[(calculus,true) (algebra, false)],[]]
    init(frame:CGRect, MenuTypeArr:[String], proNameArr:[ [(area: String, enabled: Bool)] ]) {
        super.init(frame: frame)
        
        self.productTypeArr = MenuTypeArr
        self.productNameArr = proNameArr
        
        self.groupTableView = UITableView(frame: CGRect(x: frame.width*0.3, y: frame.height*0.25, width: frame.width*0.7, height: frame.height*0.75), style: UITableViewStyle.plain)
        self.groupTableView.delegate = self
        self.groupTableView.dataSource = self
        self.groupTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.groupTableView.backgroundColor = UIColor.init(hex: "EBF0F1")
        self.groupTableView.tableHeaderView?.backgroundColor = UIColor(red: 230, green: 230, blue: 230, alpha: 1)
        self.addSubview(self.groupTableView)
        
        self.classifyTableView = UITableView(frame:CGRect(x: 0, y: frame.height*0.25, width: frame.width*0.3, height: frame.height*0.75),style:UITableViewStyle.plain)
        self.classifyTableView.delegate = self;
        self.classifyTableView.dataSource = self;
        self.classifyTableView.tableFooterView = UIView()
        self.addSubview(self.classifyTableView)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == self.classifyTableView
        {
            return productTypeArr.count
        }
        else
        {
            return productNameArr[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let classifyCell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "classifyCell")
        let extendCell:PrdouctMenuTableViewCell = PrdouctMenuTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "extendCell")
        extendCell.backgroundColor = UIColor.init(hex: "F8F8F8");
        if tableView == self.classifyTableView
        {
            classifyCell.textLabel?.text = self.productTypeArr[indexPath.row]
            classifyCell.textLabel?.numberOfLines = 0
            classifyCell.backgroundColor = UIColor(red: 238, green: 238, blue: 238, alpha: 1)
            classifyCell.selectionStyle = UITableViewCellSelectionStyle.none
                //默认选中第一个分类
            if indexPath.row == currentExtendSection
            {
                let tempView:UIView = UIView(frame:CGRect(x: 0,y: 0,width: 5,height: 55))
                tempView.tag = 101
                tempView.backgroundColor = UIColor.init(hex: "2EA2DC")
                classifyCell.addSubview(tempView)
            }
            return classifyCell
        } else {
            // extendCell config
            if productNameArr[indexPath.section].count > indexPath.row {
                let areaDetail = productNameArr[indexPath.section][indexPath.row]
                extendCell.productNameStr = areaDetail.area
                extendCell.enabled = areaDetail.enabled
            }
            return extendCell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if tableView == self.groupTableView {
            return productTypeArr.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section:
        Int) -> String?
    {
        if tableView == groupTableView {
            return productTypeArr[section]
        }
        return ""
    }
        //MARK:UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == self.classifyTableView {
            return 55
        } else {
            return 85
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if tableView == groupTableView {
            return 30
        }
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == self.classifyTableView {
                //用户点击分类的tableview
            tableView.deselectRow(at: indexPath, animated: true)
            self.leftSectionSelected(indexPath, withTableView: tableView,didSelectClassifyTable:true)
        }
        
        if tableView == self.groupTableView {
            let summaryVC = SummaryVC()
            let areaDetail = productNameArr[indexPath.section][indexPath.row]
            summaryVC.categorytitle = "\(areaDetail.area)"
            summaryVC.questionPic = picture
            navController?.pushViewController(summaryVC, animated: true)
        }
    }
    
    func leftSectionSelected(_ indexPath:IndexPath, withTableView tableView:UITableView,didSelectClassifyTable:Bool)
    {
        if tableView == self.classifyTableView {
            if indexPath.row == currentExtendSection {
                    //当前选中项与上次一致，直接return
                return ;
            }
                //选中新的分类
            let newCell:UITableViewCell? = tableView.cellForRow(at: indexPath)
            let tempView:UIView = UIView(frame:CGRect(x: 0,y: 0,width: 5,height: 55))
            tempView.tag = 101
            tempView.backgroundColor = UIColor.init(hex: "2EA2DC")
            newCell?.addSubview(tempView)
            
                //取消上次选中的分类
            let oldIndexPath:IndexPath = IndexPath(row: currentExtendSection, section: 0)
            let oldCell:UITableViewCell? = tableView.cellForRow(at: oldIndexPath)
            let view:UIView? = oldCell?.viewWithTag(101)
            view? .removeFromSuperview()
            
             self.currentExtendSection = indexPath.row
            
                //将右边对应的分类项置顶
            self.groupTableView.scrollToRow(at: IndexPath(row: 0, section:self.currentExtendSection), at: UITableViewScrollPosition.top, animated: true)
            isScrollClassiftyTable = didSelectClassifyTable
            
            let cellR:CGRect = self.classifyTableView.rectForRow(at: indexPath)
            if self.classifyTableView.contentOffset.y - cellR.origin.y > 54 {
                    //左边分类的tableview向上滚动（让选中的分类cell可见）
                self.classifyTableView.contentOffset.y = CGFloat(55 * indexPath.row)
            }
            
            if cellR.origin.y - self.classifyTableView.frame.size.height > 0 {
                    ////左边分类的tableview向下滚动（让选中的分类cell可见）
                self.classifyTableView.contentOffset.y = cellR.origin.y - self.classifyTableView.frame.size.height+55
            }
        }
    }
    
    func rightSectionSelected(_ indexPath:IndexPath, withTableView tableView:UITableView,didSelectGroupTable:Bool){
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        isScrollSetSelect = false
        if scrollView == self.groupTableView {
            isScrollSetSelect = true
            isScrollClassiftyTable = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if scrollView == self.groupTableView && isScrollSetSelect && isScrollClassiftyTable == false {
                //滚动右边tableview
            let indexPathArr:[IndexPath]? =  self.groupTableView.indexPathsForVisibleRows
            self.leftSectionSelected(IndexPath(row:indexPathArr![0].section, section: 0), withTableView: self.classifyTableView,didSelectClassifyTable: false)
        }
    }
}
