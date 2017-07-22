//
//  EditProfileVC.swift
//  Mandobi
//
//  Created by Mostafa on 1/30/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class EditProfileVC: LocalizationOrientedViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate{

    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    @IBOutlet weak var usesrImage: UIImageView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var newPasswordLbl: UILabel!
    @IBOutlet weak var oldPasswordLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var fullNameTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var emailtxt: UITextField!
    @IBOutlet weak var oldPassTxt: UITextField!
    @IBOutlet weak var newPasstxt: UITextField!
    var userFullName: String!
    var userPhone: String!
    var userEmail: String!
    var userImage: String!
    let url = Links()
    let post = Request()
    static var instance: EditProfileVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EditProfileVC.instance = self
        fullNameTxt.text = userFullName
        phoneTxt.text = userPhone
        emailtxt.text = userEmail
//        bottomConst.constant = 40

        

        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        fullNameLbl.text = LanguageHelper.getStringLocalized(key: "fullName_edit")
        phoneNumberLbl.text = LanguageHelper.getStringLocalized(key: "phoneNumber_edit")
        emailLbl.text = LanguageHelper.getStringLocalized(key: "email_edit")
        oldPasswordLbl.text = LanguageHelper.getStringLocalized(key: "oldPassword_edit")
        newPasswordLbl.text = LanguageHelper.getStringLocalized(key: "newPassword_edit")
        sendBtn.setTitle(LanguageHelper.getStringLocalized(key: "submit_edit"), for: .normal)
        cancelBtn.setTitle(LanguageHelper.getStringLocalized(key: "close_edit"), for: .normal)
        if LanguageHelper.getCurrentLanguage() == "ar"{
            fullNameLbl.textAlignment = .right
            fullNameTxt.textAlignment = .right
            phoneTxt.textAlignment = .right
            emailtxt.textAlignment = .right
            oldPassTxt.textAlignment = .right
            newPasstxt.textAlignment = .right
            phoneNumberLbl.textAlignment = .right
            oldPasswordLbl.textAlignment = .right
            newPasswordLbl.textAlignment = .right
            emailLbl.textAlignment = .right
            self.view.semanticContentAttribute = .forceRightToLeft
            
        }



    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        usesrImage.image = selectedImage
        self.dismiss(animated: true, completion: nil)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func takePhotoPressed(_ sender: UIButton) {
        DialogsHelper.getInstance().takeImage(inViewController: self, title: [LanguageHelper.getStringLocalized(key: "imageAlertTitle"),LanguageHelper.getStringLocalized(key: "camera"),LanguageHelper.getStringLocalized(key: "Photo Library"),LanguageHelper.getStringLocalized(key: "imageAlertCancel")])

    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        SettingsVC.instance.hideEditView()
    }
    
    @IBAction func submit(_ sender: UIButton) {
        self.view.endEditing(true)
        let userID = UserDefaults.standard.string(forKey: "user_ID")
        let param = "id=\(userID!)&email=\(emailtxt.text!)&password=\(newPasstxt.text!)&old_password=\(oldPassTxt.text!)&phone=\(phoneTxt.text!)&f_name=\(fullNameTxt.text!)"
        print(param)
        
        post.post(url: url.BASE_URL + "client/users/update-profile" + url.AUTH_PARAMETERS, params: param, view: self) { _ in
            
            let alert = DialogsHelper()
            alert.showAlertDialog(inViewController: self, title:LanguageHelper.getStringLocalized(key: "editAlertTitle"), message: LanguageHelper.getStringLocalized(key: "editAlertMessage"), completion: { (userAction) in
                if userAction{
                    SettingsVC.instance.profileUpdated(self.fullNameTxt.text!, self.phoneTxt.text!, self.emailtxt.text!)
                    
                }
            })
            
        }
    }
}
