import UIKit
import EAIntroView

class IntroScreenViewController: UIViewController, EAIntroDelegate {
    @IBOutlet weak var introView: EAIntroView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        EAIntroPage *page2 = [EAIntroPage page];
//        page2.title = @"This is page 2";
//        page2.titleFont = [UIFont fontWithName:@"Georgia-BoldItalic" size:20];
//        page2.titlePositionY = 220;
//        page2.desc = sampleDescription2;
//        page2.descFont = [UIFont fontWithName:@"Georgia-Italic" size:18];
//        page2.descPositionY = 200;
//        page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
//        page2.titleIconPositionY = 100;
        setPages()
        introView.show(in: view)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setPages() {
        let page1 = EAIntroPage()
//        page1.title = "Hello instasolve"
//        page1.titleFont = UIFont(name: "Georgia-BoldItalic", size: 20)
//        page1.titlePositionY = 220
        page1.bgImage = UIImage(named: "intro1")
        
        let page2 = EAIntroPage()
        page2.bgImage = UIImage(named: "intro2")
        
//        let page3 = EAIntroPage()
//        page3.bgImage = UIImage(named: "intro3")

        introView.pages = [page1, page2]
        
        introView.skipButton.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        introView.skipButton.backgroundColor = UIColor.black
        introView.skipButton.layer.masksToBounds = true
        introView.skipButton.layer.cornerRadius = 5.0
        introView.skipButton.alpha = 0.8
        
        introView.skipButton.isHidden = true
        introView.pageControl.pageIndicatorTintColor = UIColor.gray
        introView.pageControl.currentPageIndicatorTintColor = UIColor.black
        
        introView.delegate = self
        introView.tapToNext = true
    }
    
    // MARK: - Intro delegate
    func introDidFinish(_ introView: EAIntroView!, wasSkipped: Bool) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // present vc
    
    func show() {
        present(animated: true, completion: nil)
    }
    
    func present(animated: Bool, completion: (() -> Void)?) {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            presentFromController(controller: rootVC, animated: animated, completion: completion)
        }
    }
    
    private func presentFromController(controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let navVC = controller as? UINavigationController,
            let visibleVC = navVC.visibleViewController {
            presentFromController(controller: visibleVC, animated: animated, completion: completion)
        } else
            if let tabVC = controller as? UITabBarController,
                let selectedVC = tabVC.selectedViewController {
                presentFromController(controller: selectedVC, animated: animated, completion: completion)
            } else {
                controller.present(self, animated: animated, completion: completion);
        }
    }

}
