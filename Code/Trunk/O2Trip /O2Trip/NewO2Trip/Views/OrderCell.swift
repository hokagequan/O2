//
//  OrderCell.swift
//  O2Trip
//
//  Created by Quan on 15/9/23.
//  Copyright © 2015年 lst. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var orderTitleLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var statLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Actions
    @IBAction func doAction(sender: AnyObject) {
    }

}
