//
//  ShoppingCartCell.swift
//  O2Trip
//
//  Created by Q on 15/9/22.
//  Copyright © 2015年 lst. All rights reserved.
//

import UIKit

@objc protocol ShoppingCartCellDelegate {
    optional func didClickSelect(cell: ShoppingCartCell)
    optional func didClickImage(cell: ShoppingCartCell)
}

class ShoppingCartCell: UITableViewCell {
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    weak var delegate: ShoppingCartCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func clickSelect(sender: AnyObject) {
        let button = sender as! UIButton
        button.selected = !button.selected
        
        delegate?.didClickSelect?(self)
    }
    
    @IBAction func clickImage(sender: AnyObject) {
        delegate?.didClickImage?(self)
    }
    
}
