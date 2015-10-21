//
//  OrderEditCell.swift
//  O2Trip
//
//  Created by Q on 15/10/11.
//  Copyright © 2015年 lst. All rights reserved.
//

import UIKit

@objc protocol OrderEditCellDelegate {
    optional func didChangeCount(cell: OrderEditCell, adding: Bool)
}

class OrderEditCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var decreaseButton: UIButton!
    
    weak var delegate: OrderEditCellDelegate?
    
    var count: Int {
        get {
            if self.numberLabel.text == nil {
                return 0
            }
            
            return Int(self.numberLabel.text!)!
        }
        set (newValue) {
            if newValue >= 0 {
                self.numberLabel.text = "\(newValue)"
            }
        }
    }
    
    class func loadFromNib() -> OrderEditCell? {
        let views = NSBundle.mainBundle().loadNibNamed("OrderEditCell", owner: self, options: nil)
        
        for view in views {
            if view is OrderEditCell {
                return view as? OrderEditCell
            }
        }
        
        return nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        CustomObjectUtil.customObject([decreaseButton, numberLabel, addButton], backgroundColor: UIColor.clearColor(), borderWith: 1.0, borderColor: grayColor, corner: 0.0)
        
        numberLabel.text = "2"
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Actions
    
    @IBAction func clickAdd(sender: AnyObject) {
        self.count++
        
        delegate?.didChangeCount?(self, adding: true)
    }
    
    @IBAction func clickDecrease(sender: AnyObject) {
        self.count--
        
        delegate?.didChangeCount?(self, adding: false)
    }
    
}
