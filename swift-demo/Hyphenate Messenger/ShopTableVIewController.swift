//
//  ShopTableVIewController.swift
//
//  Created by Ming Yue on 2017-07-14.
//  All rights reserved.
//


import UIKit


struct Theme {
    let primaryBackgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)//UIColor(red:0.96, green:0.96, blue:0.95, alpha:1.00)
    let secondaryBackgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
    let primaryForegroundColor = UIColor(red:0.35, green:0.35, blue:0.35, alpha:1.00)
    let secondaryForegroundColor = UIColor(red:0.66, green:0.66, blue:0.66, alpha:1.00)
    let accentColor = UIColor(red:0.09, green:0.81, blue:0.51, alpha:1.00)
    let errorColor = UIColor(red:0.87, green:0.18, blue:0.20, alpha:1.00)
    let font = UIFont.systemFont(ofSize: 18)
    let emphasisFont = UIFont.boldSystemFont(ofSize: 18)
}

class ShopTableViewController: UITableViewController {
    
    
    let products = ["10 Minutes", "30 Minutes", "60 Minutes", "120 Minutes"]
    let prices = [1000, 3000, 6000, 11900]
    let theme = Theme()
    
    //let settingsVC = SettingsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.title = "Shop"
        self.tableView.tableFooterView = UIView()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Shop"
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        let theme = Theme()
        super.viewDidAppear(animated)
        self.view.backgroundColor = theme.primaryBackgroundColor
        self.navigationController?.navigationBar.barTintColor = theme.secondaryBackgroundColor
        self.navigationController?.navigationBar.tintColor = theme.accentColor
        let titleAttributes = [
            NSForegroundColorAttributeName: theme.primaryForegroundColor,
            NSFontAttributeName: theme.font,
            ] as [String : Any]
        let buttonAttributes = [
            NSForegroundColorAttributeName: theme.accentColor,
            NSFontAttributeName: theme.font,
            ] as [String : Any]
        self.navigationController?.navigationBar.titleTextAttributes = titleAttributes
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(buttonAttributes, for: UIControlState())
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes(buttonAttributes, for: UIControlState())
        //self.tableView.separatorColor = theme.primaryBackgroundColor
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        let product = products[indexPath.row]
        let price = prices[indexPath.row]
        //let theme = self.settingsVC.settings.theme
        cell.backgroundColor = theme.secondaryBackgroundColor
        cell.textLabel?.text = product
        cell.textLabel?.font = theme.font
        cell.textLabel?.textColor = theme.primaryForegroundColor
        cell.detailTextLabel?.text = "$\(price/100).00"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product = products[indexPath.row]
        let price = prices[indexPath.row]
        
        let paymentViewController = UIStoryboard(name:"Payment", bundle:nil).instantiateViewController(withIdentifier:"PaymentScr") as! PaymentViewController
        paymentViewController.price = price
        paymentViewController.product = product
        self.tabBarController?.navigationController?.pushViewController(paymentViewController, animated: true)
    }
}
