//
//  MainVC.swift
//  Mandobi
//
//  Created by Mostafa on 1/12/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class MainVC: LocalizationOrientedViewController {

    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var mandobiLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        signInBtn.setTitle(LanguageHelper.getStringLocalized(key: "signInBtnMain"), for: .normal)
        registerBtn.setTitle(LanguageHelper.getStringLocalized(key: "registerBtnMain"), for: .normal)
        mandobiLbl.text = LanguageHelper.getStringLocalized(key: "MainLbl")
        if UserDefaults.standard.string(forKey: "user_ID") != nil
        {
            self.performSegue(withIdentifier: "mainToTabBar", sender: self)
        }

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func registerBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterationVC") as! RegisterationVC
        self.navigationController?.pushViewController(vc, animated: false)

    }
    
    @IBAction func enterBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        self.navigationController?.pushViewController(vc, animated: false)

    }

    

}
