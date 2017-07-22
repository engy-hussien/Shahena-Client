//
//  BringPopUpVC.swift
//  Mandobi
//
//  Created by Mostafa on 1/26/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class BringPopUpVC: LocalizationOrientedViewController ,UIPopoverPresentationControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate{
    
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var descripLbl: UILabel!
    @IBOutlet weak var feesLbl: UILabel!
    @IBOutlet weak var recomendedLbl: UILabel!
    @IBOutlet weak var customCategoryLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var bringImage: UIImageView!
    @IBOutlet weak var feesTxt: UITextField!
    @IBOutlet weak var customTxt: UITextField!
    @IBOutlet weak var recomendedTxt: UITextField!
    @IBOutlet weak var descriptiontxt: UITextView!
    @IBOutlet weak var cotegoryLbl: UILabel!
    var catName :String!
    var catID = ""
    let defaults = UserDefaults.standard
    static var instance: BringPopUpVC!
    override func viewDidLoad() {
        super.viewDidLoad()
        BringPopUpVC.instance = self
        categoryLbl.text = LanguageHelper.getStringLocalized(key: "categoryLbl_Bring")
        customCategoryLbl.text = LanguageHelper.getStringLocalized(key: "customCategory_Bring")
        recomendedLbl.text = LanguageHelper.getStringLocalized(key: "recommendedPlace_Bring")
        feesLbl.text = LanguageHelper.getStringLocalized(key: "feesLbl_Bring")
        descripLbl.text = LanguageHelper.getStringLocalized(key: "descrip_Bring")
        submitBtn.setTitle(LanguageHelper.getStringLocalized(key: "submit_Bring"), for: .normal)
        cotegoryLbl.text = LanguageHelper.getStringLocalized(key: "categoryCustom")
        descriptiontxt.layer.cornerRadius = 5
        descriptiontxt.layer.borderColor = UIColor.lightGray.cgColor
        descriptiontxt.layer.borderWidth = 2
        customCategoryLbl.isHidden = true
        customTxt.isHidden = true
        customView.isHidden = true

        
        if LanguageHelper.getCurrentLanguage() == "ar"{
            categoryLbl.textAlignment = .right
            customCategoryLbl.textAlignment = .right
            recomendedLbl.textAlignment = .right
            feesLbl.textAlignment = .right
            descripLbl.textAlignment = .right
            customTxt.textAlignment = .right
            recomendedTxt.textAlignment = .right
            feesTxt.textAlignment = .right
            descriptiontxt.textAlignment = .right
            cotegoryLbl.textAlignment = .right
            categoryBtn.contentHorizontalAlignment = .left
            self.view.semanticContentAttribute = .forceRightToLeft
        }
        
    }
    func showCustomeFiled(_ Check: Bool)
    {
        customCategoryLbl.isHidden = Check
        customTxt.isHidden = Check
        customView.isHidden = Check
        
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

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return.none
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        bringImage.image = selectedImage
        self.dismiss(animated: true, completion: nil)
        
    }

    @IBAction func unwindToCategory(_ segue:UIStoryboardSegue)
    {
        if let categoryTabelView = segue.source as? CategoryTableVC,
            let selectedCategory = categoryTabelView.catgoryName{
            catName = selectedCategory
            cotegoryLbl.text = self.catName
            
            let selectedCategoryID = categoryTabelView.catgoryID
            if selectedCategoryID == -1{
                print("here")
                catID = ""

            }
            else{
                catID = "\(selectedCategoryID!)"

            }
            print(catID)
            
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "popUp"   {
            let vc = segue.destination as! CategoryTableVC
            let controller = vc.popoverPresentationController
            vc.preferredContentSize = CGSize(width: 200,height: 250)
            
            controller?.sourceRect = CGRect(x: 100, y: 20, width: 0, height: 0)
            controller?.permittedArrowDirections = .up
            if controller != nil
            {
                controller?.delegate = self
                
            }
            
        }
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        
        let formatter: NumberFormatter = NumberFormatter()
        
        formatter.locale = NSLocale(localeIdentifier: "EN") as Locale!
        
        if feesTxt.text!.isEmpty
        {
            DialogsHelper.getInstance().showBottomAlert(msg: LanguageHelper.getStringLocalized(key: "paramCheck"), view: self)
            
        } else if Int(formatter.number(from: feesTxt.text!)!) < 10 {
            DialogsHelper.getInstance().showBottomAlert(msg: LanguageHelper.getStringLocalized(key: "fees_smaller_than_ten"), view: self)
        } else {
        let conToken = UserDefaults.standard.string(forKey: "connToken")
            
            var str64 = ""
            if bringImage.image != UIImage(named: "add_photo") {
                let imageData = UIImageJPEGRepresentation(bringImage.image!, 0)
                str64 = (imageData?.base64EncodedString(options: .lineLength64Characters))!
            }

        
        let param = ["connToken":conToken! as AnyObject,
                     "recommendedPlace": recomendedTxt.text as AnyObject,
                     "amount": feesTxt.text as AnyObject,
                     "categoryId":catID as AnyObject,
                     "description":descriptiontxt.text as AnyObject,
                     "toLatitude":DeliveryVC.instance.toLatitude as AnyObject,
                     "toLongitude":DeliveryVC.instance.toLongitude as AnyObject,
                     "fromLatitude":DeliveryVC.instance.fromLatitude as AnyObject,
                     "fromLongitude":DeliveryVC.instance.fromLongitude as AnyObject,
                     "fromAddress":DeliveryVC.instance.fromTxtField.text as AnyObject,
                     "toAddress":DeliveryVC.instance.toTxtField.text as AnyObject,
                     "type":"bring" as AnyObject,
//                     "clientId":conToken! as AnyObject,
                     "image": str64 as AnyObject,
                     "customeCategory": customTxt.text as AnyObject,
                     "distance": DeliveryVC.instance.calcDistance as AnyObject
                     ]
        print(param)
        SocketIOController.emitEvent(event: SocketEvents.REQUEST_ORDER, withParameters: param as [String : AnyObject])
            self.dismiss(animated: true, completion: nil)
            DeliveryVC.instance.showLoading()
            
            MainTabBarController.instance.trip = Trip(tripId: "",tripType: "bring", tripCost: feesTxt.text!, tripFromAddress: DeliveryVC.instance.fromTxtField.text!, tripToAddress: DeliveryVC.instance.toTxtField.text!, driverToken: "", driverName: "", driverPhoneNo: "",driverRate: 0, driverImgUrl: "", driverPlateNo: "", fromLat: DeliveryVC.instance.fromLatitude, fromLng: DeliveryVC.instance.fromLongitude, toLat: DeliveryVC.instance.toLatitude, toLng: DeliveryVC.instance.toLongitude, tripPoints: [],messages: [],tripStarted: false)
        
        }
    }
    
    @IBAction func takeImagePressed(_ sender: Any) {
        DialogsHelper.getInstance().takeImage(inViewController: self, title: [LanguageHelper.getStringLocalized(key: "imageAlertTitle"),LanguageHelper.getStringLocalized(key: "camera"),LanguageHelper.getStringLocalized(key: "Photo Library"),LanguageHelper.getStringLocalized(key: "imageAlertCancel")])

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
