//
//  SignInVC.swift
//  Mandobi
//
//  Created by Mostafa on 1/13/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class SignInVC: LocalizationOrientedViewController,UITextFieldDelegate {

    @IBOutlet weak var codeTxt: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var forgetBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signInLbl: UILabel!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    let defaults = UserDefaults.standard
    var userID: Int!
    static var flag = false
    static var instance: SignInVC!
    override func viewDidLoad() {
        super.viewDidLoad()
        SignInVC.instance = self

        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
     return true
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        emailTxt.attributedPlaceholder = NSAttributedString(string: "   " + LanguageHelper.getStringLocalized(key: "emailSigInVC"),
                                                            attributes: [NSForegroundColorAttributeName: UIColor.white])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: LanguageHelper.getStringLocalized(key: "passworfSignInVC"),
                                                               attributes: [NSForegroundColorAttributeName: UIColor.white])
//        signInLbl.text = LanguageHelper.getStringLocalized(key: "signInLbl")
        signInBtn.setTitle(LanguageHelper.getStringLocalized(key: "SignInBtn"), for: .normal)
        forgetBtn.setTitle(LanguageHelper.getStringLocalized(key: "ForgetBtn"), for: .normal)
        registerBtn.setTitle(LanguageHelper.getStringLocalized(key: "RegisterBtn"), for: .normal)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainVC") as! MainVC

        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func registerBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        if  emailTxt.text!.isEmpty == false && passwordTxt.text!.isEmpty == false && emailTxt.text!.isNumber && emailTxt.text!.characters.count == 9
        {
            let url = Links()
            let post = Request()
            let NumberStr = emailTxt.text!
            let Formatter = NumberFormatter()
            Formatter.locale = NSLocale(localeIdentifier: "EN") as Locale!
            let final = Formatter.number(from: NumberStr)
            let param = "phone=\("00966" + String(describing: final!))&password=\(passwordTxt.text!)"
            print(param)
            
            post.post(url: url.BASE_URL + "client/users/login" + url.AUTH_PARAMETERS, params: param, view: self, completion: { (data) in
                if let val = data["inactive"] , val as! Bool {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "ActivationCodeVC") as! ActivationCodeVC
                    self.navigationController?.pushViewController(vc, animated: false)
                    SignInVC.flag = true
                    
                } else {
                print("data\(data)")
                self.userID = data["id"] as! Int
                self.defaults.setValue(self.userID, forKey: "user_ID")
                self.performSegue(withIdentifier: "tabbars", sender: self)
                }
                
            })

        }
        else
        {
            DialogsHelper().showBottomAlert(msg: LanguageHelper.getStringLocalized(key: "signIn_Validation") , view: self)

        }

    }
    
    @IBAction func forgetBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ForgetPasswordVC") as! ForgetPasswordVC
        self.navigationController?.pushViewController(vc, animated: false)

    }
    
    @IBAction func registrationBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterationVC") as! RegisterationVC
        self.navigationController?.pushViewController(vc, animated: false)

    }

}
extension String {
    func isValidEmail() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
}
extension String  {
    var isNumber : Bool {
        get{
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
}

