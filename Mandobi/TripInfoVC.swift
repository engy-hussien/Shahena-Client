//
//  TripInfoVC.swift
//  Mandobi
//
//  Created by Mostafa on 1/27/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class TripInfoVC: LocalizationOrientedViewController {

    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var driverImg: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var tripInfoLvl: UILabel!
    @IBOutlet weak var fromInfoLbl: UILabel!
    @IBOutlet weak var toInfoLbl: UILabel!
    @IBOutlet weak var feesInfoLbl: UILabel!
    @IBOutlet weak var driverInfoLbl: UILabel!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var toLbl: UILabel!
    @IBOutlet weak var feesLbl: UILabel!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var carPlate: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        driverImg.layer.cornerRadius = 0.5 * driverImg.bounds.size.width
        driverImg.clipsToBounds = true
        tripInfoLvl.text = LanguageHelper.getStringLocalized(key: "tripInfo_Info")
        fromInfoLbl.text = LanguageHelper.getStringLocalized(key: "FromInfo_Info")
        toInfoLbl.text = LanguageHelper.getStringLocalized(key: "ToInfo_Info")
        feesInfoLbl.text = LanguageHelper.getStringLocalized(key: "feesInfo_Info")
        driverInfoLbl.text = LanguageHelper.getStringLocalized(key: "driverInfo_info")
        if LanguageHelper.getCurrentLanguage() == "ar"{
            upperView.semanticContentAttribute = .forceRightToLeft
            middleView.semanticContentAttribute = .forceRightToLeft
            tripInfoLvl.textAlignment = .right
            fromInfoLbl.textAlignment = .right
            toInfoLbl.textAlignment = .right
            feesInfoLbl.textAlignment = .right
            driverInfoLbl.textAlignment = .right
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        let driverRate = MainTabBarController.instance.trip.driverRate
        fromLbl.text = MainTabBarController.instance.trip.tripFromAddress
        toLbl.text = MainTabBarController.instance.trip.tripToAddress
        feesLbl.text = MainTabBarController.instance.trip.tripCost
        driverName.text = MainTabBarController.instance.trip.driverName
        carPlate.text = MainTabBarController.instance.trip.driverPlateNo
        var stars = [star1,star2,star3,star4,star5]
        for starIndex in 0..<stars.count {
            if starIndex < driverRate {
                stars[starIndex]?.image = UIImage(named: "star_active")
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
