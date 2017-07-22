//
//  DriverSuggestionVC.swift
//  Mandobi
//
//  Created by Mostafa on 1/26/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class DriverSuggestionVC: LocalizationOrientedViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var driverCollection: UICollectionView!
    var suggestPrice = [SuggestPrice]()
    override func viewDidLoad() {
        super.viewDidLoad()
        driverCollection.delegate = self
        driverCollection.dataSource = self
        driverCollection.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.driverCollection.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        let cellWidth = driverCollection.bounds.width
        let cellHeight = CGFloat(101)
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "driverCell", for: indexPath)
            as! DriverSuggestionCell
        cell.driverImg.layer.cornerRadius = 0.5 * cell.driverImg.bounds.size.width
        cell.driverImg.clipsToBounds = true
        cell.driverName.text = suggestPrice[indexPath.row].username
        cell.priceLbl.text = suggestPrice[indexPath.row].amount
        cell.contoken = suggestPrice[indexPath.row].conntoken
        var stars = [cell.star1Img,cell.star2Img,cell.star3Img,cell.star4Img,cell.star5Img]
        for starIndex in 0..<stars.count {
            if starIndex < suggestPrice[indexPath.row].rate {
                stars[starIndex]?.image = UIImage(named: "star_active")
            }
        }


        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return suggestPrice.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        MainTabBarController.instance.trip.tripId = suggestPrice[indexPath.row].orderId
        MainTabBarController.instance.trip.driverToken = suggestPrice[indexPath.row].conntoken
        MainTabBarController.instance.trip.driverName = suggestPrice[indexPath.row].username
        MainTabBarController.instance.trip.driverPhoneNo = suggestPrice[indexPath.row].driverPhone
        MainTabBarController.instance.trip.driverRate = suggestPrice[indexPath.row].rate
        MainTabBarController.instance.trip.driverImgUrl = suggestPrice[indexPath.row].driverImgUrl
        MainTabBarController.instance.trip.driverPlateNo = suggestPrice[indexPath.row].driverPlate

        let conToken = UserDefaults.standard.string(forKey: "connToken")

        let param = ["driverConnToken": suggestPrice[indexPath.row].conntoken as AnyObject,
                     "connToken": conToken as AnyObject,
                     "orderId":suggestPrice[indexPath.row].orderId as AnyObject
                     ]
        print(param)
        SocketIOController.emitEvent(event: SocketEvents.SELECT_SUGGESTED_PRICE, withParameters: param as [String : AnyObject])
        self.dismiss(animated: true, completion: nil)
        
//        DeliveryVC.instance.loadingDelegate.driverAccept!()
        DeliveryVC.instance.headerView.isHidden = true
        MainTabBarController.instance.goToTrip()
        
    }

}
