//
//  CategoryCell.swift
//  Mandobi
//
//  Created by Mostafa on 2/1/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryLbl: UILabel!
    var categoryId: Int!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
