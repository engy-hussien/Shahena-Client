//
//  MainTabBarController.swift
//  Mandobi
//
//  Created by ِAmr on 2/22/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    static var instance : MainTabBarController!
    var trip: Trip!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MainTabBarController.instance = self
    }
    
    func goToTrip() {
        performSegue(withIdentifier: "orderMap", sender: self)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderMap" {
            let viewController = segue.destination as! OrderMapViewController
            viewController.trip = trip
        }
    }

}
