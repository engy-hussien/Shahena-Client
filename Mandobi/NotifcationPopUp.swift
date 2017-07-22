//
//  NotifcationPopUp.swift
//  Mandobi
//
//  Created by Mostafa on 5/25/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class NotifcationPopUp: UIViewController {

    @IBOutlet weak var notifcationContent: UILabel!
    @IBOutlet weak var notifcationTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        notifcationTitle.text! = UserDefaults.standard.string(forKey: "notifcation-title")!
        notifcationContent.text! = UserDefaults.standard.string(forKey: "notifcation-body")!

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
