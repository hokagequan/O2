//
//  OrderEditCell.swift
//  O2Trip
//
//  Created by Q on 15/10/11.
//  Copyright © 2015年 lst. All rights reserved.
//

import UIKit

class OrderEditCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var decreaseButton: UIButton!
    
    var count: Int {
        get {
            if self.numberLabel.text == nil {
                return 0
            }
            
            return Int(self.numberLabel.text!)!
        }
        set (newValue) {
            self.numberLabel.text = "\(newValue)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        CustomObjectUtil.customObject([decreaseButton, numberLabel, addButton], backgroundColor: UIColor.clearColor(), borderWith: 1.0, borderColor: grayColor, corner: 0.0)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Actions
    
    @IBAction func clickAdd(sender: AnyObject) {
        self.count++
    }
    
    @IBAction func clickDecrease(sender: AnyObject) {
        self.count--
    }
    
}
