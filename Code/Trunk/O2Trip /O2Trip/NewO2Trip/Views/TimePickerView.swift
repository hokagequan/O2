//
//  TimePickerView.swift
//  O2Trip
//
//  Created by Q on 15/10/22.
//  Copyright © 2015年 lst. All rights reserved.
//

import UIKit

@objc protocol TimePickerViewDelegate {
    optional func didCompleteChoose(time: String, timeString: String)
}

class TimePickerView: UIView, IZValueSelectorViewDataSource, IZValueSelectorViewDelegate {
    
    @IBOutlet weak var pickerView: IZValueSelectorView!
    
    weak var delegate: TimePickerViewDelegate? = nil
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    class func loadFromNib() -> TimePickerView? {
        let views = NSBundle.mainBundle().loadNibNamed("TimePickerView", owner: self, options: nil)
        for view in views {
            if view is TimePickerView {
                let theView = view as! TimePickerView
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
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    func showInView(view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        let HLC = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[me]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["me": self])
        let VLC = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[me]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["me": self])
        view.addConstraints(HLC)
        view.addConstraints(VLC)
    }
    
    // MARK: - Actions
    
    @IBAction func clickCancel(sender: AnyObject) {
        self.dismiss()
    }
    
    @IBAction func clickDone(sender: AnyObject) {
//        delegate?.didCompleteChoose?("\(cell.tureTime):00", timeString: cell.titleLabel.text!)
        self.dismiss()
    }
    
    // MARK: - PickerViewDelegate
    
    func numberOfRowsInSelector(valueSelector: IZValueSelectorView!) -> Int {
        return 17
    }
    
    func rowHeightInSelector(valueSelector: IZValueSelectorView!) -> CGFloat {
        return 34
    }
    
    func selector(valueSelector: IZValueSelectorView!, viewForRowAtIndex index: Int) -> UIView! {
        let label = UILabel(frame: CGRectMake(0, 0, self.pickerView.frame.size.width, 34))
        
        let start = 7 + index
        var time = start
        var header = "上午"
        if start > 12 {
            header = "下午"
            time = time - 12
        }
        
        let oString = "\(header) \(time):00"
        label.text = oString
        label.textAlignment = NSTextAlignment.Center
        label.backgroundColor = UIColor.clearColor()
        label.textColor = lightGrayColor
        
        return label
    }
    
    func rectForSelectionInSelector(valueSelector: IZValueSelectorView!) -> CGRect {
        return CGRectMake(0, 34, valueSelector.bounds.size.width, 34)
    }
    
    func rowWidthInSelector(valueSelector: IZValueSelectorView!) -> CGFloat {
        return 100
    }
    
    func highlightTextColorSelector(valueSelector: IZValueSelectorView!) -> UIColor! {
        return UIColor.blackColor()
    }
    
    func normalTextColorSelector(valueSelector: IZValueSelectorView!) -> UIColor! {
        return lightGrayColor
    }
    
    func selector(valueSelector: IZValueSelectorView!, didSelectRowAtIndex index: Int) {
        
    }

}
