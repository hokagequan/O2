//
//  AddShoppingCartView.swift
//  O2Trip
//
//  Created by Q on 15/10/21.
//  Copyright © 2015年 lst. All rights reserved.
//

import UIKit

class AddShoppingCartView: UIView, UITableViewDelegate, UITableViewDataSource, OrderCalendarCellDelegate, OrderEditCellDelegate, CalendarViewDelegate {
    
    enum AddShoppingCartRow: Int {
        case Calendar = 0
        case Adult
        case Young
        case Child
        case Count
        case TotalPrice
        case Max
        
        func title() -> String {
            switch self {
            case .Calendar:
                return "预定日期"
            case .Adult:
                return "出行成人"
            case .Young:
                return "出行青年"
            case .Child:
                return "出行儿童"
            case .Count:
                return "购买数量"
            case .TotalPrice:
                return "支付金额"
            default:
                return ""
            }
        }
        
        func cellIdentifier() -> String {
            switch self {
            case .Count, .TotalPrice:
                return "OrderEditNormalCell"
            case .Adult, .Young, .Child:
                return "OrderEditCell"
            case .Calendar:
                return "OrderCalendarCell"
            default:
                return ""
            }
        }
    }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var personCount = 6
    
    lazy var shoppingCartItem = ShoppingCartItem()
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    class func loadFromNib() -> AddShoppingCartView? {
        let views = NSBundle.mainBundle().loadNibNamed("AddShoppingCartView", owner: self, options: nil)
        for view in views {
            if view is AddShoppingCartView {
                let theView = view as! AddShoppingCartView
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
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(UINib(nibName: "OrderCalendarCell", bundle: nil), forCellReuseIdentifier: "OrderCalendarCell")
        tableView.registerNib(UINib(nibName: "OrderEditCell", bundle: nil), forCellReuseIdentifier: "OrderEditCell")
        tableView.registerNib(UINib(nibName: "OrderEditNormalCell", bundle: nil), forCellReuseIdentifier: "OrderEditNormalCell")
    }
    
    func refreshInfo() {
        imageView.sd_setImageWithURL(HttpReqManager.imageUrl(shoppingCartItem.activityImageName))
        titleLabel.text = shoppingCartItem.activityTitle
        priceLabel.text = "￥ \(shoppingCartItem.price)"
        
        tableView.reloadData()
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
        [HttpReqManager .httpRequestAddShoppingCart(ODataManager.sharedInstance().userID, shoppingCartItem: shoppingCartItem, completion: { (response) -> Void in
            if response["err_code"] as! String == "200" {
                self.dismiss()
                
                let alert = UIAlertView(title: nil, message: "成功加入购物车", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
            }
            else {
                let alert = UIAlertView(title: nil, message: "加入购物车失败", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
            }
            }, failure: { (error) -> Void in
                let alert = UIAlertView(title: nil, message: "加入购物车失败", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
        })]
    }
    
    // MARK: - CalendarViewDelegate
    
    func didCompletionSelectDate(calendarView: CalendarView, date: String?, time: String?) {
        self.alpha = 1.0
        shoppingCartItem.tripDate = date
        shoppingCartItem.tripTime = time
        
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: AddShoppingCartRow.Calendar.rawValue, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    // MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddShoppingCartRow.Max.rawValue
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = AddShoppingCartRow(rawValue: indexPath.row)
        
        if row?.cellIdentifier() == "OrderCalendarCell" {
            let cell = tableView.dequeueReusableCellWithIdentifier("OrderCalendarCell") as! OrderCalendarCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.delegate = self
            cell.titleLabel.text = row?.title()
            
            return cell
        }
        else if row?.cellIdentifier() == "OrderEditCell" {
            let cell = tableView.dequeueReusableCellWithIdentifier("OrderEditCell") as! OrderEditCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.delegate = self
            cell.titleLabel.text = row?.title()
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("OrderEditNormalCell") as! OrderEditNormalCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.titleLabel.text = row?.title()
        if row == AddShoppingCartRow.Count {
            cell.detailLabel.text = "\(personCount)"
        }
        else if row == AddShoppingCartRow.TotalPrice {
            cell.detailLabel.text = "\(shoppingCartItem.totalPrice)"
        }
        
        return cell
    }
    
    // MARK: - CellDelegate
    
    func didClickCalendar(cell: OrderCalendarCell) {
        let calendar = CalendarView.loadFromNib()
        calendar?.showInView(self.superview!)
        self.alpha = 0
    }
    
    func didChangeCount(cell: OrderEditCell, adding: Bool) {
        if adding {
            personCount++
        }
        else {
            personCount--
        }
        
        let indexPath = tableView.indexPathForCell(cell)
        
        switch indexPath!.row {
        case AddShoppingCartRow.Adult.rawValue:
            shoppingCartItem.adultCount = shoppingCartItem.adultCount + (1 * (adding ? 1 : -1))
            break
        case AddShoppingCartRow.Young.rawValue:
            shoppingCartItem.youngCount = shoppingCartItem.adultCount + (1 * (adding ? 1 : -1))
            break
        case AddShoppingCartRow.Child.rawValue:
            shoppingCartItem.childCount = shoppingCartItem.adultCount + (1 * (adding ? 1 : -1))
            break
        default:
            break
        }
        
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: AddShoppingCartRow.Count.rawValue, inSection: 0), NSIndexPath(forRow: AddShoppingCartRow.TotalPrice.rawValue, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
    }
    
}
