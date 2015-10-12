//
//  OrderEditViewController.swift
//  O2Trip
//
//  Created by Quan on 15/10/10.
//  Copyright © 2015年 lst. All rights reserved.
//

import UIKit

class OrderEditViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, OrderEditCellDelegate {
    
    enum OrderEditRow: Int {
        case Header = 0
        case Adult
        case Young
        case Child
        case Number
        case Price
        case Max
        
        func cellIdentifier() -> String {
            switch self {
            case .Header, .Number, .Price:
                return "OrderEditNormalCell"
            case .Adult, .Young, .Child:
                return "OrderEditCell"
            default:
                return ""
            }
        }
        
        func title() -> String {
            switch self {
            case .Header:
                return "预定日期"
            case .Adult:
                return "成人"
            case .Young:
                return "青年"
            case .Child:
                return "儿童"
            case .Number:
                return "数量"
            case .Price:
                return "支付金额"
            default:
                return ""
            }
        }
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    
    var order: OrderItem? = nil
    var personCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        personCount = order?.tripPersonCount
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func clickSave(sender: AnyObject) {
        var cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: OrderEditRow.Adult.rawValue, inSection: 0)) as! OrderEditCell
        let adult = cell.count
        
        cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: OrderEditRow.Young.rawValue, inSection: 0)) as! OrderEditCell
        let young = cell.count
        
        cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: OrderEditRow.Child.rawValue, inSection: 0)) as! OrderEditCell
        let child = cell.count
        
        order?.edit(adult, youngCount: young, childCount: child, completion: { (response) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
            }, failure: { (error) -> Void in
                self.showAlert("保存失败")
        })
    }
    
    // MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OrderEditRow.Max.rawValue
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = OrderEditRow(rawValue: indexPath.row)
        
        if row?.cellIdentifier() == "OrderEditNormalCell" {
            let cell = tableView.dequeueReusableCellWithIdentifier("OrderEditNormalCell", forIndexPath: indexPath) as! OrderEditNormalCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.titleLabel.text = row?.title()
            
            if row == OrderEditRow.Header {
                cell.detailLabel.text = "\(order!.tripDate!) \(order!.tripTime!)"
                cell.detailLabel.textColor = blackColor
            }
            else if row == OrderEditRow.Number {
                cell.detailLabel.text = "\(personCount!)"
                cell.detailLabel.textColor = greenColor
            }
            else if row == OrderEditRow.Price {
                cell.detailLabel.text = "￥ \(order!.totalPrice)"
                cell.detailLabel.textColor = greenColor
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("OrderEditCell", forIndexPath: indexPath) as! OrderEditCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.delegate = self
        
        cell.titleLabel.text = row?.title()
        
        if row == OrderEditRow.Adult {
            cell.priceLabel.text = "￥ \(order!.price)"
            cell.count = order!.adultCount
        }
        else if row == OrderEditRow.Young {
            cell.priceLabel.text = "￥ \(order!.price)"
            cell.count = order!.youngCount
        }
        else if row == OrderEditRow.Child {
            cell.priceLabel.text = "￥ \(order!.price)"
            cell.count = order!.childCount
        }

        return cell
    }
    
    // MARK: - OrderEditCellDelegate
    
    func didChangeCount(cell: OrderEditCell, adding: Bool) {
        if adding {
            personCount!++
        }
        else {
            personCount!--
        }
        
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: OrderEditRow.Number.rawValue, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
