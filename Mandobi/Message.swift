//
//  Message.swift
//  MandobiDriver
//
//  Created by ِAmr on 1/27/17.
//  Copyright © 2017 Applexicon. All rights reserved.
//

class Message {
    var senderType,message,time: String!
    var type : Int!
    
    init(senderType: String,type: Int,message: String,time: String) {
        self.senderType = senderType
        self.type = type
        self.message = message
        self.time = time
    }
}
