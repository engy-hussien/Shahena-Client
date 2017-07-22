//
//  DeliveryPopUpVC.swift
//  Mandobi
//
//  Created by Mostafa on 1/26/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class DeliveryPopUpVC: LocalizationOrientedViewController ,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate{

    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var feesLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var reciverLbl: UILabel!
    @IBOutlet weak var deliveryImage: UIImageView!
    @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet weak var feesTxt: UITextField!
    @IBOutlet weak var reciverPhone: UITextField!
    @IBOutlet weak var reciverName: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    static var instance: DeliveryPopUpVC!
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        DeliveryPopUpVC.instance = self
        submitBtn.layer.shadowColor = UIColor.lightGray.cgColor
        submitBtn.layer.shadowOffset = CGSize(width: 0, height: 1)
        submitBtn.layer.shadowOpacity = 1
        submitBtn.layer.shadowRadius = 1
        reciverLbl.text = LanguageHelper.getStringLocalized(key: "reciverName_Delivery")
        phoneLbl.text = LanguageHelper.getStringLocalized(key: "phone_Delivery")
        feesLbl.text = LanguageHelper.getStringLocalized(key: "fees_Delivery")
        descLbl.text = LanguageHelper.getStringLocalized(key: "description_Delivery")
        submitBtn.setTitle(LanguageHelper.getStringLocalized(key: "submit_Delivery"), for: .normal)
        descriptionTxt.layer.cornerRadius = 5
        descriptionTxt.layer.borderWidth = 2
        descriptionTxt.layer.borderColor = UIColor.lightGray.cgColor
        if LanguageHelper.getCurrentLanguage() == "ar"{
            reciverLbl.textAlignment = .right
            phoneLbl.textAlignment = .right
            feesLbl.textAlignment = .right
            descLbl.textAlignment = .right
            reciverName.textAlignment = .right
            reciverPhone.textAlignment = .right
            feesTxt.textAlignment = .right
            descriptionTxt.textAlignment = .right
            self.view.semanticContentAttribute = .forceRightToLeft
        }

    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        deliveryImage.image = selectedImage
        self.dismiss(animated: true, completion: nil)

    }

    
    
    @IBAction func takeImagePressed(_ sender: Any) {
        
        DialogsHelper.getInstance().takeImage(inViewController: self, title: [LanguageHelper.getStringLocalized(key: "imageAlertTitle"),LanguageHelper.getStringLocalized(key: "camera"),LanguageHelper.getStringLocalized(key: "Photo Library"),LanguageHelper.getStringLocalized(key: "imageAlertCancel")])
    }

    @IBAction func sumbitBtn(_ sender: UIButton) {
        
        let formatter: NumberFormatter = NumberFormatter()
        
        formatter.locale = NSLocale(localeIdentifier: "EN") as Locale!
        
        if reciverName.text!.isEmpty || reciverPhone.text!.isEmpty || feesTxt.text!.isEmpty
        {
            DialogsHelper.getInstance().showBottomAlert(msg: LanguageHelper.getStringLocalized(key: "paramCheck"), view: self)
            
        } else if Int(formatter.number(from: feesTxt.text!)!) < 10 {
            DialogsHelper.getInstance().showBottomAlert(msg: LanguageHelper.getStringLocalized(key: "fees_smaller_than_ten"), view: self)
        } else {
        let conToken = UserDefaults.standard.string(forKey: "connToken")
            var str64 = ""
            if deliveryImage.image != UIImage(named: "add_photo") {
                let imageData = UIImageJPEGRepresentation(deliveryImage.image!, 0)
                str64 = (imageData?.base64EncodedString(options: .lineLength64Characters))!
            }
            let param =
                ["connToken":conToken! as AnyObject,
                 "fromLatitude":DeliveryVC.instance.fromLatitude as AnyObject,
                 "fromLongitude":DeliveryVC.instance.fromLongitude as AnyObject,
                 "fromAddress": DeliveryVC.instance.fromTxtField.text! as AnyObject,
                 "toLatitude":DeliveryVC.instance.toLatitude as AnyObject,
                 "toLongitude":DeliveryVC.instance.toLongitude as AnyObject,
                 "toAddress":DeliveryVC.instance.toTxtField.text! as AnyObject,
//                 "clientId":conToken! as AnyObject,
                 "type":"deliver" as AnyObject,
                 "receiverName":reciverName.text! as AnyObject,
                 "receiverPhone":reciverPhone.text! as AnyObject,
                 "description":descriptionTxt.text! as AnyObject,
                 "amount":feesTxt.text! as AnyObject,
                 "image": str64 as AnyObject,
                 "distance": DeliveryVC.instance.calcDistance as AnyObject
            ]
            print(param)
            SocketIOController.emitEvent(event: SocketEvents.REQUEST_ORDER, withParameters: param as [String : AnyObject])
            self.dismiss(animated: true, completion: nil)
            DeliveryVC.instance.showLoading()
            
            MainTabBarController.instance.trip = Trip(tripId: "",tripType: "deliver", tripCost: feesTxt.text!, tripFromAddress: DeliveryVC.instance.fromTxtField.text!, tripToAddress: DeliveryVC.instance.toTxtField.text!, driverToken: "", driverName: "", driverPhoneNo: "",driverRate: 0, driverImgUrl: "", driverPlateNo: "", fromLat: DeliveryVC.instance.fromLatitude, fromLng: DeliveryVC.instance.fromLongitude, toLat: DeliveryVC.instance.toLatitude, toLng: DeliveryVC.instance.toLongitude, tripPoints: [],messages: [],tripStarted: false)
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        DeliveryVC.instance.fromTxtField.text = ""
        DeliveryVC.instance.toTxtField.text = ""
        DeliveryVC.instance.headerView.isHidden = true
        DeliveryVC.instance.bringBtn.setImage(UIImage(named:LanguageHelper.getStringLocalized(key: "BringinActive")
        ), for: .normal)
        DeliveryVC.instance.deliverBtn.setImage(UIImage(named:LanguageHelper.getStringLocalized(key: "DeliveryinActive")
        ), for: .normal)
        DeliveryVC.instance.currentAddressTop.constant = 25
    }
    

}
