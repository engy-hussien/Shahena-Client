//
//  ForgetPasswordVC.swift
//  Mandobi
//
//  Created by Mostafa on 1/13/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class ForgetPasswordVC: LocalizationOrientedViewController,UITextFieldDelegate {

    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var forgetLbl: UILabel!
    @IBOutlet weak var emailTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        emailTxt.attributedPlaceholder = NSAttributedString(string: LanguageHelper.getStringLocalized(key: "emailTxtForget"),
                                                                                              attributes: [NSForegroundColorAttributeName: UIColor.white])

        
        forgetLbl.text = LanguageHelper.getStringLocalized(key: "forgetLbl")
        sendBtn.setTitle(LanguageHelper.getStringLocalized(key: "sendforgetBtn"), for: .normal)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendBtn(_ sender: UIButton) {
        if emailTxt.text!.isValidEmail()
        {
            let url = Links()
            let post = Request()
            let param = "email=\(emailTxt.text!)"
            post.post(url: url.BASE_URL + "client/users/forget-password" + url.AUTH_PARAMETERS, params: param, view: self, completion: { _ in
                
                let alert = DialogsHelper()
                alert.showAlertDialog(inViewController: self, title:LanguageHelper.getStringLocalized(key: "forgetAlert"), message: LanguageHelper.getStringLocalized(key: "forgetAlertMessage"), completion: { (userAction) in
                    if userAction{
                        self.performSegue(withIdentifier: "forgetSignInSegue", sender: self)
                    }
                    else
                    {
                        self.performSegue(withIdentifier: "forgetSignInSegue", sender: self)
                    }
                    
                })
                
            })

            
        }
        else
        {
            print("Empty")
        }
    }
    @IBAction func backPressed(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: false)
    }

   

}
