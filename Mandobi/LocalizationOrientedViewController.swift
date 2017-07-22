//
//  LocalizationOrientedViewController.swift
//  MandobiDriver
//
//  Created by ِAmr on 2/8/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

import UIKit

class LocalizationOrientedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        if LanguageHelper.getCurrentLanguage() == "ar" {
            self.view.semanticContentAttribute = .forceRightToLeft
        }
    }

}
