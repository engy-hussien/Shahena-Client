//
//  Order.swift
//  Mandobi
//
//  Created by Mostafa on 1/31/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation
public class Order{
    
    var order_id: Int
    var driver_rate: String
    var trip_type: String
    var order_cost: String
    var order_time: String
    var order_start_location: String
    var order_end_location: String
    var driver_name: String
    var driver_img_url: String

    init(order_id: Int,driver_rate: String, trip_type: String,order_cost: String,order_time: String,order_start_location:String,order_end_location:String,driver_name: String,driver_img_url:String) {
        self.order_id = order_id
        self.driver_rate = driver_rate
        self.trip_type = trip_type
        self.order_cost = order_cost
        self.order_time = order_time
        self.order_start_location = order_start_location
        self.order_end_location = order_end_location
        self.driver_name = driver_name
        self.driver_img_url = driver_img_url
    }
}

