import UIKit
import FirebaseDatabase

class TutorConnectedVC: UIViewController {

    var questionImage: UIImage?
    var questionDescription: String?
    var didStudentCickOkAfterTutorinChat = false
    var ref: DatabaseReference? = Database.database().reference()
    var tid: String?
    var category: String?
    var qid: String?
    //connected is used to check if chatVC has been pushed
    var connected = false
    @IBOutlet weak var profilePhotoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    navigationController?.setNavigationBarHidden(false, animated: false)
        
        profilePhotoView.layer.borderWidth = 1
        profilePhotoView.layer.masksToBounds = false
        profilePhotoView.layer.borderColor = UIColor.black.cgColor
        profilePhotoView.layer.cornerRadius = profilePhotoView.frame.height/2
        profilePhotoView.clipsToBounds = true

        ref?.child("tutors/\(self.tid!)/profilePhoto").observeSingleEvent(of:.value, with:
            {(snapshot) in
            print(snapshot.value as! String)
            let profilePhotoURL = URL(string: snapshot.value as! String)
            self.profilePhotoView.sd_setImage(with: profilePhotoURL)

        }) {(error) in print(error.localizedDescription)}
        navigationController?.navigationBar.isUserInteractionEnabled = false
        navigationItem.setHidesBackButton(true, animated: true)
        showActivityIndicator()
        //handle is the observer, used to remove observer
        var handle:UInt = 0
        //check is status is 2, if yes, push chatVC
        handle = (self.ref?.child("Request/active/\(self.category!)/\(self.qid!)/status").observe(DataEventType.value, with: { (snapshot) in
            if let status = snapshot.value as? Int{
                if status == TutorStatus.ready.rawValue && !self.connected {
                    self.connected = true
                    self.ref?.removeObserver(withHandle: handle)
                    self.startChatwithTutor(tid: self.tid!, image: self.questionImage!, description: self.questionDescription!)
                }
            }
            
        }){ (error) in
            print(error.localizedDescription)
            })!
    }
    
    func startChatwithTutor(tid: String, image: UIImage, description: String){
        //code is copied from startChatting in summaryVC
        let timeStamp = ["SessionId":String(Date().ticks)]
        let sessionController = ChatTableViewController(conversationID: tid, conversationType: EMConversationTypeChat, initWithExt: timeStamp)
        sessionController?.key = self.qid!
        sessionController?.category = self.category!
        //check if description was entered.
        var isDescriptionEntered: Bool?
        if description == "No Description Available" {
            isDescriptionEntered = false
        } else {
            isDescriptionEntered = true
        }
        
        self.navigationController?.isNavigationBarHidden = false
        if let sessContr = sessionController{
            sessContr.questionimage = image
            if isDescriptionEntered == true{
                sessContr.questiondescription = description
            }
            self.navigationController?.pushViewController(sessContr, animated: true)
        }
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

