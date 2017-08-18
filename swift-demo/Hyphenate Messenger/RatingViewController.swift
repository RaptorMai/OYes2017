//
//  ViewController.swift
//  Rating Demo
//
//  Created by Glen Yi on 2014-09-05.
//  Copyright (c) 2014 On The Pursuit. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController, FloatRatingViewDelegate {
    
    @IBOutlet var ratingSegmentedControl: UISegmentedControl!
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet var liveLabel: UILabel!
    @IBOutlet var updatedLabel: UILabel!
    
    var delegate : DismissProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /** Note: With the exception of contentMode, all of these
            properties can be set directly in Interface builder **/
        
        // Required float rating view params
        self.floatRatingView.emptyImage = UIImage(named: "StarEmpty")
        self.floatRatingView.fullImage = UIImage(named: "StarFull")
        // Optional params
        self.floatRatingView.delegate = self
        self.floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
        self.floatRatingView.maxRating = 5
        self.floatRatingView.minRating = 1
        self.floatRatingView.rating = 2.5
        self.floatRatingView.editable = true
        self.floatRatingView.halfRatings = true
        self.floatRatingView.floatRatings = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitRating(_ sender: Any) {
        
        //TODO: submit rating to DB below
        print(self.floatRatingView.rating)
        
        self.dismiss(animated:true, completion:nil)
//        delegate?.dismissParentVC()
        let mainVC = MainViewController()
        HyphenateMessengerHelper.sharedInstance.mainVC = mainVC
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.proceedLogin()
    }
    
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
        //print(self.floatRatingView.rating)
        //self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        //print(self.floatRatingView.rating)
        //.updatedLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
    
}

