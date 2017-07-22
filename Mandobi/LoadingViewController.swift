//
//  LoadingViewController.swift
//  MandobiDriver
//
//  Created by ِAmr on 1/27/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

import UIKit

class LoadingViewController: LocalizationOrientedViewController ,LoadingDelegate{

    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var comleted: UIImageView!
    @IBOutlet weak var loading: UIImageView!
    var canAnimate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DeliveryVC.instance.loadingDelegate = self
        messageLbl.text = LanguageHelper.getStringLocalized(key: "loadingLbl")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animate()
    }
    
    func animate() {
        UIView.animate(withDuration: 0.12, delay: 0, options: [], animations: {
            self.loading.transform = CGAffineTransform(rotationAngle: -350)
        }, completion: {_ in
            UIView.animate(withDuration: 0.12, delay: 0, options: [], animations: {
                self.loading.transform = CGAffineTransform(rotationAngle: -700)
            }, completion: {_ in
                UIView.animate(withDuration: 0.12, delay: 0, options: [], animations: {
                    self.loading.transform = CGAffineTransform(rotationAngle: -1100)
                }, completion: {_ in
                    if self.canAnimate {
                        self.animate()
                    }
                })
            })
            
        })
    }
    
    
    func noDriverAccept()
    {
        messageLbl.text = LanguageHelper.getStringLocalized(key: "noDriverAccept")
        canAnimate = false
        comleted.image = UIImage(named: "disapproved")
        UIView.animate(withDuration: 0.5, animations: {
            self.loading.alpha = 0
            self.comleted.alpha = 1
        },completion: {_ in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3), execute: {
                self.dismiss(animated: true, completion: nil)
            })
        })
    }
    func noDriverFound()
    {
        messageLbl.text = LanguageHelper.getStringLocalized(key: "noDriverFound")
        canAnimate = false
        comleted.image = UIImage(named: "disapproved")
        UIView.animate(withDuration: 0.5, animations: {
            self.loading.alpha = 0
            self.comleted.alpha = 1
        },completion: {_ in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3), execute: {
                self.dismiss(animated: true, completion: nil)
            })
        })

    }
    func driverAccept()
    {
        messageLbl.text = LanguageHelper.getStringLocalized(key: "driverAccept")
        canAnimate = false
        UIView.animate(withDuration: 0.5, animations: {
            self.loading.alpha = 0
            self.comleted.alpha = 1
        },completion: {_ in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3), execute: {
                self.dismiss(animated: true, completion: nil)
                MainTabBarController.instance.goToTrip()
            })
        })

    }
    
    func driverSuggest(_ param : NSDictionary)
    {
        messageLbl.text = LanguageHelper.getStringLocalized(key: "driverSuggest")
        canAnimate = false
        UIView.animate(withDuration: 0.5, animations: {
            self.loading.alpha = 0
            self.comleted.alpha = 1
        },completion: {_ in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3), execute: {
                self.dismiss(animated: true, completion: nil)
                let storyboard = UIStoryboard(name: "PopUps", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "DriverSuggestionVC") as! DriverSuggestionVC
                let dataArray = param["list"] as! NSArray
                print(dataArray.count)
                let orderId = param["orderId"] as! String
                for i in 0..<dataArray.count
                {
                    let dict = dataArray[i] as! NSDictionary
                    let rate = dict["rate"] as! Int
                    let amount = dict["amount"] as! String
                    let username = dict["full_name"] as! String
                    let conntoken = dict["driverToken"] as! String
                    let driverPlate  = dict["plate_no"] as! String
                    let driverPhone = dict["phone"] as! String
                    let driverImgUrl = dict["presonal_image"] as! String
                    let suggestPrice = SuggestPrice(rate: rate, orderId: orderId, username: username, conntoken: conntoken, amount: amount, driverPlate: driverPlate, driverPhone: driverPhone,driverImgUrl: driverImgUrl)
                    vc.suggestPrice.append(suggestPrice)
                    
                }

                DialogsHelper.getInstance().showPopUp(inViewController: DeliveryVC.instance, popUp: vc)
                
            })
        })

    }
    
    func tripCompleted() {
        canAnimate = false
        comleted.image = UIImage(named: "tripCompleted")
        UIView.animate(withDuration: 0.5, animations: {
            self.loading.alpha = 0
            self.comleted.alpha = 1
            self.messageLbl.text = LanguageHelper.getStringLocalized(key: "trip_completed")
            
        },completion:{_ in
            let deadlineTime = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                self.dismiss(animated: true, completion: {
                    DialogsHelper.getInstance().showPopUp(inViewController: DeliveryVC.instance
                        ,popUp: UIStoryboard(name: "PopUps", bundle: nil).instantiateViewController(withIdentifier: "RattingVC"))
                })
            })
        })
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        canAnimate = false
    }
    
    
}
