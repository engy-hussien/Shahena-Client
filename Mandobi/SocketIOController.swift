//
//  SocketIOController.swift
//  Mandobi
//
//  Created by ِAmr on 1/15/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

import UIKit
import SocketIO
import SystemConfiguration

protocol SocketIOControllorResponseDelegate : class {
    func actionReceived(actionName: String,parameters: NSDictionary!)
    func notConnected()
    func connected()
}

class SocketIOController {
    
    private static var socket : SocketIOClient!
    static weak var delegate : SocketIOControllorResponseDelegate?
    
    static func initiate() {
        if Request.getInstance().isConnected() {
            if socket == nil {
                socket = SocketIOClient(socketURL: URL(string: Links.SOCKET_URL)!, config: [.log(true), .forcePolling(true)])
                
                makeConnection()
                
            }
        } else {
            delegate?.notConnected()
        }
    }
    
    static func makeConnection() {
        socket.on("connect") {data, ack in
            print("socket connected")
            delegate?.connected()
            print(UserDefaults.standard.string(forKey: "user_ID")!)
            emitEvent(event: SocketEvents.INIT_SERVER_CONNECTION, withParameters: ["id":UserDefaults.standard.string(forKey: "user_ID")! as AnyObject,"type":"client" as AnyObject])
        }
        
        setUpHandlers()
        
        socket.connect()
    }
    
    static func makeDisconnection() {
        if socket != nil {
            socket.disconnect()
            socket = nil
        }
    }
    
    static func setUpHandlers() {
        socket.on("setToken") {data, ack in
            print("setToken received with \(data[0] as! NSDictionary)")
            let defaults = UserDefaults.standard
            defaults.setValue((data[0] as! NSDictionary)["connToken"] as! String, forKey: "connToken")
            // Save token
        }
        
        socket.on("noDriverAccept") {data, ack in
            print("no Driver Accept received")
            delegate?.actionReceived(actionName: "noDriverAccept", parameters: nil)
        }
        
        socket.on("noDriverFound") {data, ack in
            print("no Drivers Found received")
            delegate?.actionReceived(actionName: "noDriversFound", parameters: nil)
        }
        
        socket.on("suggestPriceList") {data, ack in
            print("suggest Price List received with \(data[0] as! NSDictionary)")
            delegate?.actionReceived(actionName: "suggestPriceList", parameters: data[0] as! NSDictionary)
        }
        
        socket.on("tripStarted") {data, ack in
            print("trip Started received with \(data[0] as! NSDictionary)")
            delegate?.actionReceived(actionName: "tripStarted", parameters: data[0] as! NSDictionary)
        }
        
        socket.on("driverUpdateLocation") {data, ack in
            print("driver Update Location received with \(data[0] as! NSDictionary)")
            delegate?.actionReceived(actionName: "driverUpdateLocation", parameters: data[0] as! NSDictionary)
        }
        socket.on("tripEnded") {data, ack in
            print("trip Ended received")
            delegate?.actionReceived(actionName: "tripEnded", parameters: nil)
        }
        socket.on("orderAccepted") {data, ack in
            print("order Accpeted received with \(data[0] as! NSDictionary)")
            delegate?.actionReceived(actionName: "orderAccpeted", parameters: data[0] as! NSDictionary)
        }
        socket.on("messageReceived") {data, ack in
            print("message received with \(data[0] as! NSDictionary)")
            delegate?.actionReceived(actionName: "messageReceived", parameters: data[0] as! NSDictionary)
        }

        socket.on("currentTripDetails") {data, ack in
            print("currentTripDetails received with \(data[0] as! NSDictionary)")
            delegate?.actionReceived(actionName: "currentTripDetails", parameters: data[0] as! NSDictionary)
        }
        

    }
    
    static func emitEvent(event: String,withParameters: [String:AnyObject]) {
        socket.emit(event,withParameters)
    }
    
}
