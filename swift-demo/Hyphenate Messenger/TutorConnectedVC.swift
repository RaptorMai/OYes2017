import UIKit
import FirebaseDatabase

class TutorConnectedVC: UIViewController {
    var requestdict: [String: Any]? = nil
    var questionImage: UIImage?
    var questionDescription: String?
    var didStudentCickOkAfterTutorinChat = false
    var delegate: TutorConnectedDelegate?
    var ref: DatabaseReference? = Database.database().reference()
    @IBOutlet weak var profilePhotoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    navigationController?.setNavigationBarHidden(false, animated: false)
        
        profilePhotoView.layer.borderWidth = 1
        profilePhotoView.layer.masksToBounds = false
        profilePhotoView.layer.borderColor = UIColor.black.cgColor
        profilePhotoView.layer.cornerRadius = profilePhotoView.frame.height/2
        profilePhotoView.clipsToBounds = true

        let uid = requestdict?["username"] as! String
        ref?.child("tutors/\(uid)/profilePhoto").observeSingleEvent(of:.value, with:
            {(snapshot) in
            print(snapshot.value as! String)
            let profilePhotoURL = URL(string: snapshot.value as! String)
            self.profilePhotoView.sd_setImage(with: profilePhotoURL)

        }) {(error) in print(error.localizedDescription)}
       /* if let profilePhotoURLString = requestdict?[""] {
            let profilePhotoURL = URL(string: profilePhotoURLString as! String)
            profilePhotoView.sd_setImage(with: profilePhotoURL)
        }*/
        
        //if the student clicks ok on previous alert after the tutor is in the session, hence didStudentClickOkAfterTutorinChat = true, we call the start chat with tutor, else we modify the observer again so that it calls startchatwithtutor once a notification is recieved
        if didStudentCickOkAfterTutorinChat == true {
            startChatwithTutor()
        } else{
            NotificationCenter.default.addObserver(self, selector: #selector(startChatwithTutor), name: NSNotification.Name(rawValue: "kNotification_didReceiveRequest"), object: nil)
        }
        navigationController?.navigationBar.isUserInteractionEnabled = false
        navigationItem.setHidesBackButton(true, animated: true)
        showActivityIndicator()
    }
    
    func startChatwithTutor(){
        //Remove observer for friend request notification
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "kNotification_didReceiveRequest"), object: nil)
        delegate?.startChatting(requestDict: self.requestdict!, image: self.questionImage!, description: self.questionDescription!)
    }
    
    func showActivityIndicator() {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        activityIndicatorView.color = UIColor.white
        activityIndicatorView.startAnimating()
        
        let titleLabel = UILabel()
        titleLabel.text = "Connected..."
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.white
        
        let fittingSize = titleLabel.sizeThatFits(CGSize(width: 200.0, height: activityIndicatorView.frame.size.height))
        titleLabel.frame = CGRect(x:0 /*activityIndicatorView.frame.origin.x + activityIndicatorView.frame.size.width + 8*/, y:0/* activityIndicatorView.frame.origin.y*/, width: fittingSize.width, height: fittingSize.height)
        activityIndicatorView.frame = CGRect(x: titleLabel.frame.origin.x + titleLabel.frame.size.width + 8, y: titleLabel.frame.origin.y, width: 18, height: 18)

        
        let titleView = UIView(frame: CGRect(x: ((activityIndicatorView.frame.size.width + 8 + titleLabel.frame.size.width) / 2), y: ((activityIndicatorView.frame.size.height) / 2), width: (activityIndicatorView.frame.size.width + 8 + titleLabel.frame.size.width), height : (activityIndicatorView.frame.size.height)))
        titleView.addSubview(activityIndicatorView)
        titleView.addSubview(titleLabel)
        
        self.navigationItem.titleView = titleView
    }
    
    func hideActivityIndicator() {
        self.navigationItem.titleView = nil
    }
}

protocol TutorConnectedDelegate{
    func startChatting(requestDict:[String: Any], image: UIImage, description: String)
}
