//
//  OpenOrder.swift
//  Mandobi
//
//  Created by ِAmr on 2/22/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//
import CoreLocation

class Trip {
    
    var tripId,tripType,tripCost,tripFromAddress,tripToAddress,driverToken,driverName,driverPhoneNo,driverImgUrl,driverPlateNo: String
    var driverRate: Int
    var fromLat,fromLng,toLat,toLng: Double
    var tripPoints: [CLLocationCoordinate2D]
    var messages: [Message]
    var tripStarted: Bool
    
    init(tripId: String,tripType: String,tripCost: String,tripFromAddress: String,tripToAddress: String,driverToken: String,driverName: String,driverPhoneNo: String,driverRate: Int,driverImgUrl: String,driverPlateNo: String,fromLat: Double,fromLng: Double,toLat: Double,toLng: Double,tripPoints: [CLLocationCoordinate2D],messages: [Message],tripStarted: Bool) {
        self.tripId = tripId
        self.tripType = tripType
        self.tripCost = tripCost
        self.tripFromAddress = tripFromAddress
        self.tripToAddress = tripToAddress
        self.driverToken = driverToken
        self.driverName = driverName
        self.driverPhoneNo = driverPhoneNo
        self.driverRate = driverRate
        self.driverImgUrl = driverImgUrl
        self.driverPlateNo = driverPlateNo
        self.fromLat = fromLat
        self.fromLng = fromLng
        self.toLat = toLat
        self.toLng = toLng
        self.tripPoints = tripPoints
        self.messages = messages
        self.tripStarted = tripStarted
    }
}
