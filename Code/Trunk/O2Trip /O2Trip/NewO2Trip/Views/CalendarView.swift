//
//  CalendarView.swift
//  O2Trip
//
//  Created by Q on 15/10/22.
//  Copyright © 2015年 lst. All rights reserved.
//

import UIKit

@objc protocol CalendarViewDelegate {
    optional func didCompletionSelectDate(calendarView: CalendarView, date: String?, time: String?)
}

class CalendarView: UIView, VRGCalendarViewDelegate, TimePickerViewDelegate {

    @IBOutlet weak var calendarContainerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sureButton: UIButton!
    @IBOutlet weak var calendarDateLabel: UILabel!
    
    var calendarDate: String? = nil
    var calendarTime: String = "8:00"
    var selectedDate: NSDate? = nil
    
    weak var delegate: CalendarViewDelegate? = nil
    
    let calendarView = VRGCalendarView()
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    class func loadFromNib() -> CalendarView? {
        let views = NSBundle.mainBundle().loadNibNamed("CalendarView", owner: self, options: nil)
        for view in views {
            if view is CalendarView {
                let theView = view as! CalendarView
                theView.prepare()
                
                return theView
            }
        }
        
        return nil
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
    
    func prepare() {
        calendarView.delegate = self
//        calendarView.frame = CGRectMake(calendarContainerView.bounds.size.width / 2 - 287 / 2.0, 0, 287, 41 * 8);
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarContainerView.addSubview(calendarView)
        
        let widthLC = NSLayoutConstraint(item: calendarView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 287)
        let centerLC = NSLayoutConstraint(item: calendarView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: calendarContainerView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
        let VLC = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view(==290)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": calendarView])
        calendarContainerView.addConstraints([widthLC, centerLC])
        calendarContainerView.addConstraints(VLC)
    }
    
    func refreshSureButton() {
        let year = selectedDate?.year()
        let month = selectedDate?.month()
        let day = selectedDate?.day()
        sureButton.setTitle("预定\(year!)年\(month!)月\(day!)日 \(dateLabel.text!)", forState: UIControlState.Normal)
    }
    
    func showInView(view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        let HLC = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[me]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["me": self])
        let VLC = NSLayoutConstraint.constraintsWithVisualFormat("V:[me(==407)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["me": self])
        view.addConstraints(HLC)
        view.addConstraints(VLC)
    }
    
    // MARK: - Actions
    
    @IBAction func clickClose(sender: AnyObject) {
        self.dismiss()
    }
    
    @IBAction func clickSure(sender: AnyObject) {
        delegate?.didCompletionSelectDate?(self, date: calendarDate, time: calendarTime)
        self.dismiss()
    }
    
    @IBAction func clickCalendarLeft(sender: AnyObject) {
        calendarView.showPreviousMonth()
    }
    
    @IBAction func clickCalendarRight(sender: AnyObject) {
        calendarView.showNextMonth()
    }
    
    @IBAction func clickEditTime(sender: AnyObject) {
        let timePickerView = TimePickerView.loadFromNib()
        timePickerView!.delegate = self
        timePickerView!.showInView(self.superview!)
    }
    
    // MARK: - VRGCalendarViewDelegate
    
    func calendarView(calendarView: VRGCalendarView!, dateSelected date: NSDate!) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        calendarDate = dateFormatter.stringFromDate(date)
        
        selectedDate = date
        
        self.refreshSureButton()
    }
    
    func calendarView(calendarView: VRGCalendarView!, switchedToMonth month: Int32, targetHeight: Float, animated: Bool) {
        calendarDateLabel.text = "\(calendarView.currentMonth.year())年\(calendarView.currentMonth.month())月"
    }
    
    // MARK: TimePickerViewDelegate
    
    func didCompleteChoose(time: String, timeString: String) {
        calendarTime = time
        dateLabel.text = timeString
    }

}
