//
//  AppDelegate.swift
//  Hyphenate-Demo-Swift
//
//  Created by dujiepeng on 2017/6/12.
//  Copyright © 2017 dujiepeng. All rights reserved.
//

import UIKit
import Hyphenate
import UserNotifications
import Firebase
import SDWebImage


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, EMClientDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        UITabBar.appearance().tintColor = KermitGreenTwoColor
//        UINavigationBar.appearance().tintColor = AlmostBlackColor
        
        FirebaseApp.configure()
        
        let options = EMOptions.init(appkey: "1500170706002947#instasolve")     
        
        var apnsCerName = "InstasolveTutorDevCertificates"
        #if DEBUG
            apnsCerName = "InstasolveTutorDevCertificates"
        #else
            apnsCerName = "InstasolveTutorDevCertificates"
        #endif
        
        options?.apnsCertName = apnsCerName     
        options?.enableConsoleLog = true     
        options?.isDeleteMessagesWhenExitGroup = false     
        options?.isDeleteMessagesWhenExitChatRoom = false     
        options?.usingHttpsOnly = true     
        
        EMClient.shared().initializeSDK(with: options)     
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginStateChange(nofi:)), name: NSNotification.Name(rawValue:KNOTIFICATION_LOGINCHANGE), object: nil)     
        
//        let storyboard = UIStoryboard.init(name: "Launch", bundle: nil)     
//        let launchVC = storyboard.instantiateViewController(withIdentifier: "EMLaunchViewController")     
        
//        window = UIWindow.init(frame: UIScreen.main.bounds)
//        window?.backgroundColor = UIColor.white
//        window?.rootViewController = launchVC
//        window?.makeKeyAndVisible()
        
    
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let RVController = UINavigationController(rootViewController: LaunchViewController())
        RVController.navigationBar.barStyle = .blackTranslucent
        window?.rootViewController = RVController
        
        
        
        parseApplication(application, didFinishLaunchingWithOptions: launchOptions)
        _registerAPNS()     
        
        return true
    }
 
    
    func loginStateChange(nofi: NSNotification) {
        if (nofi.object as! NSNumber).boolValue {
            let mainVC = EMMainViewController()     
            let nav = UINavigationController.init(rootViewController: mainVC)     
            window?.rootViewController = nav
        } else {
            let storyboard = UIStoryboard.init(name: "Register&Login", bundle: nil)     
            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "EMLoginViewController")     
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        EMClient.shared().applicationDidEnterBackground(application)     
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        EMClient.shared().applicationWillEnterForeground(application)     
    }
 
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        EMClient.shared().registerForRemoteNotifications(withDeviceToken: deviceToken, completion: nil)
    }
    
    fileprivate func _registerAPNS() {
        let application = UIApplication.shared     
        application.applicationIconBadgeNumber = 0     
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()     
            center.delegate = self      
            center.requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                if granted {
                    application.registerForRemoteNotifications()     
                }
            }

        }else if #available(iOS 8.0, *){
            let settings = UIUserNotificationSettings.init(types: [.badge, .sound, .alert], categories: nil)     
            application .registerUserNotificationSettings(settings)     
        }
    }
}

