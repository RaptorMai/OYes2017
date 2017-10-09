import Foundation
import Firebase
import Hyphenate

enum LoginViewControllerMode {
    case login
    case signup
}

// MARK: - Verification code request
func requestCode(forNumber num: String) {
    // checking phone number directly is fine: this function should never be called before verifying phone number
    PhoneAuthProvider.provider().verifyPhoneNumber("+1\(num)") { (verificationID, error) in
        if error != nil {
            print (" error: \(String(describing: error?.localizedDescription))")
        } else {
            let defaults = UserDefaults.standard
            defaults.set(verificationID, forKey: "authVID")
        }
    }
}
