//
//  MyOrderCell.swift
//  Mandobi
//
//  Created by Mostafa on 1/30/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class MyOrderCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var v1: UIView!
    @IBOutlet weak var v2: UIView!
    @IBOutlet weak var v3: UIView!
    @IBOutlet weak var startLbl: UILabel!
    @IBOutlet weak var endLbl: UILabel!
    @IBOutlet weak var driverNameLbl: UILabel!
    @IBOutlet weak var tripType: UIImageView!
    @IBOutlet weak var driverImg: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    var orderID: Int!
}
