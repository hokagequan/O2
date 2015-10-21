//
//  OrderCalendarCell.swift
//  O2Trip
//
//  Created by Q on 15/10/21.
//  Copyright © 2015年 lst. All rights reserved.
//

import UIKit

@objc protocol OrderCalendarCellDelegate {
    optional func didClickCalendar(cell: OrderCalendarCell)
}

class OrderCalendarCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    
    weak var delegate: OrderCalendarCellDelegate? = nil
    
    class func loadFromNib() -> OrderCalendarCell? {
        let views = NSBundle.mainBundle().loadNibNamed("OrderCalendarCell", owner: nil, options: nil)
        
        for view in views {
            if view is OrderCalendarCell {
                return view as? OrderCalendarCell
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
    
    // MARK: - Actions
    
    @IBAction func clickCalendar(sender: AnyObject) {
        // TODO:
    }
    
}
