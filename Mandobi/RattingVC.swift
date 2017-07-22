//
//  RattingVC.swift
//  Mandobi
//
//  Created by Mostafa on 1/28/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class RattingVC: LocalizationOrientedViewController ,UITextViewDelegate{

    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var feesLabel: UILabel!
    @IBOutlet weak var commentTxt: UITextView!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var feesLbl: UILabel!
    @IBOutlet weak var star5Btn: UIButton!
    @IBOutlet weak var star4Btn: UIButton!
    @IBOutlet weak var star3Btn: UIButton!
    @IBOutlet weak var star2Btn: UIButton!
    @IBOutlet weak var star1Btn: UIButton!
    @IBOutlet weak var driverImg: UIImageView!
    @IBOutlet weak var submitBtn: UIButton!
    var counterRatting = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        submitBtn.layer.shadowColor = UIColor.lightGray.cgColor
        submitBtn.layer.shadowOffset = CGSize(width: 0, height: 1)
        submitBtn.layer.shadowOpacity = 1
        submitBtn.layer.shadowRadius = 1
        driverImg.layer.cornerRadius = 0.5 * driverImg.bounds.size.width
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let result = formatter.string(from: date)
        dateLbl.text = result
        feesLbl.text = MainTabBarController.instance.trip.tripCost
        driverName.text = MainTabBarController.instance.trip.driverName

    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        dateLabel.text = LanguageHelper.getStringLocalized(key: "Date_Ratting")
        feesLabel.text = LanguageHelper.getStringLocalized(key: "Fees_Ratting")
        commentLabel.text = LanguageHelper.getStringLocalized(key: "AddComment_Ratting")
        submitBtn.setTitle(LanguageHelper.getStringLocalized(key: "Submit_Ratting"), for: .normal)
        if LanguageHelper.getCurrentLanguage() == "ar"{
            
            upperView.semanticContentAttribute = .forceRightToLeft
            middleView.semanticContentAttribute = .forceRightToLeft
            commentLabel.textAlignment = .right
            commentTxt.textAlignment = .right
            
        }

    
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        MainTabBarController.instance.trip = nil
    }
    
    @IBAction func star5Btn(_ sender: UIButton) {
        star5Btn.setImage(UIImage(named: "star_active"), for: UIControlState.normal)
        star4Btn.setImage(UIImage(named: "star_active"), for: UIControlState.normal)
        star3Btn.setImage(UIImage(named: "star_active"), for: UIControlState.normal)
        star2Btn.setImage(UIImage(named: "star_active"), for: UIControlState.normal)
        star1Btn.setImage(UIImage(named: "star_active"), for: UIControlState.normal)
        counterRatting = 5

    }

    @IBAction func star4Btn(_ sender: UIButton) {
        
        star5Btn.setImage(UIImage(named: "star_inactive"), for: UIControlState.normal)
        star4Btn.setImage(UIImage(named: "star_active"), for: UIControlState.normal)
        star3Btn.setImage(UIImage(named: "star_active"), for: UIControlState.normal)
        star2Btn.setImage(UIImage(named: "star_active"), for: UIControlState.normal)
        star1Btn.setImage(UIImage(named: "star_active"), for: UIControlState.normal)
        counterRatting = 4

    }
    
    @IBAction func star3Btn(_ sender: UIButton) {
        star5Btn.setImage(UIImage(named: "star_inactive"), for: UIControlState.normal)
        star4Btn.setImage(UIImage(named: "star_inactive"), for: UIControlState.normal)
        star3Btn.setImage(UIImage(named: "star_active"), for: UIControlState.normal)
        star2Btn.setImage(UIImage(named: "star_active"), for: UIControlState.normal)
        star1Btn.setImage(UIImage(named: "star_active"), for: UIControlState.normal)
        counterRatting = 3

    }
    
    @IBAction func star2Btn(_ sender: UIButton) {
        star5Btn.setImage(UIImage(named: "star_inactive"), for: UIControlState.normal)
        star4Btn.setImage(UIImage(named: "star_inactive"), for: UIControlState.normal)
        star3Btn.setImage(UIImage(named: "star_inactive"), for: UIControlState.normal)
        star2Btn.setImage(UIImage(named: "star_active"), for: UIControlState.normal)
        star1Btn.setImage(UIImage(named: "star_active"), for: UIControlState.normal)
        counterRatting = 2
    }
    
    @IBAction func star1Btn(_ sender: UIButton) {
        star5Btn.setImage(UIImage(named: "star_inactive"), for: UIControlState.normal)
        star4Btn.setImage(UIImage(named: "star_inactive"), for: UIControlState.normal)
        star3Btn.setImage(UIImage(named: "star_inactive"), for: UIControlState.normal)
        star2Btn.setImage(UIImage(named: "star_inactive"), for: UIControlState.normal)
        star1Btn.setImage(UIImage(named: "star_active"), for: UIControlState.normal)
        counterRatting = 1

    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        if counterRatting == 0
        {
            DialogsHelper.getInstance().showBottomAlert(msg:LanguageHelper.getStringLocalized(key: "rattingAlert"), view: self)
            
        }
        else
        {
            let conToken = UserDefaults.standard.string(forKey: "connToken")
//            let driverToken = UserDefaults.standard.string(forKey: "driverToken")
            let orderID = MainTabBarController.instance.trip.tripId
            let param = ["connToken": conToken as AnyObject,
                         "driverToken":MainTabBarController.instance.trip.driverToken as AnyObject,
                         "orderId":orderID as AnyObject,
                         "rate": counterRatting ,
                         "comment": commentTxt.text!
                       ] as [String : Any]
            print(param)
            SocketIOController.emitEvent(event: SocketEvents.REVIEW_DRIVER, withParameters: param as [String : AnyObject])
            self.dismiss(animated: true, completion: nil)
 
            
        }
    }
    
    
   
}
