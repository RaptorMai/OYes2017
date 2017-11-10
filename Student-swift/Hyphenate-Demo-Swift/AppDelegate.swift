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
import CoreData
import Fabric
import Crashlytics
import Firebase
import Stripe
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, EMClientDelegate, MessagingDelegate{
    
    var window: UIWindow?

    /** Google Analytics configuration constants **/
    static let kGaPropertyId = "updateKey"
    static let kTrackingPreferenceKey = "allowTracking"
    static let kGaDryRun = false
    static let kGaDispatchPeriod = 30
    
    /** Hyphenate configuration constants **/
    static let kHyphenatePushServiceDevelopment = "InstasolveDevCertificates"
    static let kHyphenatePushServiceProduction = "InstaSolveProductionCertificates"
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        //Messaging.messaging().subscribe(toTopic: "topic/newQuestion")
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UITabBar.appearance().tintColor = KermitGreenTwoColor
        UINavigationBar.appearance().tintColor = AlmostBlackColor
        
        let options = EMOptions.init(appkey: "1500170706002947#studentdev")
        
        
        var apnsCertName : String? = nil
        // ignore the Xcode "will never be executed" warning
        if _isDebugAssertConfiguration() {
            print("Setting test stripe key")
            Stripe.setDefaultPublishableKey("pk_test_lTfNGp2OD3CytvWX9XCPA41z")
            apnsCertName = AppDelegate.kHyphenatePushServiceDevelopment
        } else {
            print("Setting production stripe key")
            Stripe.setDefaultPublishableKey("pk_live_pmb3J5laKj7HXRw4Ro8Z8P2G")
            apnsCertName = AppDelegate.kHyphenatePushServiceProduction
        }
        
        options?.apnsCertName = apnsCertName
        options?.enableConsoleLog = true     
        options?.isDeleteMessagesWhenExitGroup = false     
        options?.isDeleteMessagesWhenExitChatRoom = false     
        options?.usingHttpsOnly = true     
        
        //TODO: create our own gif with our logo, need to add our gif to "copy bundle researces" under "build phase"
        //showSplashAnimation()
        //Register notification
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        let config = AppConfig.sharedInstance
        //UINavigationBar.appearance().tintColor = UIColor.hiPrimary()
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        UINavigationBar.appearance().clipsToBounds = false
        UINavigationBar.appearance().isTranslucent = true
        
        EMClient.shared().initializeSDK(with: options)
        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(loginStateChange(nofi:)),
//                                               name: NSNotification.Name(rawValue:KNOTIFICATION_LOGINCHANGE),
//                                               object: nil)
//
//        let storyboard = UIStoryboard.init(name: "Launch", bundle: nil)
//        let launchVC = storyboard.instantiateViewController(withIdentifier: "EMLaunchViewController")
//
//        window = UIWindow.init(frame: UIScreen.main.bounds)
//        window?.backgroundColor = UIColor.white
//        window?.rootViewController = launchVC
//        window?.makeKeyAndVisible()
        
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

        }
        else if #available(iOS 8.0, *) {
            let settings = UIUserNotificationSettings.init(types: [.badge, .sound, .alert], categories: nil)     
            application .registerUserNotificationSettings(settings)     
        }
    }
}

