//
//  DeliveryVC.swift
//  Mandobi
//
//  Created by Mostafa on 1/14/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

@objc
protocol LoadingDelegate {
    @objc optional func noDriverFound()
    @objc optional func noDriverAccept()
    @objc optional func driverAccept()
    @objc optional func driverSuggest(_ param: NSDictionary)
    @objc optional func tripCompleted()
}

class DeliveryVC: LocalizationOrientedViewController , UITextFieldDelegate , UIPopoverPresentationControllerDelegate , SocketIOControllorResponseDelegate , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var currentAddressTop: NSLayoutConstraint!
    @IBOutlet weak var fromBottomView: UIView!
    @IBOutlet weak var deliverBtn: UIButton!
    @IBOutlet weak var bringBtn: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var toView: UIView!
    @IBOutlet weak var toLbl: UILabel!
    @IBOutlet weak var mapsView: MKMapView!
    @IBOutlet weak var toTxtField: UITextField!
    @IBOutlet weak var fromTxtField: UITextField!
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    @IBOutlet weak var toBottomView: UIView!
    let locationManager = CLLocationManager()
    var orderType: String!
    static var instance: DeliveryVC!
    var loadingDelegate : LoadingDelegate!
    var barLogo: UIImageView!
    var toLatitude,toLongitude,fromLatitude,fromLongitude,currentLat,currentLong: Double!
    
    @IBOutlet weak var currentAddressBtn: UIButton!
