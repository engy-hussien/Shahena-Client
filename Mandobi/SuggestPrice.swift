//
//  SuggestPrice.swift
//  Mandobi
//
//  Created by Mostafa on 2/1/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation
public class SuggestPrice{
    
    var rate: Int
    var orderId: String
    var username: String
    var conntoken: String
    var amount: String
    var driverPlate: String
    var driverPhone: String
    var driverImgUrl: String
    
    
    
    init(rate: Int, orderId: String,username: String,conntoken: String,amount: String,driverPlate: String,driverPhone: String,driverImgUrl : String) {
        self.rate = rate
        self.orderId = orderId
        self.username = username
        self.conntoken = conntoken
        self.amount = amount
        self.driverPlate = driverPlate
        self.driverPhone = driverPhone
        self.driverImgUrl = driverImgUrl
        
    }
}

