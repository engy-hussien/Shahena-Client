//
//  OrderMapViewController.swift
//  Mandobi
//
//  Created by ِAmr on 2/22/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

@objc
protocol MessageReceivedDelegate {
    @objc optional func messageReceived(message: String,type: Int)
    @objc optional func dismissMessages()
}

class OrderMapViewController: UIViewController , UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var fab: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var infoBtn: UIButton!
    
    var trip: Trip!
    
    var fabMessageCount,msgBtnMessageCount: UILabel!
    var isFabPressed = false
    var notSeenMessagesCount = 0
    var messageIsShown = false
    var selectedPhone = ""
        
    var messageDelegate: MessageReceivedDelegate!
    
    var currentLocation: CLLocation!
    
    var estimatedTimeOnPin : Double = 0
    
    var driverCurrentAnnotation,startingAnnotation,sourceAnnotation,destinationAnnotation: MKAnnotation!
    
    let regionRadius: CLLocationDistance = 1000
    
    static var instance: OrderMapViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OrderMapViewController.instance = self
        setUpFabViews()
        self.mapView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var startingCoordinates : CLLocationCoordinate2D!
        for index in 0..<MainTabBarController.instance.trip.tripPoints.count {
            if !(startingCoordinates == nil) {
                drawRoute(startLocation: startingCoordinates, endLocation: MainTabBarController.instance.trip.tripPoints[index])
            }
            startingCoordinates = MainTabBarController.instance.trip.tripPoints[index]
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        OrderMapViewController.instance = nil
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func setUpFabViews() {
        fab.layer.cornerRadius = 0.5 * fab.bounds.size.width
        fab.clipsToBounds = true
        
        fab.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        fab.layer.shadowOffset = CGSize(width: 0.0,height: 2.0)
        fab.layer.shadowOpacity = 1.0
        fab.layer.shadowRadius = 1.0
        fab.layer.masksToBounds = false
        
        fabMessageCount = UILabel()
        
        fabMessageCount.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
        fabMessageCount.textColor = UIColor.white
        fabMessageCount.backgroundColor = .red
        fabMessageCount.text = "0"
        fabMessageCount.layer.cornerRadius = 10
        fabMessageCount.clipsToBounds = true
        fabMessageCount.textAlignment = .center
        fabMessageCount.isHidden = true
        
        fab.addSubview(fabMessageCount)
        
        callBtn.layer.cornerRadius = 0.5 * callBtn.bounds.size.width
        callBtn.clipsToBounds = true
        
        messageBtn.layer.cornerRadius = 0.5 * messageBtn.bounds.size.width
        messageBtn.clipsToBounds = true
        
        infoBtn.layer.cornerRadius = 0.5 * infoBtn.bounds.size.width
        infoBtn.clipsToBounds = true
        
        cancelBtn.layer.cornerRadius = 0.5 * cancelBtn.bounds.size.width
        cancelBtn.clipsToBounds = true
        
        msgBtnMessageCount = UILabel()
        
        msgBtnMessageCount.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
        msgBtnMessageCount.textColor = UIColor.white
        msgBtnMessageCount.backgroundColor = .red
        msgBtnMessageCount.text = "0"
        msgBtnMessageCount.layer.cornerRadius = 10
        msgBtnMessageCount.clipsToBounds = true
        msgBtnMessageCount.textAlignment = .center
        msgBtnMessageCount.isHidden = true
        
        messageBtn.addSubview(msgBtnMessageCount)
    }
    
    func addBtnsForFabAction() {
        isFabPressed = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.cancelBtn.alpha = 1
            self.callBtn.alpha = 1
            self.messageBtn.alpha = 1
            self.infoBtn.alpha = 1
            
            
            self.cancelBtn.center.y -= 80
            self.callBtn.center.y -= 160
            self.messageBtn.center.y -= 240
            self.infoBtn.center.y -= 320
        })
    }
    
    func removeBtnsForFabAction() {
        isFabPressed = false
        UIView.animate(withDuration: 0.5, animations: {
            self.cancelBtn.center.y += 80
            self.callBtn.center.y += 160
            self.messageBtn.center.y += 240
            self.infoBtn.center.y += 320
            
            self.cancelBtn.alpha = 0
            self.callBtn.alpha = 0
            self.messageBtn.alpha = 0
            self.infoBtn.alpha = 0
        })
    }
    
    func showMessgaes() {
        notSeenMessagesCount = 0
        msgBtnMessageCount.isHidden = true
        fabMessageCount.isHidden = true
        messageIsShown = true
        UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.fab.center.y = 110
        }, completion: {_ in
            DialogsHelper.getInstance().showPopUpWithArrow(inViewController: self, popUp: UIStoryboard(name: "PopUps", bundle: nil).instantiateViewController(withIdentifier: "message"), arrowX: self.fab.center.x, arrowY: 150)
        })
    }
    
    func messagesDisappeared() {
        messageIsShown = false
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.fab.center.y = self.view.frame.maxY - 50
        }, completion: nil)
    }
    
    func messageReceived(message: String,type: Int) {
        if isFabPressed {
            notSeenMessagesCount += 1
            msgBtnMessageCount.isHidden = false
            fabMessageCount.isHidden = true
            msgBtnMessageCount.text = "\(notSeenMessagesCount)"
            bloat(msgBtnMessageCount)
        } else if messageIsShown {
            notSeenMessagesCount = 0
            msgBtnMessageCount.isHidden = true
            fabMessageCount.isHidden = true
            if messageDelegate != nil {
                messageDelegate.messageReceived!(message: message,type: type)
            }
        } else {
            notSeenMessagesCount += 1
            msgBtnMessageCount.isHidden = true
            fabMessageCount.isHidden = false
            fabMessageCount.text = "\(notSeenMessagesCount)"
            bloat(fabMessageCount)
        }
        
        MainTabBarController.instance.trip.messages.append(Message(senderType: "driver",type: type, message: message, time: ""))
        if messageDelegate != nil {
            messageDelegate.messageReceived!(message: message,type: type)
        }
    }
    
    func showInfo() {
        DialogsHelper.getInstance().showPopUp(inViewController: self, popUp: UIStoryboard(name: "PopUps", bundle: nil).instantiateViewController(withIdentifier: "TripInfoVC"))
    }
    
    func bloat(_ view: UIView) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = NSNumber(value: 1.5 as Float)
        animation.duration = 0.3
        animation.repeatCount = 1.0
        animation.autoreverses = true
        view.layer.add(animation, forKey: nil)
    }
    
    func drawRoute(startLocation: CLLocationCoordinate2D,endLocation: CLLocationCoordinate2D) {
        let coordinates = [startLocation,endLocation]
        let polyline = MKPolyline(coordinates: coordinates, count: 2)
        mapView.add(polyline, level: .aboveRoads)
    }
    
    func estimateRouteRemainingTime() {
        
        let sourcePlacemark = MKPlacemark(coordinate: currentLocation.coordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: MainTabBarController.instance.trip.fromLat, longitude: MainTabBarController.instance.trip.fromLng) , addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .walking
        
        
        let directions = MKDirections(request: directionRequest)
        
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            
            print("Distance: \(route.distance), Time: \(route.expectedTravelTime)")
            self.estimatedTimeOnPin = route.expectedTravelTime/3600
            
            if !(MainTabBarController.instance.trip == nil) , !MainTabBarController.instance.trip.tripStarted , !(OrderMapViewController.instance == nil) {
                if !(self.driverCurrentAnnotation == nil) {
                    self.mapView.removeAnnotation(self.driverCurrentAnnotation)
                }
                self.driverCurrentAnnotation = MapPin(title: MainTabBarController.instance.trip.tripFromAddress, locationName: MainTabBarController.instance.trip.tripFromAddress, coordinate: CLLocationCoordinate2D(latitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude),type: "timePin")
                
                self.mapView.addAnnotation(self.driverCurrentAnnotation)
            }
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func tripEnded() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func driverBeginsTrip() {
        mapView.showsUserLocation = false
        fab.isHidden = false
        
        sourceAnnotation = MapPin(title: MainTabBarController.instance.trip.tripFromAddress, locationName: MainTabBarController.instance.trip.tripFromAddress, coordinate: CLLocationCoordinate2D(latitude: MainTabBarController.instance.trip.fromLat, longitude: MainTabBarController.instance.trip.fromLng),type: "pin")
        
        destinationAnnotation = MapPin(title: MainTabBarController.instance.trip.tripToAddress, locationName: MainTabBarController.instance.trip.tripToAddress, coordinate: CLLocationCoordinate2D(latitude: MainTabBarController.instance.trip.toLat, longitude: MainTabBarController.instance.trip.toLng),type: "pin")
        
        mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true)
    }
    
    func driverNewLocation(lat: Double,lng: Double) {
        if currentLocation != nil {
            let newLocationCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            drawRoute(startLocation: currentLocation.coordinate, endLocation: newLocationCoordinate)
        }
        
        currentLocation = CLLocation(latitude: lat, longitude: lng)
        
        if startingAnnotation == nil {
            if MainTabBarController.instance.trip.tripPoints.count == 0 {
                startingAnnotation = MapPin(title: "", locationName: "", coordinate: currentLocation.coordinate,type: "pin")
            } else {
                startingAnnotation = MapPin(title: "", locationName: "", coordinate: MainTabBarController.instance.trip.tripPoints[0] ,type: "pin")
            }
            mapView.showAnnotations([startingAnnotation], animated: true)
        }
        
        centerMapOnLocation(location: currentLocation)
        
        if MainTabBarController.instance.trip.tripStarted {
            if !(driverCurrentAnnotation == nil) {
                mapView.removeAnnotation(driverCurrentAnnotation)
            }
            driverCurrentAnnotation = MapPin(title: "", locationName: "", coordinate: currentLocation.coordinate,type: "car")
            
            mapView.addAnnotation(driverCurrentAnnotation)
        } else {
            estimateRouteRemainingTime()
        }
    }
    
    @IBAction func infoPressed(_ sender: Any) {
        removeBtnsForFabAction()
        showInfo()
    }
    
    @IBAction func callPressed(_ sender: Any) {
        removeBtnsForFabAction()
        
        
        let url = URL(string: "telprompt://\(MainTabBarController.instance.trip.driverPhoneNo)")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func messagePreseed(_ sender: Any) {
        removeBtnsForFabAction()
        showMessgaes()
    }
    
    @IBAction func fabPressed(_ sender: Any) {
        if isFabPressed {
            removeBtnsForFabAction()
            if notSeenMessagesCount > 0 {
                msgBtnMessageCount.isHidden = true
                fabMessageCount.text = "\(notSeenMessagesCount)"
                fabMessageCount.isHidden = false
            } else {
                fabMessageCount.isHidden = true
                msgBtnMessageCount.isHidden = true
                
            }
        } else {
            addBtnsForFabAction()
            if notSeenMessagesCount > 0 {
                fabMessageCount.isHidden = true
                msgBtnMessageCount.text = "\(notSeenMessagesCount)"
                msgBtnMessageCount.isHidden = false
            } else {
                fabMessageCount.isHidden = true
                msgBtnMessageCount.isHidden = true
            }
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        removeBtnsForFabAction()
        DialogsHelper.getInstance().showAlertDialog(inViewController: self, title: LanguageHelper.getStringLocalized(key: "TripAlert"), message: LanguageHelper.getStringLocalized(key: "TripMessage")) { userAction in
            if userAction {
                print("driver token \(UserDefaults.standard.string(forKey: "driverToken"))")
                SocketIOController.emitEvent(event: SocketEvents.CANCEL_TRIP, withParameters: ["driverToken":MainTabBarController.instance.trip.driverToken as AnyObject,"orderId": MainTabBarController.instance.trip.tripId as AnyObject])
                self.tripEnded()
                let deadlineTime = DispatchTime.now() + .seconds(1)
                DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                    DeliveryVC.instance.tripEnded()
                })

            }
        }
    }
    
}

extension OrderMapViewController: MKMapViewDelegate {
    
    private func addAnnotation(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = subtitle
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let identifier = "CustomAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            // go ahead and use forced unwrapping and you'll be notified if it can't be found; alternatively, use `guard` statement to accomplish the same thing and show a custom error message
            
        } else {
            annotationView!.annotation = annotation
            
            if (annotationView?.subviews.count)! > 0 {
                annotationView?.subviews.forEach({ $0.removeFromSuperview() })
            }
        }
        
        annotationView!.image = UIImage(named: (annotation as! MapPin).type)!
        
        if (annotation as! MapPin).type == "timePin" {
            let label = UILabel()
            label.text = String(format: "%.1f\n\(LanguageHelper.getStringLocalized(key: "mins"))", estimatedTimeOnPin)
            label.frame = CGRect(x: 0, y: 0, width: (annotationView?.frame.width)!, height: (annotationView?.frame.height)! - 10)
            label.textAlignment = .center
            
            label.font = UIFont(name: label.font.fontName, size: 10)
            label.numberOfLines = 0
            
            annotationView?.addSubview(label)
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    
}