//    var matchingItems:[MKMapItem] = []
    var locationSearch: [LocationSearchResult] = []
    
    var currentLocation: CLLocation!
    
    let regionRadius: CLLocationDistance = 1000
    
    var currentLocationAddress = ""
    var countryCode = "sa"
    var calcDistance = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentAddressTop.constant = 25
        DeliveryVC.instance = self
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        
        setUpViews()
        setUpLocationMangment()
        prepareSocket()
        SendDeviceToken()

    }
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: "notifcation-category") != nil
        {
            PopUps().showPopUp(self, "NotifcationPopUp")
            UserDefaults.standard.removeObject(forKey: "notifcation-category")
        }

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        fromBottomView.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        toBottomView.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)

    }
    func SendDeviceToken(){
        
        let param = "id=\(UserDefaults.standard.string(forKey: "user_ID")!)&device_type=\("0")&device_token=\(UserDefaults.standard.string(forKey: "DeviceToken")!)"
        print("data param\(param)")

        Request().post(url: Links().BASE_URL + "client/users/update-token" + Links().AUTH_PARAMETERS, params: param, view: self) { (data) in
            print("data token\(data)")
        }

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func getAddressFromCoordinates(coordinates: CLLocationCoordinate2D) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            if placeMark != nil  {
                self.countryCode = placeMark.addressDictionary!["CountryCode"] as! String
            
            // Location name
                if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                    print("locationName Addser\(locationName)")
                    self.currentLocationAddress = locationName as String
                    self.currentLat = coordinates.latitude
                    self.currentLong = coordinates.longitude
                }
            }
            
            if self.deliverBtn.imageView?.image == UIImage(named:LanguageHelper.getStringLocalized(key: "DeliveryAcitve")) {
                self.fromTxtField.text = self.currentLocationAddress
                self.fromLatitude = self.currentLat
                self.fromLongitude = self.currentLong
            } else if self.bringBtn.imageView?.image == UIImage(named:LanguageHelper.getStringLocalized(key: "BringActive")) {
                self.toTxtField.text = self.currentLocationAddress
                self.toLatitude = self.currentLat
                self.toLongitude = self.currentLong

            }
        })

    }
    
    func prepareSocket() {
        SocketIOController.delegate = self
        SocketIOController.initiate()
    }
    
    func setUpViews() {
        cornerWithShadow(view: toView)
        cornerWithShadow(view: fromView)
        cornerWithShadow(view: currentAddressBtn)

        
        self.tabBarController?.tabBar.items?[0].title = LanguageHelper.getStringLocalized(key: "home_tab")
        self.tabBarController?.tabBar.items?[1].title = LanguageHelper.getStringLocalized(key: "myOrder_tab")
        
        self.tabBarController?.tabBar.items?[2].title = LanguageHelper.getStringLocalized(key: "wallet_tab")
        self.tabBarController?.tabBar.items?[3].title = LanguageHelper.getStringLocalized(key: "Setting_tab")
//        let logo = UIImage(named: "logo_name")
//        barLogo = UIImageView(image:logo)
//        self.navigationItem.titleView = barLogo
        
        toLbl.text = LanguageHelper.getStringLocalized(key: "to")
        fromLbl.text = LanguageHelper.getStringLocalized(key: "from")
       
        deliverBtn.setImage(UIImage(named:LanguageHelper.getStringLocalized(key: "DeliveryinActive")
        ), for: .normal)
        
        bringBtn.setImage(UIImage(named:LanguageHelper.getStringLocalized(key: "BringinActive")
        ), for: .normal)
        
        fromTxtField.addTarget(self, action: #selector(searchPlaces), for: .editingChanged)
        toTxtField.addTarget(self, action: #selector(searchPlaces), for: .editingChanged)
        
        fromTxtField.placeholder = LanguageHelper.getStringLocalized(key: "search_places")
        toTxtField.placeholder = LanguageHelper.getStringLocalized(key: "search_places")
    }
    
    func searchPlaces(sender: NSObject) {
        switch sender {
        case fromTxtField:
//            if fromTxtField.text! == "" {
//            let currentTxt = fromTxtField.text!
                searchResultsTableView.isHidden = true
//            } else {
//                let request = MKLocalSearchRequest()
//                request.naturalLanguageQuery = fromTxtField.text!
//                request.region = mapsView.region
//                let search = MKLocalSearch(request: request)
//                search.start { response, _ in
//                    guard let response = response else {
//                        return
//                    }
//                    print("response \(response)")
//                    
//                    if self.fromTxtField.text! != ""{
//                        self.matchingItems = response.mapItems
//                        self.searchResultsTableView.reloadData()
//                        let expectedY = self.deliverBtn.imageView?.image == UIImage(named:LanguageHelper.getStringLocalized(key: "DeliveryinActive")) ? 170 : 107
//                        self.searchResultsTableView.frame = CGRect(x: self.searchResultsTableView.frame.minX,y: CGFloat(expectedY),width: self.searchResultsTableView.frame.width,height:self.searchResultsTableView.frame.height)
//                        self.searchResultsTableView.isHidden = false
//                    }
//                }
            
                Request.getInstance().customGet(url: "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(fromTxtField.text!)&components=country:\(countryCode)&language=\(LanguageHelper.getCurrentLanguage())&key=AIzaSyCWqP6hWL_E5ECSvggCIlHeWy1XoujEGSo",dataTag: "predictions", completion: { data in
                    print(data)
                    self.locationSearch.removeAll()
                    for i in 0..<(data as! NSArray).count {
                        let dic = ((data as! NSArray)[i] as! NSDictionary)["structured_formatting"] as! NSDictionary
                        self.locationSearch.append(LocationSearchResult(mainText: dic["main_text"] as! String, secondaryText: dic["secondary_text"] == nil ? "" : dic["secondary_text"] as! String, id: ((data as! NSArray)[i] as! NSDictionary)["place_id"] as! String))
                        
                    }
                    
                    
                    if self.fromTxtField.text! != ""{
                        self.searchResultsTableView.reloadData()
                        let expectedY = self.deliverBtn.imageView?.image == UIImage(named:LanguageHelper.getStringLocalized(key: "DeliveryinActive")) ? 170 : 107
                        self.searchResultsTableView.frame = CGRect(x: self.searchResultsTableView.frame.minX,y: CGFloat(expectedY),width: self.searchResultsTableView.frame.width,height:self.searchResultsTableView.frame.height)
                        self.searchResultsTableView.isHidden = false
                    }
                })
            
//            }
        case toTxtField:
//            if toTxtField.text! == "" {
            
//            let currentTxt = toTxtField.text!
                searchResultsTableView.isHidden = true
//            } else {
//                let request = MKLocalSearchRequest()
//                request.naturalLanguageQuery = toTxtField.text!
//                request.region = mapsView.region
//                let search = MKLocalSearch(request: request)
//                search.start { response, _ in
//                    guard let response = response else {
//                        return
//                    }
//                    print("response \(response)")
//                    if self.toTxtField.text! != "" {
//                        self.matchingItems = response.mapItems
//                        self.searchResultsTableView.reloadData()
//                        let expectedY = self.deliverBtn.imageView?.image == UIImage(named:LanguageHelper.getStringLocalized(key: "DeliveryinActive")) ? 107 : 170
//                        self.searchResultsTableView.frame = CGRect(x: self.searchResultsTableView.frame.minX,y: CGFloat(expectedY),width: self.searchResultsTableView.frame.width,height:self.searchResultsTableView.frame.height)
//                        self.searchResultsTableView.isHidden = false
//                    }
//                }
//            }
            
                Request.getInstance().customGet(url: "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(toTxtField.text!)&components=country:\(countryCode)&language=\(LanguageHelper.getCurrentLanguage())&key=AIzaSyCWqP6hWL_E5ECSvggCIlHeWy1XoujEGSo",dataTag: "predictions", completion: { data in
                    print(data)
                    
                    self.locationSearch.removeAll()
                    for i in 0..<(data as! NSArray).count {
                        let dic = ((data as! NSArray)[i] as! NSDictionary)["structured_formatting"] as! NSDictionary
                        self.locationSearch.append(LocationSearchResult(mainText: dic["main_text"] as! String, secondaryText: dic["secondary_text"] == nil ? "" : dic["secondary_text"] as! String, id: ((data as! NSArray)[i] as! NSDictionary)["place_id"] as! String))
                        
                    }
                    
                    if self.toTxtField.text! != "" {
                        self.searchResultsTableView.reloadData()
                        let expectedY = self.deliverBtn.imageView?.image == UIImage(named:LanguageHelper.getStringLocalized(key: "DeliveryinActive")) ? 107 : 170
                        self.searchResultsTableView.frame = CGRect(x: self.searchResultsTableView.frame.minX,y: CGFloat(expectedY),width: self.searchResultsTableView.frame.width,height:self.searchResultsTableView.frame.height)
                        self.searchResultsTableView.isHidden = false
                    }
                })
            
        default:
            break
            
        }
    }
    
    func setUpLocationMangment() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.distanceFilter = 10.0
    }
    
    func cornerWithShadow(view: UIView) {
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOffset = CGSize(width: 0.0,height: 2.0)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 1.0
        view.layer.masksToBounds = false
    }
    
    func showLoading()
    {
        PopUps.getInstance().showPopUp(self, "loading")
    }
    
    func showNewOrderPopUp()
    {
        if orderType == "deliver"
        {
            PopUps.getInstance().showPopUp(self, "DeliveryPopUpVC")
        }
        else
        {
            PopUps.getInstance().showPopUp(self, "BringPopUpVC")
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func tripEnded() {
        DialogsHelper.getInstance().showPopUp(inViewController: self, popUp: UIStoryboard(name: "PopUps", bundle: nil).instantiateViewController(withIdentifier: "loading"))
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            self.loadingDelegate.tripCompleted!()
        })
    }
    
    @IBAction func currentLocationPressed(_ sender: UIButton) {
        locationManager.startUpdatingLocation()

    }
    
    @IBAction func deliverBtn(_ sender: UIButton) {
        orderType = "deliver"
        currentAddressTop.constant = 130
        fromBottomView.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        if headerView.isHidden == true {

            deliverBtn.setImage(UIImage(named:LanguageHelper.getStringLocalized(key: "DeliveryAcitve")
            ), for: UIControlState.normal)
            bringBtn.setImage(UIImage(named:LanguageHelper.getStringLocalized(key: "BringinActive")
            ), for: UIControlState.normal)
            
            UIView.animate(withDuration: 0, animations: {
                self.toView.center.y = 82
                self.fromView.center.y = 26
            })
            
            headerView.isHidden = false

        } else if deliverBtn.imageView?.image == UIImage(named:LanguageHelper.getStringLocalized(key: "DeliveryinActive")) {
            UIView.animate(withDuration: 0.5, animations: {
                self.toView.center.y = 82
                self.fromView.center.y = 26
                
                self.deliverBtn.setImage(UIImage(named:LanguageHelper.getStringLocalized(key: "DeliveryAcitve")
                ), for: UIControlState.normal)
                self.bringBtn.setImage(UIImage(named:LanguageHelper.getStringLocalized(key: "BringinActive")
                ), for: UIControlState.normal)
            })
        }else if deliverBtn.imageView?.image == UIImage(named:LanguageHelper.getStringLocalized(key: "DeliveryAcitve")) {
            DialogsHelper().showBottomAlert(msg: LanguageHelper.getStringLocalized(key: "BringAlert"), view: self)
            toBottomView.backgroundColor = UIColor.red

        }
        fromTxtField.text = currentLocationAddress
        toTxtField.text = ""
        fromLatitude = currentLat
        fromLongitude = currentLong
        toLatitude = nil
        toLongitude = nil
    }

    @IBAction func bringBtn(_ sender: UIButton) {
        orderType = "bring"
        currentAddressTop.constant = 130
        toBottomView.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        if headerView.isHidden == true {
            print("bring")

            deliverBtn.setImage(UIImage(named:LanguageHelper.getStringLocalized(key: "DeliveryinActive")
            ), for: UIControlState.normal)
            bringBtn.setImage(UIImage(named:LanguageHelper.getStringLocalized(key: "BringActive")
            ), for: UIControlState.normal)
            
            UIView.animate(withDuration: 0, animations: {
                self.toView.center.y = 26
                self.fromView.center.y = 82
            })
            
            headerView.isHidden = false
        } else if bringBtn.imageView?.image == UIImage(named:LanguageHelper.getStringLocalized(key: "BringinActive"))
        {
            UIView.animate(withDuration: 0.5, animations: {
                self.toView.center.y = 26
                self.fromView.center.y = 82
                print("bring 2")
                self.deliverBtn.setImage(UIImage(named:LanguageHelper.getStringLocalized(key: "DeliveryinActive")
                ), for: UIControlState.normal)
                self.bringBtn.setImage(UIImage(named:LanguageHelper.getStringLocalized(key: "BringActive")
                ), for: UIControlState.normal)
            })
        }else if bringBtn.imageView?.image == UIImage(named:LanguageHelper.getStringLocalized(key: "BringActive")){
            
            DialogsHelper().showBottomAlert(msg: LanguageHelper.getStringLocalized(key: "BringAlert"), view: self)
            fromBottomView.backgroundColor = UIColor.red
            
        }
        toTxtField.text = currentLocationAddress
        fromTxtField.text = ""
        toLatitude = currentLat
        toLongitude = currentLong
        fromLatitude = nil
        fromLongitude = nil
    }
    
    // SocketIOControllorResponseDelegate
    
    func notConnected() {
        
    }
    
    func connected() {
        
    }
    
    func actionReceived(actionName: String, parameters: NSDictionary!) {
        
        switch actionName {
        case "noDriverAccept":
            self.tabBarController?.selectedIndex = 0
            loadingDelegate.noDriverAccept!()
        case "noDriversFound":
            self.tabBarController?.selectedIndex = 0
            loadingDelegate.noDriverFound!()
        case "suggestPriceList":
            self.tabBarController?.selectedIndex = 0
            loadingDelegate.driverSuggest!(parameters)
        case "tripStarted":
            if MainTabBarController.instance.trip != nil {
                MainTabBarController.instance.trip.tripStarted = true
            }
        case "driverUpdateLocation":
            if !(MainTabBarController.instance.trip == nil) , !(OrderMapViewController.instance == nil) {
                OrderMapViewController.instance.driverNewLocation(lat: parameters["lat"] as! Double,lng: parameters["lng"] as! Double)
            }
        
        case "tripEnded":
            self.tabBarController?.selectedIndex = 0
            let deadlineTime = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                self.tripEnded()
            })

            if OrderMapViewController.instance != nil {
                OrderMapViewController.instance.tripEnded()
            }
        case "orderAccpeted":
            loadingDelegate.driverAccept!()
            let driverInfo = parameters["info"] as! NSDictionary
            
            MainTabBarController.instance.trip.tripId = parameters["orderId"] as! String
            MainTabBarController.instance.trip.driverToken = parameters["driverToken"] as! String
            MainTabBarController.instance.trip.driverName = driverInfo["full_name"] as! String
            MainTabBarController.instance.trip.driverPhoneNo = driverInfo["phone"] as! String
            MainTabBarController.instance.trip.driverRate = driverInfo["rate"] as! Int
            MainTabBarController.instance.trip.driverImgUrl = driverInfo["presonal_image"] as! String
            MainTabBarController.instance.trip.driverPlateNo = driverInfo["plate_no"] as! String
            deliverBtn.setImage(UIImage(named:LanguageHelper.getStringLocalized(key: "DeliveryinActive")
            ), for: .normal)
            
            bringBtn.setImage(UIImage(named:LanguageHelper.getStringLocalized(key: "BringinActive")
            ), for: .normal)
            
            headerView.isHidden = true
        case "messageReceived":
            if !(MainTabBarController.instance.trip == nil) , !(OrderMapViewController.instance == nil) {
                OrderMapViewController.instance.messageReceived(message: parameters["message"] as! String,type: parameters["messageType"] as! Int)
            }
        case "currentTripDetails":
            self.tabBarController?.selectedIndex = 0
            
            let coordinatesArray = parameters["coordinates"] as! NSArray
            
            var coordinates = [CLLocationCoordinate2D]()
            
            for index in 0..<coordinatesArray.count {
                coordinates.append(CLLocationCoordinate2D(latitude: (coordinatesArray[index] as! NSDictionary)["lat"] as! Double, longitude: (coordinatesArray[index] as! NSDictionary)["lng"] as! Double))
            }
            
            let driverData = parameters["driver"] as! NSDictionary
            
            let chat = parameters["chats"] as! NSArray
            
            var msgs = [Message]()
            
            for index in 0..<chat.count {
                let messgaeData = chat[index] as! NSDictionary
                msgs.append(Message(senderType: messgaeData["senderType"] as! String, type: messgaeData["messageType"] as! Int, message: messgaeData["message"] as! String, time: ""))
            }
            
            MainTabBarController.instance.trip = Trip(tripId: parameters["orderId"] as! String, tripType: parameters["type"] as! String, tripCost: parameters["amount"] as! String, tripFromAddress: parameters["fromAddress"] as! String, tripToAddress: parameters["toAddress"] as! String, driverToken: parameters["driverToken"] as! String, driverName: driverData["full_name"] as! String, driverPhoneNo: driverData["phone"] as! String, driverRate: Int(driverData["rate"] as! String)!, driverImgUrl: driverData["presonal_image"] is NSNull ? "" : driverData["presonal_image"] as! String, driverPlateNo: driverData["plate_no"] is NSNull ? "" : driverData["plate_no"] as! String, fromLat: parameters["fromLatitude"] as! Double, fromLng: parameters["fromLongitude"] as! Double, toLat: parameters["toLatitude"] as! Double, toLng: parameters["toLongitude"] as! Double, tripPoints: coordinates,messages: msgs,tripStarted: parameters["isTripStarted"] as! Bool)
            
            MainTabBarController.instance.goToTrip()
        default:
            break
        }
    }
    
    
    // searchResultsTableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = locationSearch[indexPath.row]
