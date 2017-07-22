//
//  PromotionViewController.swift
//  Mandobi
//
//  Created by ِAmr on 2/27/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class PromotionViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var topLbl: UILabel!
    @IBOutlet weak var promotionTxtFld: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    let url = Links()
    
    var presentingView : UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentingView = presentingViewController!
        topLbl.text = LanguageHelper.getStringLocalized(key: "add_promotion_code")
        addBtn.setTitle(LanguageHelper.getStringLocalized(key: "add"), for: .normal)
        cancelBtn.setTitle(LanguageHelper.getStringLocalized(key: "cancel"), for: .normal)

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    @IBAction func addPressed(_ sender: Any) {
        if promotionTxtFld.text == "" {
            DialogsHelper.getInstance().showBottomAlert(msg: LanguageHelper.getStringLocalized(key: "enter_promo") ,view: self)
        } else {
            dismiss(animated: true, completion: nil)
            
            let userID = UserDefaults.standard.string(forKey: "user_ID")
            let params = "user_id=\(userID!)&promotion=\(promotionTxtFld.text!)"
            
            Request.getInstance().post(url: url.BASE_URL + "client/wallet/add-credit" + url.AUTH_PARAMETERS, params: params, view: self.presentingViewController!, completion: {_ in
                DialogsHelper.getInstance().showAlertDialogWithOkOnly(inViewController: self.presentingView, title: "", message: LanguageHelper.getStringLocalized(key: "promo_added"), completion: {_ in })
            })
        }
    }
    
    @IBAction func cancelPreseed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
