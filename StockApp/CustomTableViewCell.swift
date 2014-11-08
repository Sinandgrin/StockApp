//
//  CustomTableViewCell.swift
//  StockApp
//
//  Created by Andrew Hansen on 11/8/14.
//  Copyright (c) 2014 Andrew Hansen. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var lastPriceLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
