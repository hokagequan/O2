//
//  OrderEditNormalCell.swift
//  O2Trip
//
//  Created by Q on 15/10/11.
//  Copyright © 2015年 lst. All rights reserved.
//

import UIKit

class OrderEditNormalCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    class func loadFromNib() -> OrderEditNormalCell? {
        let views = NSBundle.mainBundle().loadNibNamed("OrderEditNormalCell", owner: nil, options: nil)
        
        for view in views {
            if view is OrderEditNormalCell {
                return view as? OrderEditNormalCell
            }
        }
        
        return nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
