//
//  InfoViewController.swift
//  MandobiDriver
//
//  Created by ِAmr on 1/26/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

import UIKit

class InfoViewController: LocalizationOrientedViewController {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var fromAddress: UILabel!
    @IBOutlet weak var to: UILabel!
    @IBOutlet weak var toAddress: UILabel!
    @IBOutlet weak var sentTo: UILabel!
    @IBOutlet weak var sentToPerson: UILabel!
    @IBOutlet weak var fees: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var currency: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        from.text = LanguageHelper.getStringLocalized(key: "from")
        to.text = LanguageHelper.getStringLocalized(key: "to")
        sentTo.text = LanguageHelper.getStringLocalized(key: "sent_to")
        fees.text = LanguageHelper.getStringLocalized(key: "fees")
        currency.text = LanguageHelper.getStringLocalized(key: "sar")
    }

}
