import Foundation
import Firebase


enum NetworkAPI: String {
    case category = "getCategory"
    case cancel = "cancel"
}

func urlForNetworkAPI(_ api: NetworkAPI) -> URL? {
    // get the baseURLe from firebase
    if let baseURL = RemoteConfig.remoteConfig().configValue(forKey: DataBaseKeys.serverAddress).stringValue {
        return URL(string: ["http:/", baseURL, api.rawValue].joined(separator: "/"))
    } else {
        return nil
    }
}