//        print("selectedItem \(selectedItem)")
        cell.textLabel?.text = selectedItem.mainText
        cell.detailTextLabel?.text = selectedItem.secondaryText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchResultsTableView.isHidden = true
        if toTxtField.isFirstResponder {
            let selectedItem = locationSearch[indexPath.row]
            toTxtField.text = "\(selectedItem.mainText!) , \(selectedItem.secondaryText!)"
            print("https://maps.googleapis.com/maps/api/place/details/json?placeid=\(selectedItem.id!)&key=AIzaSyCWqP6hWL_E5ECSvggCIlHeWy1XoujEGSo")
            Request.getInstance().customGet(url: "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(selectedItem.id!)&key=AIzaSyCWqP6hWL_E5ECSvggCIlHeWy1XoujEGSo", dataTag: "result", completion: { data in
                print(data)
                let coordinates = ((data as! NSDictionary)["geometry"] as! NSDictionary)["location"] as! NSDictionary
                self.toLatitude = coordinates["lat"] as! Double
                self.toLongitude = coordinates["lng"] as! Double
                self.getDistance(self.toLatitude, self.toLongitude, self.fromLatitude, self.fromLongitude)
                if self.fromTxtField.text! != "" {
                    self.showNewOrderPopUp()
                }
                
            })
        } else {
            let selectedItem = locationSearch[indexPath.row]
            fromTxtField.text = "\(selectedItem.mainText!) , \(selectedItem.secondaryText!)"
            print("https://maps.googleapis.com/maps/api/place/details/json?placeid=\(selectedItem.id!)&key=AIzaSyCWqP6hWL_E5ECSvggCIlHeWy1XoujEGSo")
            Request.getInstance().customGet(url: "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(selectedItem.id!)&key=AIzaSyCWqP6hWL_E5ECSvggCIlHeWy1XoujEGSo", dataTag: "result", completion: { data in
                print(data)
                let coordinates = ((data as! NSDictionary)["geometry"] as! NSDictionary)["location"] as! NSDictionary
                self.fromLatitude = coordinates["lat"] as! Double
                self.fromLongitude = coordinates["lng"] as! Double
                self.getDistance(self.toLatitude, self.toLongitude, self.fromLatitude, self.fromLongitude)
                if self.toTxtField.text! != "" {
                    self.showNewOrderPopUp()
                }
                
            })
        }
        
        locationSearch.removeAll()
        searchResultsTableView.reloadData()
        searchResultsTableView.isHidden = true
    }
    func getDistance(_ toLat: Double,_ toLong: Double, _ fromLat: Double,_ fromLong: Double){
        
        let coordinate₀ = CLLocation(latitude: toLat, longitude: toLong)
        let coordinate₁ = CLLocation(latitude: fromLat, longitude: fromLong)
        let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
        calcDistance = String(format: "%.2f", arguments: [distanceInMeters / 1000])
        print("calcDistance\(calcDistance)")

        
    }
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
}


extension DeliveryVC : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let locValue:CLLocationCoordinate2D = locations.first!.coordinate
            getAddressFromCoordinates(coordinates: locValue)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapsView.setRegion(region, animated: true)
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
}



