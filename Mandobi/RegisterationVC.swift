//
//  RegisterationVC.swift
//  Mandobi
//
//  Created by Mostafa on 1/12/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class RegisterationVC: LocalizationOrientedViewController,UITextFieldDelegate {
    @IBOutlet weak var registerationBtn: UIButton!

    @IBOutlet weak var codeTxt: UITextField!
    @IBOutlet weak var registerLbl: UILabel!
    @IBOutlet weak var mobileTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    static var instance: RegisterationVC!
    override func viewDidLoad(){
        super.viewDidLoad()
        RegisterationVC.instance = self

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        registerLbl.text = LanguageHelper.getStringLocalized(key: "registerLbl")
        mobileTxt.attributedPlaceholder = NSAttributedString(string: LanguageHelper.getStringLocalized(key: "mobileTxt"),
                                                             attributes: [NSForegroundColorAttributeName: UIColor.white])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: LanguageHelper.getStringLocalized(key: "passwordTxt"),
                                                     attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        emailTxt.attributedPlaceholder = NSAttributedString(string: LanguageHelper.getStringLocalized(key: "emailTxt"),
                                                  attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        nameTxt.attributedPlaceholder = NSAttributedString(string: LanguageHelper.getStringLocalized(key:"nameTxt"),
                                                 attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        registerationBtn.setTitle(LanguageHelper.getStringLocalized(key: "registerationBtn"), for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func registerBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        SignInVC.flag = false
        if nameTxt.text!.isEmpty == false && emailTxt.text!.isValidEmail() && passwordTxt.text!.isEmpty == false && mobileTxt.text!.isEmpty == false && mobileTxt.text!.characters.count == 9
        {
            let param = "email=\(emailTxt.text!)&password=\(passwordTxt.text!)&phone=\("00966" + mobileTxt.text!)&f_name=\(nameTxt.text!)"
            
            let url = Links()
            let post = Request()
            post.post(url: url.BASE_URL + "client/users/register" + url.AUTH_PARAMETERS, params: param, view: self, completion: { _ in
                DialogsHelper().showAlertDialogWithOkOnly(inViewController: self, title: LanguageHelper.getStringLocalized(key: "AlertTitle"), message: LanguageHelper.getStringLocalized(key: "AlertMessage"), completion: { (userAction) in
                    if userAction{
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "ActivationCodeVC") as! ActivationCodeVC
                        
                        self.navigationController?.pushViewController(vc, animated: false)

                    }
                })
                
            })

        }
        else
        {
            DialogsHelper().showBottomAlert(msg: LanguageHelper.getStringLocalized(key: "register_Validation") , view: self)
        }
        
    }

    @IBAction func backPressed(_ sender: UIButton) {
        
        self.navigationController!.popViewController(animated: false)
    }
   

}
