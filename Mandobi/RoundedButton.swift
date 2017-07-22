//
//  RoundedButton.swift
//  Wasalt
//
//  Created by imac on 4/18/17.
//  Copyright © 2017 imac. All rights reserved.
//

import UIKit

public class RoundedButton: UIButton {
    
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
        
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0,height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 1.0
        self.layer.masksToBounds = false
        
        
    }
    
}
