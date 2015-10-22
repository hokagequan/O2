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
    @IBOutlet weak var calendarView: UIView!
    
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
        CustomObjectUtil.customObject([self.calendarView], backgroundColor: UIColor.clearColor(), borderWith: 1, borderColor: grayColor, corner: 2.0)
        
        let curDate = NSDate()
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let stringDate = format.stringFromDate(curDate)
        self.calendarLabel.text = stringDate
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Actions
    
    @IBAction func clickCalendar(sender: AnyObject) {
        delegate?.didClickCalendar?(self)
    }
    
}
