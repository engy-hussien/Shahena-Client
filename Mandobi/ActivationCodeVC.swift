//
//  ActivationCodeVC.swift
//  Mandobi
//
//  Created by Mostafa on 4/30/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class ActivationCodeVC: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var codeText: UITextField!
    @IBOutlet weak var enterKeyLbl: UILabel!
    @IBOutlet weak var missingLabel: UILabel!
    @IBOutlet weak var activationBtn: RoundedButton!

    @IBOutlet weak var phoneNumber: UILabel!
    let defaults = UserDefaults.standard
    var userID: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SignInVC.flag == true {
            print("signIn")
            backbtn.isHidden = false
            LanguageHelp()
        }else{
            print("register")
            backbtn.isHidden = true
            LanguageHelp()
        }
        


        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func LanguageHelp(){
        if LanguageHelper.getCurrentLanguage() == "en"{
            
            headerView.semanticContentAttribute = .forceRightToLeft
            backbtn.setImage(UIImage(named:"leftArrow"), for: .normal)
            
        }
        codeText.layer.borderWidth = 1
        codeText.layer.borderColor = UIColor.lightGray.cgColor
        enterKeyLbl.text = LanguageHelper.getStringLocalized(key: "activation_sentence")
        missingLabel.text = LanguageHelper.getStringLocalized(key: "missing_sentence")
        activationBtn.setTitle(LanguageHelper.getStringLocalized(key: "activation_Btn"), for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func activationPressed(_ sender: Any) {
        self.view.endEditing(true)
        if codeText.text!.isEmpty != true{
            let NumberStr = codeText.text!
            let Formatter = NumberFormatter()
            Formatter.locale = NSLocale(localeIdentifier: "EN") as Locale!
            let final = Formatter.number(from: NumberStr)
            let param = "code=\(final!)"
            Request().post(url: Links().BASE_URL + "client/users/active-account" + Links().AUTH_PARAMETERS, params: param, view: self, completion: { (data) in
                print("data\(data)")
                DialogsHelper().showAlertDialogWithOkOnly(inViewController: self, title: LanguageHelper.getStringLocalized(key: "AlertTitle"), message: LanguageHelper.getStringLocalized(key: "ActiveMassage"), completion: { (userAction) in
                    
                    self.userID = data["id"] as! Int
                    self.defaults.setValue(self.userID, forKey: "user_ID")
                    self.performSegue(withIdentifier: "tabbars", sender: self)

                })
                
                
            })
            
        }else{
            DialogsHelper().showBottomAlert(msg:LanguageHelper.getStringLocalized(key: "code_Validation"), view: self)

            
        }
        
        
        
    }
    
    @IBAction func resendPressed(_ sender: Any) {
        
        if SignInVC.flag == true{
            let NumberStr = SignInVC.instance.emailTxt.text!
            let Formatter = NumberFormatter()
            Formatter.locale = NSLocale(localeIdentifier: "EN") as Locale!
            let final = Formatter.number(from: NumberStr)
            
            let param = "phone=\("00966" + String(describing: final!))"
            print(param)
            Request().post(url: Links().BASE_URL + "client/users/resend-active-code" + Links().AUTH_PARAMETERS, params: param, view: self, completion: { (data) in
                print("data\(data)")
                DialogsHelper().showBottomAlert(msg:LanguageHelper.getStringLocalized(key: "resendMassage"), view: self)
            })

            
        }else{
            print("from register")
            let NumberStr = RegisterationVC.instance.mobileTxt.text!
            let Formatter = NumberFormatter()
            Formatter.locale = NSLocale(localeIdentifier: "EN") as Locale!
            let final = Formatter.number(from: NumberStr)
            
            let param = "phone=\("00966" + String(describing: final!))"
            print(param)
            Request().post(url: Links().BASE_URL + "client/users/resend-active-code" + Links().AUTH_PARAMETERS, params: param, view: self, completion: { (data) in
                print("data\(data)")
                DialogsHelper().showBottomAlert(msg:LanguageHelper.getStringLocalized(key: "resendMassage"), view: self)

            })

            
        }

    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController!.popViewController(animated: false)
    }
    

  }
