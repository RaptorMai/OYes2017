// This file defines the config related modules, including
//   1. load config when app is launching
//   2. store the pulled data into user defaults
//   3. load local stored data from user defaults

import Foundation
import Firebase
import Alamofire


/// Enum for specifying config type
///
/// - ConfigTypeCategory: will return Data of pulled JSON file from getConfigForType()
/// - ConfigTypePackage: will return NSDictionary of pulled package info from getConfigForType()
/// - ConfigTypeAppUpdateRequired: will return Bool based on app version, from getConfigForType()
/// - ConfigTypeAppUpdateSuggested: will return Bool based on app version, from getConfigForType()
/// - ConfigTypeFirstLaunch: will return the interger count of open times from getConfigForType()
enum ConfigType {
    case ConfigTypeCategory
    case ConfigTypePackage
    case ConfigTypeAppUpdateRequired
    case ConfigTypeAppUpdateSuggested
    case ConfigTypeFirstLaunch
}

struct DataBaseKeys {
    static let firstLaunchKey = "firstLaunchKey"
    static let packageRequiredVer = "packageUpdateReq"
    static let packageVerKey = "packageUpdateReq"
    static let packageDictionaryKey = "price"
    static let packageNeedsUpdateKey = "priceU"

    static let categoryRequiredVer = "categoryUpdateReq"
    static let categoryVerKey = "categoryUpdateReq"
    static let categoryDictionaryKey = "categoryDict"
    
    static let appRequiredVer = "forcedUpdateReq"
    static let appRequiredVerKey = "appRequiredVer"
    static let appSuggestedVer = "appUpdateSuggested"
    static let appSuggestedVerKey = "appSuggestedVer"
    
    static let serverAddress = "serverAddress"
    static let appStoreLink = "appStoreLink"
    
    
    /// Returns db reference string based on key
    ///
    /// - Parameter key: key to query, like "forceUpdateReq"
    /// - Returns: the path for DB query, like "globalConfig/forceUpdateReq"
    static func configDBRef(_ key: String) -> String {
        return "globalConfig/\(key)"
    }
    
    static let defaultDict = [serverAddress: "us-central1-instasolve-d8c55.cloudfunctions.net" as NSObject,
                              appStoreLink: "itms://itunes.apple.com/app" as NSObject]
}


/// This class provides method to load/store/get configurations, including baseURL for http request, handle required version of packages, categories and app version
class AppConfig {
    static let sharedInstance = AppConfig()
    private init() {}
    
    let defaults = UserDefaults.standard
    let ref: DatabaseReference! = Database.database().reference()
    
    var appVersion = Double(Bundle.main.infoDictionary?["CFBundleShortVersionString"]! as! String)!
    
    var appUpdateRequired: Bool {
        get {
            return getConfigForKey(DataBaseKeys.appRequiredVerKey)! as! Double > appVersion
        }
    }
    
    var isAlertShwon = false  // used to sync the alert, we show alert again in didBecomeActive, but needs to let it know not to show again
    
    private func storeConfigForKey(_ key: String, withData dataObj: Any) {
        defaults.set(dataObj, forKey: key)
    }
    
    private func getConfigForKey(_ key: String) -> Any? {
        return defaults.object(forKey: key)
    }
    
    
    /// Fetch app's configuration using this function
    ///
    /// - Parameter type: enum for which config to pull.
    /// - Returns: the corresponding object for required config. Consult the doc of ConfigType for detail
    func getConfigForType(_ type: ConfigType) -> Any? {
        switch type {
        case .ConfigTypeCategory:
            if let categoryDict = getConfigForKey(DataBaseKeys.categoryDictionaryKey) {
                return categoryDict
            } else {
                return nil
            }
            
        case .ConfigTypePackage:
            if let packageObj = getConfigForKey(DataBaseKeys.packageDictionaryKey) {
                return packageObj
            } else {
                return nil
            }
        
        case .ConfigTypeFirstLaunch:
            return defaults.integer(forKey: DataBaseKeys.firstLaunchKey)
            
        case .ConfigTypeAppUpdateRequired:
            return appUpdateRequired
        
        case .ConfigTypeAppUpdateSuggested:
            return getConfigForKey(DataBaseKeys.appRequiredVerKey)! as! Double > appVersion

        default:
            return nil
        }
    }
    
    /// Handle different data refresh request
    /// It will compare the config(be it packege or category into)'s version number with that of the remote one. It local version is smaller, it will go fetch the new version from the cloud. It will store the pulled data in userDefaults for later reference
    ///
    /// - Parameter type: type for config request
    func handleConfigRequestForType(_ type: ConfigType) {
        switch type {
        case .ConfigTypeCategory:
            // check required category config version
            ref?.child(DataBaseKeys.configDBRef(DataBaseKeys.categoryRequiredVer)).observeSingleEvent(of: .value, with: { (snapshot) in
                let requiredVersion = snapshot.value as! Int
                let localVersion = self.defaults.integer(forKey: DataBaseKeys.categoryVerKey)
                print("Category version required: \(requiredVersion), local: \(localVersion)")
                
                if localVersion < requiredVersion {
                    self.updateCategoryJSON(toVersion: requiredVersion)
                }
            }) { (error) in
                
            }
            break
        
        case .ConfigTypePackage:
            // check required category config version
            ref?.child(DataBaseKeys.configDBRef(DataBaseKeys.packageRequiredVer)).observeSingleEvent(of: .value, with: { (snapshot) in
                let requiredVersion = snapshot.value as! Int
                let localVersion = self.defaults.integer(forKey: DataBaseKeys.packageVerKey)
                print("Package version required: \(requiredVersion), local: \(localVersion)")
                
                if localVersion < requiredVersion {
                    // need to download the new version
                    self.ref.child(DataBaseKeys.packageDictionaryKey).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let packageObj = snapshot.value {
                            // set the new data obj and update the version info
                            self.defaults.set(packageObj, forKey: DataBaseKeys.packageDictionaryKey)
                            self.defaults.set(requiredVersion, forKey: DataBaseKeys.packageVerKey)
                        }
                    }, withCancel: nil) // TODO: mayhave to handle error here
                }
            }) { (error) in
                
            }
            break
            
