//
//  SettingsVC.swift
//  Mandobi
//
//  Created by Mostafa on 1/18/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class SettingsVC: LocalizationOrientedViewController {

    @IBOutlet weak var langView: UIView!
    @IBOutlet weak var signOutBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var arabicBtn: UIButton!
    @IBOutlet weak var englishBtn: UIButton!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var userEmailAddress: UILabel!
    @IBOutlet weak var userPhoneNumber: UILabel!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    
    let url = Links()
    let post = Request()
    var userEmail: String!
    var userPhone:String!
    var userImages: String!
    var fullName: String!
    let defaults = UserDefaults.standard
    static var instance: SettingsVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingsVC.instance = self
        userImage.layer.cornerRadius = 0.5 * userImage.bounds.size.width
        userImage.clipsToBounds = true
        editView.isHidden = true
        let userID = UserDefaults.standard.string(forKey: "user_ID")
        let param = "id=\(userID!)"
        post.post(url: url.BASE_URL + "client/users/view-profile" + url.AUTH_PARAMETERS, params: param, view: self) { (data) in
            print("data\(data)")
            self.userEmail = data["email"] as! String
            self.userPhone = data["phone"] as! String
            self.userImages = data["image"] is String ? data["image"] as! String : ""
            self.fullName = data["f_name"] as! String
            self.userFullName.text = self.fullName
            self.userPhoneNumber.text = self.userPhone
            self.userEmailAddress.text = self.userEmail
        }
    }
    
    func hideEditView()
    {
        editView.isHidden = true
    }
    
    func profileUpdated(_ fullName: String,_ userPhone: String,_ userEmail: String)
    {
        editView.isHidden = true
        self.userFullName.text = fullName
        self.userPhoneNumber.text = userPhone
        self.userEmailAddress.text = userEmail
        self.fullName = fullName
        self.userEmail = userEmail
        self.userPhone = userPhone
    }
    
    override func viewWillAppear(_ animated: Bool) {
        editView.isHidden = true
        fullNameLbl.text = LanguageHelper.getStringLocalized(key: "fullName_Setting")
        phoneNumberLbl.text = LanguageHelper.getStringLocalized(key: "phoneNumber_Setting")
        emailLbl.text = LanguageHelper.getStringLocalized(key: "email_Setting")
        languageLbl.text = LanguageHelper.getStringLocalized(key: "language_Setting")        
        editBtn.setTitle(LanguageHelper.getStringLocalized(key: "editBtn_Setting"), for: .normal)
        signOutBtn.setTitle(LanguageHelper.getStringLocalized(key: "signOutBtn_Setting"), for: .normal)
        arabicBtn.setTitle(LanguageHelper.getStringLocalized(key: "arabicBtn"), for: .normal)
        englishBtn.setTitle(LanguageHelper.getStringLocalized(key: "englishBtn"), for: .normal)
        englishBtn.setTitleColor(UIColor(red: 35/255, green: 21/255, blue: 62/255, alpha: 1), for: .normal)
        arabicBtn.setTitleColor(UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1), for: .normal)
        self.navigationItem.title = LanguageHelper.getStringLocalized(key: "Setting_tab")
        self.tabBarController?.tabBar.items?[3].title = LanguageHelper.getStringLocalized(key: "Setting_tab")
        if LanguageHelper.getCurrentLanguage() == "ar"{
            fullNameLbl.textAlignment = .right
            userFullName.textAlignment = .right
            userPhoneNumber.textAlignment = .right
            userEmailAddress.textAlignment = .right
            phoneNumberLbl.textAlignment = .right
            emailLbl.textAlignment = .right
            languageLbl.textAlignment = .right
            self.view.semanticContentAttribute = .forceRightToLeft
            langView.semanticContentAttribute = .forceRightToLeft
            arabicBtn.setTitleColor(UIColor(red: 35/255, green: 21/255, blue: 62/255, alpha: 1), for: .normal)
            englishBtn.setTitleColor(UIColor(red: 134/255, green: 134/255, blue: 134/255, alpha: 1), for: .normal)

        }

    }
//    override func viewDidAppear(_ animated: Bool) {
//        editView.isHidden = true
//        fullNameLbl.text = LanguageHelper.getStringLocalized(key: "fullName_Setting")
//        phoneNumberLbl.text = LanguageHelper.getStringLocalized(key: "phoneNumber_Setting")
//        emailLbl.text = LanguageHelper.getStringLocalized(key: "email_Setting")
//        languageLbl.text = LanguageHelper.getStringLocalized(key: "language_Setting")
//        editBtn.setTitle(LanguageHelper.getStringLocalized(key: "editBtn_Setting"), for: .normal)
//        signOutBtn.setTitle(LanguageHelper.getStringLocalized(key: "signOutBtn_Setting"), for: .normal)
//        self.navigationItem.title = LanguageHelper.getStringLocalized(key: "Setting_tab")
//        self.tabBarController?.tabBar.items?[3].title = LanguageHelper.getStringLocalized(key: "Setting_tab")
//
//    }
    
    @IBAction func editBtn(_ sender: UIButton) {
        EditProfileVC.instance.fullNameTxt.text = self.fullName
        EditProfileVC.instance.emailtxt.text = self.userEmail
        EditProfileVC.instance.phoneTxt.text = self.self.userPhone
        EditProfileVC.instance.userImage = self.userImages
        editView.isHidden = false
    }

    @IBAction func signOutPressed(_ sender: Any) {
      
        DialogsHelper.getInstance().showAlertDialog(inViewController: self, title: LanguageHelper.getStringLocalized(key: "logOutTitle"), message: LanguageHelper.getStringLocalized(key: "logOutMsg"), completion: { userAction in
            if userAction {
                
                    self.defaults.removeObject(forKey: "user_ID")
                    self.performSegue(withIdentifier: "logOut", sender: self)
                }

            })
    }
    
    @IBAction func arabicPressed(_ sender: Any) {
        
        DialogsHelper.getInstance().showAlertDialog(inViewController: self, title: LanguageHelper.getStringLocalized(key: "language"), message: LanguageHelper.getStringLocalized(key: "change_language_confirm"), completion: { userAction in
            if userAction {
                LanguageHelper.setCurrentLanguage(langugaeCode: "ar")
                self.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbar"), animated: true, completion: nil)
            }
        })

   }
    
    @IBAction func englishPressed(_ sender: Any) {
        DialogsHelper.getInstance().showAlertDialog(inViewController: self, title: LanguageHelper.getStringLocalized(key: "language"), message: LanguageHelper.getStringLocalized(key: "change_language_confirm"), completion: { userAction in
            if userAction {
                LanguageHelper.setCurrentLanguage(langugaeCode: "en")
                self.present(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbar"), animated: true, completion: nil)
            }
        })

    }
    
}
