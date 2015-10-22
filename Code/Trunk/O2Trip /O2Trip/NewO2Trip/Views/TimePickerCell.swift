//
//  TimePickerCell.swift
//  O2Trip
//
//  Created by Q on 15/10/22.
//  Copyright © 2015年 lst. All rights reserved.
//

import UIKit

class TimePickerCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    var tureTime = 7;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