        case .ConfigTypeAppUpdateRequired:
            // get required version number
            ref?.child(DataBaseKeys.configDBRef(DataBaseKeys.appRequiredVer)).observeSingleEvent(of: .value, with: { (snapshot) in
                let requiredVersion = snapshot.value as! Double
                
                self.defaults.set(requiredVersion, forKey: DataBaseKeys.appRequiredVerKey)
                if requiredVersion > self.appVersion {
                    // display
                    self.displayUpdateAlertForType(.ConfigTypeAppUpdateRequired)
                }
                
            }, withCancel: nil)
            
        case .ConfigTypeAppUpdateSuggested:
            // get required version number
            ref?.child(DataBaseKeys.configDBRef(DataBaseKeys.appSuggestedVer)).observeSingleEvent(of: .value, with: { (snapshot) in
                let suggestedVer = snapshot.value as! Double
                
                self.defaults.set(suggestedVer, forKey: DataBaseKeys.appSuggestedVerKey)
                if suggestedVer > self.appVersion {
                    // display
                    self.displayUpdateAlertForType(.ConfigTypeAppUpdateSuggested)
                }
            }, withCancel: nil)

        default:
            break
        }
    }
    
    /// Displays the alert when app needs update. It will not display the alert twice. The alertView is displayed in appDelegate too, to prevent user resume to the app.
    func displayUpdateAlertForType(_ type: ConfigType) {
        if !isAlertShwon {
            let alertView = UIAlertController(title: "New version available", message: "", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Goto App Store", style: .default, handler: { (_) in
                self.isAlertShwon = false
                let appStoreURLString = RemoteConfig.remoteConfig().configValue(forKey: DataBaseKeys.appStoreLink).stringValue
                UIApplication.shared.open((URL(string: appStoreURLString!)!))
            }))
            
            switch type {
            case .ConfigTypeAppUpdateRequired:
                alertView.message = "Please update the app to newer version"
            case .ConfigTypeAppUpdateSuggested:
                alertView.message = "Please consider updating the app to newer version"
                alertView.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: {(_) in
                    self.isAlertShwon = false
                }))
            default:
                return
            }
            
            // to prevent alert from displaying twice
            self.isAlertShwon = true
            DispatchQueue.main.async {
                alertView.show()
            }
        }
    }
    
    
    /// Pulls new category Json from cloud
    ///
    /// - Parameter ver: the newest version number of config
    func updateCategoryJSON(toVersion ver: Int) {
        Alamofire.request(urlForNetworkAPI(.category)!).responseJSON { (response) in
            switch response.result {
            case .failure(let fail):
                print(fail.localizedDescription)
            default:
                break
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                // store JSON data
                self.storeConfigForKey(DataBaseKeys.categoryDictionaryKey, withData: data)
                print("New config: \(utf8Text)")

                // update the required version number
                self.defaults.set(ver, forKey: DataBaseKeys.categoryVerKey)
            }
        }
    }
    
    
    /// Register user defaults when app first launches
    func configAppFirstLaunch() {
        let initialUserDefaults: [String:Int] = [DataBaseKeys.categoryVerKey: -1,
                                                 DataBaseKeys.packageVerKey: -1,
                                                 DataBaseKeys.firstLaunchKey: 0,
                                                 DataBaseKeys.appRequiredVerKey: 1]
        defaults.register(defaults: initialUserDefaults)
    }
    
    /// Do app refresh at launch, it does: 1. handle remote config, 2. check category/package for necessary update, 3. increment open count
    func configAppLaunch() {
        RemoteConfig.remoteConfig().setDefaults(DataBaseKeys.defaultDict)
        
        // activate the fetched data from last time app is opened
        RemoteConfig.remoteConfig().fetch { (status, error) in
            guard error == nil else {return}
            RemoteConfig.remoteConfig().activateFetched()
        }
        
        // get category update event, the snapshot should be int
        handleConfigRequestForType(.ConfigTypeAppUpdateRequired)
        handleConfigRequestForType(.ConfigTypeAppUpdateSuggested)
        handleConfigRequestForType(.ConfigTypePackage)
        handleConfigRequestForType(.ConfigTypeCategory)
        
        // increment open counter
        defaults.set(defaults.integer(forKey: DataBaseKeys.firstLaunchKey) + 1, forKey: DataBaseKeys.firstLaunchKey)
        print(appVersion)
    }
}

