//
//  MyOrderVC.swift
//  Mandobi
//
//  Created by Mostafa on 1/16/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class MyOrderVC: LocalizationOrientedViewController ,UICollectionViewDataSource,UICollectionViewDelegate{

    @IBOutlet weak var myOrderCollection: UICollectionView!
    @IBOutlet weak var segmentedControls: UISegmentedControl!
    var openOrders = [Order]()
    var excutedOrders = [Order]()
    var cancelOrders = [Order]()
    let url = Links()
    let post = Request()
    var deliver = UIImage(named: "deliver_myorders")
    var bring = UIImage(named: "bring_myorders")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.items?[1].title = LanguageHelper.getStringLocalized(key: "myOrder_tab")
        
        self.navigationItem.title = LanguageHelper.getStringLocalized(key: "myOrder_tab")

        myOrderCollection.delegate = self
        myOrderCollection.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {self.tabBarController?.navigationController?.setNavigationBarHidden(true, animated: false)
        let userID = UserDefaults.standard.string(forKey: "user_ID")
        let param = "user_id=\(userID!)"
        print(param)
        
        segmentedControls.setTitle(LanguageHelper.getStringLocalized(key: "segmentedOpen"), forSegmentAt: 0)
        segmentedControls.setTitle(LanguageHelper.getStringLocalized(key: "segmentedExcuted"), forSegmentAt: 1)
        segmentedControls.setTitle(LanguageHelper.getStringLocalized(key: "segmentedClose"), forSegmentAt: 2)
        self.tabBarController?.tabBar.items?[1].title = LanguageHelper.getStringLocalized(key: "myOrder_tab")
        self.navigationItem.title = LanguageHelper.getStringLocalized(key: "myOrder_tab")
        
        if LanguageHelper.getCurrentLanguage() == "ar"{
            self.segmentedControls.semanticContentAttribute = .forceRightToLeft
        }
        
        openOrders.removeAll()
        self.myOrderCollection.reloadData()
        
        
        post.post(url: url.BASE_URL + "client/orders/open" + url.AUTH_PARAMETERS, params: param, view: self) { (data) in
            print(data)
            let dataArray = data["ordersList"] as! NSArray
            print(dataArray.count)
            for i in 0..<dataArray.count
            {
                let dict = dataArray[i] as! NSDictionary
                
                let driver_rate = dict["driver_rate"] as! String
                let trip_type = dict["trip_type"] as! String
                let order_id = Int(dict["order_id"] as! String)!
                let order_cost = dict["order_cost"] as! String
                let order_time = dict["order_time"] as! String
                let order_start_location = dict["order_start_location"] as! String
                let order_end_location = dict["order_end_location"] as! String
                let driver_name = dict["driver_name"] as! String
                if let  driver_img_url = dict["driver_img_url"] as? String{
                    let openOrder = Order(order_id: order_id,driver_rate: driver_rate, trip_type: trip_type, order_cost: order_cost, order_time: order_time, order_start_location: order_start_location, order_end_location: order_end_location, driver_name: driver_name, driver_img_url: driver_img_url)
                    self.openOrders.append(openOrder)
                    
                }
                else{
                    let  driver_img_url = ""
                    let openOrder = Order(order_id: order_id,driver_rate: driver_rate, trip_type: trip_type, order_cost: order_cost, order_time: order_time, order_start_location: order_start_location, order_end_location: order_end_location, driver_name: driver_name, driver_img_url: driver_img_url)
                    self.openOrders.append(openOrder)
                    
                }
                
                
            }
            print(self.openOrders.count)
            self.myOrderCollection.reloadData()
            
        }
    }
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
     {
        let cellWidth = myOrderCollection.bounds.width
        let cellHeight = CGFloat(144)
        return CGSize(width: cellWidth, height: cellHeight)
     }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myOrderCell", for: indexPath)
            as! MyOrderCell
        
        cell.v1.layer.cornerRadius = 0.5 *  cell.v1.bounds.size.width
        cell.v1.clipsToBounds = true
        cell.v2.layer.cornerRadius = 0.5 *  cell.v1.bounds.size.width
        cell.v2.clipsToBounds = true
        cell.v3.layer.cornerRadius = 0.5 *  cell.v1.bounds.size.width
        cell.v3.clipsToBounds = true
        switch segmentedControls.selectedSegmentIndex {
        case 0:
            cell.dateLbl.text = openOrders[indexPath.row].order_time
            cell.priceLbl.text = openOrders[indexPath.row].order_cost
            cell.startLbl.text = openOrders[indexPath.row].order_start_location
            cell.endLbl.text = openOrders[indexPath.row].order_end_location
//            cell.orderID = openOrders[indexPath.row].order_id
            cell.driverNameLbl.text = openOrders[indexPath.row].driver_name
            cell.driverImg.image = UIImage(named: "profile_default")
            var stars = [cell.star1,cell.star2,cell.star3,cell.star4,cell.star5]
            if openOrders[indexPath.row].trip_type == "0"{
                cell.tripType.image = deliver
            }
            else
            {
                cell.tripType.image = bring

            }
            for starIndex in 0..<stars.count {
                if starIndex < Int(openOrders[indexPath.row].driver_rate)! {
                    stars[starIndex]?.image = UIImage(named: "star_active")
                }
            }

        case 1:
            cell.dateLbl.text = excutedOrders[indexPath.row].order_time
            cell.priceLbl.text = excutedOrders[indexPath.row].order_cost
            cell.startLbl.text = excutedOrders[indexPath.row].order_start_location
            cell.endLbl.text = excutedOrders[indexPath.row].order_end_location
//            cell.orderID = excutedOrders[indexPath.row].order_id
            cell.driverNameLbl.text = excutedOrders[indexPath.row].driver_name
            cell.driverImg.image = UIImage(named: "profile_default")
            var stars = [cell.star1,cell.star2,cell.star3,cell.star4,cell.star5]
            if excutedOrders[indexPath.row].trip_type == "0"{
                cell.tripType.image = deliver
            }
            else
            {
                cell.tripType.image = bring
                
            }
            for starIndex in 0..<stars.count {
                if starIndex < Int(excutedOrders[indexPath.row].driver_rate)! {
                    stars[starIndex]?.image = UIImage(named: "star_active")
                }
            }

        case 2:
            cell.dateLbl.text = cancelOrders[indexPath.row].order_time
            cell.priceLbl.text = cancelOrders[indexPath.row].order_cost
            cell.startLbl.text = cancelOrders[indexPath.row].order_start_location
            cell.endLbl.text = cancelOrders[indexPath.row].order_end_location
//            cell.orderID = cancelOrders[indexPath.row].order_id
            cell.driverNameLbl.text = cancelOrders[indexPath.row].driver_name
            cell.driverImg.image = UIImage(named: "profile_default")
            var stars = [cell.star1,cell.star2,cell.star3,cell.star4,cell.star5]
            if cancelOrders[indexPath.row].trip_type == "0"{
                cell.tripType.image = deliver
            }
            else
            {
                cell.tripType.image = bring
                
            }
            for starIndex in 0..<stars.count {
                if starIndex < Int(cancelOrders[indexPath.row].driver_rate)! {
                    stars[starIndex]?.image = UIImage(named: "star_active")
                }
            }
        default:
            break
        }
        return cell

        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        switch segmentedControls.selectedSegmentIndex {
        case 0:
            return openOrders.count
        case 1:
            return excutedOrders.count
        case 2:
            return cancelOrders.count
        default:
            return 0
        }

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if segmentedControls.selectedSegmentIndex == 0 {
            SocketIOController.emitEvent(event: SocketEvents.CURRENT_TRIP, withParameters: ["orderId": openOrders[indexPath.row].order_id as AnyObject,"senderType": "client" as AnyObject])
        }
    }
    
    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
        switch segmentedControls.selectedSegmentIndex {
        case 0:
//            myOrderCollection.reloadData()
            openOrders.removeAll()
            self.myOrderCollection.reloadData()
            
            let userID = UserDefaults.standard.string(forKey: "user_ID")
            let param = "user_id=\(userID!)"
            print(param)
            
            segmentedControls.setTitle(LanguageHelper.getStringLocalized(key: "segmentedOpen"), forSegmentAt: 0)
            segmentedControls.setTitle(LanguageHelper.getStringLocalized(key: "segmentedExcuted"), forSegmentAt: 1)
            segmentedControls.setTitle(LanguageHelper.getStringLocalized(key: "segmentedClose"), forSegmentAt: 2)
            self.tabBarController?.tabBar.items?[1].title = LanguageHelper.getStringLocalized(key: "myOrder_tab")
            self.navigationItem.title = LanguageHelper.getStringLocalized(key: "myOrder_tab")
            
            if LanguageHelper.getCurrentLanguage() == "ar"{
                self.segmentedControls.semanticContentAttribute = .forceRightToLeft
            }
            
            post.post(url: url.BASE_URL + "client/orders/open" + url.AUTH_PARAMETERS, params: param, view: self) { (data) in
                print(data)
                let dataArray = data["ordersList"] as! NSArray
                print(dataArray.count)
                for i in 0..<dataArray.count
                {
                    let dict = dataArray[i] as! NSDictionary
                    
                    let driver_rate = dict["driver_rate"] as! String
                    let trip_type = dict["trip_type"] as! String
                    let order_id = Int(dict["order_id"] as! String)!
                    let order_cost = dict["order_cost"] as! String
                    let order_time = dict["order_time"] as! String
                    let order_start_location = dict["order_start_location"] as! String
                    let order_end_location = dict["order_end_location"] as! String
                    let driver_name = dict["driver_name"] as! String
                    if let  driver_img_url = dict["driver_img_url"] as? String{
                        let openOrder = Order(order_id: order_id,driver_rate: driver_rate, trip_type: trip_type, order_cost: order_cost, order_time: order_time, order_start_location: order_start_location, order_end_location: order_end_location, driver_name: driver_name, driver_img_url: driver_img_url)
                        self.openOrders.append(openOrder)
                        
                    }
                    else{
                        let  driver_img_url = ""
                        let openOrder = Order(order_id: order_id,driver_rate: driver_rate, trip_type: trip_type, order_cost: order_cost, order_time: order_time, order_start_location: order_start_location, order_end_location: order_end_location, driver_name: driver_name, driver_img_url: driver_img_url)
                        self.openOrders.append(openOrder)
                        
                    }
                    
                    
                }
                print(self.openOrders.count)
                self.myOrderCollection.reloadData()
                
            }

        case 1:
//            if excutedOrders.count > 0{
//                myOrderCollection.reloadData()
//            }
//            else
//            {
            excutedOrders.removeAll()
            self.myOrderCollection.reloadData()
            
                let userID = UserDefaults.standard.string(forKey: "user_ID")
                let param = "user_id=\(userID!)"
                post.post(url: url.BASE_URL + "client/orders/executed" + url.AUTH_PARAMETERS, params: param, view: self) { (data) in
                    print(data)
                    let dataArray = data["ordersList"] as! NSArray
                    print(dataArray.count)
                    for i in 0..<dataArray.count
                    {
                        let dict = dataArray[i] as! NSDictionary
                        
                        let driver_rate = dict["driver_rate"] as! String
                        let trip_type = dict["trip_type"] as! String
                        let order_id = Int(dict["order_id"] as! String)!
                        let order_cost = dict["order_cost"] as! String
                        let order_time = dict["order_time"] as! String
                        let order_start_location = dict["order_start_location"] as! String
                        let order_end_location = dict["order_end_location"] as! String
                        let driver_name = dict["driver_name"] as! String
                        if let  driver_img_url = dict["driver_img_url"] as? String{
                            let openOrder = Order(order_id: order_id,driver_rate: driver_rate, trip_type: trip_type, order_cost: order_cost, order_time: order_time, order_start_location: order_start_location, order_end_location: order_end_location, driver_name: driver_name, driver_img_url: driver_img_url)
                            self.excutedOrders.append(openOrder)
                            
                        }
                        else{
                            let  driver_img_url = ""
                            let openOrder = Order(order_id: order_id,driver_rate: driver_rate, trip_type: trip_type, order_cost: order_cost, order_time: order_time, order_start_location: order_start_location, order_end_location: order_end_location, driver_name: driver_name, driver_img_url: driver_img_url)
                            self.excutedOrders.append(openOrder)
                            
                        }
                        
                    }
                    print(self.openOrders.count)
                    self.myOrderCollection.reloadData()
                    
                    
                }
                

                
//            }
        case 2:
          
//            if cancelOrders.count > 0{
//                myOrderCollection.reloadData()
//            }
//            else
//            {
            
            cancelOrders.removeAll()
            self.myOrderCollection.reloadData()
            
                let userID = UserDefaults.standard.string(forKey: "user_ID")
                let param = "user_id=\(userID!)"
                post.post(url: url.BASE_URL + "client/orders/rejected" + url.AUTH_PARAMETERS, params: param, view: self) { (data) in
                    print(data)
                    let dataArray = data["ordersList"] as! NSArray
                    print(dataArray.count)
                    for i in 0..<dataArray.count
                    {
                        let dict = dataArray[i] as! NSDictionary
                        
                        let driver_rate = dict["driver_rate"] as! String
                        let trip_type = dict["trip_type"] as! String
                        let order_id = Int(dict["order_id"] as! String)!
                        let order_cost = dict["order_cost"] as! String
                        let order_time = dict["order_time"] as! String
                        let order_start_location = dict["order_start_location"] as! String
                        let order_end_location = dict["order_end_location"] as! String
                        let driver_name = dict["driver_name"] as! String
                        if let  driver_img_url = dict["driver_img_url"] as? String{
                            let openOrder = Order(order_id: order_id,driver_rate: driver_rate, trip_type: trip_type, order_cost: order_cost, order_time: order_time, order_start_location: order_start_location, order_end_location: order_end_location, driver_name: driver_name, driver_img_url: driver_img_url)
                            self.cancelOrders.append(openOrder)
                            
                        }
                        else{
                            let  driver_img_url = ""
                            let openOrder = Order(order_id: order_id,driver_rate: driver_rate, trip_type: trip_type, order_cost: order_cost, order_time: order_time, order_start_location: order_start_location, order_end_location: order_end_location, driver_name: driver_name, driver_img_url: driver_img_url)
                            self.cancelOrders.append(openOrder)
                            
                        }

                        
                        
                    }
                    print(self.openOrders.count)
                    self.myOrderCollection.reloadData()
                    
                    
                }

                
//            }

            
        default:
            break
        }

        
    }

    

}
