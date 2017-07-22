//
//  MyWalletVC.swift
//  Mandobi
//
//  Created by Mostafa on 1/18/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class MyWalletVC: LocalizationOrientedViewController , UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var promoCodeLbl: UILabel!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var transcationLbl: UILabel!
    @IBOutlet weak var useLbl: UILabel!
    @IBOutlet weak var creditLbl: UILabel!
    @IBOutlet weak var cerditBtn: UIButton!
    @IBOutlet weak var cashOnBtn: UIButton!
    @IBOutlet weak var creditView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creditView.layer.borderWidth = 0.5
        creditView.layer.borderColor = UIColor.lightGray.cgColor

    }
    
    override func viewWillAppear(_ animated: Bool) {
        promoCodeLbl.text = LanguageHelper.getStringLocalized(key: "promo_code")
        addBtn.setTitle(LanguageHelper.getStringLocalized(key: "add"), for: .normal)
        cashOnBtn.setTitle(LanguageHelper.getStringLocalized(key: "cashOnDelicer_Btn"), for: .normal)
        cerditBtn.setTitle(LanguageHelper.getStringLocalized(key: "creditCard_Btn"), for: .normal)
        creditLbl.text = LanguageHelper.getStringLocalized(key: "creditLbl")
        useLbl.text = LanguageHelper.getStringLocalized(key: "use_Credit")
        transcationLbl.text = LanguageHelper.getStringLocalized(key: "transactionLbl")
        self.navigationItem.title = LanguageHelper.getStringLocalized(key: "wallet_tab")
        
        self.tabBarController?.tabBar.items?[2].title = LanguageHelper.getStringLocalized(key: "wallet_tab")
        if LanguageHelper.getCurrentLanguage() == "ar"{
            self.view.semanticContentAttribute = .forceRightToLeft
            self.upperView.semanticContentAttribute = .forceRightToLeft
            self.creditView.semanticContentAttribute = .forceRightToLeft
            cashOnBtn.contentHorizontalAlignment = .right
            cerditBtn.contentHorizontalAlignment = .right
            creditLbl.textAlignment = .right
            useLbl.textAlignment = .right
            transcationLbl.textAlignment = .right
            promoCodeLbl.textAlignment = .right
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @IBAction func AddPressed(_ sender: UIButton) {
        DialogsHelper.getInstance().showSmallPopUp(inViewController: self, popUp: UIStoryboard(name: "PopUps", bundle: nil).instantiateViewController(withIdentifier: "promotion"))
    }

}
