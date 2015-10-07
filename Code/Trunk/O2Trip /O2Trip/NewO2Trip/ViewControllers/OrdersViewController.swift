//
//  OrdersViewController.swift
//  O2Trip
//
//  Created by Q on 15/9/23.
//  Copyright © 2015年 lst. All rights reserved.
//

import UIKit

let greenColor = UIColor(red: 26 / 255.0, green: 188 / 255.0, blue: 156 / 255.0, alpha: 1.0)
let grayColor = UIColor(red: 102 / 255.0, green: 102 / 255.0, blue: 102 / 255.0, alpha: 1.0)
let lightGrayColor = UIColor(red: 153 / 255.0, green: 153 / 255.0, blue: 153 / 255.0, alpha: 1.0)
let blackColor = UIColor(red: 48 / 255.0, green: 48 / 255.0, blue: 48 / 255.0, alpha: 1.0)

class OrdersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, OrderCellDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    var filter: OrderStat = OrderStat.All
    var orderItems = [OrderItem]()
    var selectItem: OrderItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.refresh(filter)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleInfo(info: Dictionary<String, AnyObject>) {
        let orderArray = info["data"] as! Array<Dictionary<String, AnyObject>>
        for order in orderArray {
            let orderID = order["orderId"]
            let orderNo = order["orderNo"]
            let orderStat = order["orderState"]
            let orderDetails = order["orderItems"] as! Array<Dictionary<String, String>>
            
            for detail in orderDetails {
                let item = OrderItem()
                item.loadSpecailInfo(orderID as! String, orderNumber: orderNo as! String, orderStat: orderStat as! String, details: detail)
                
                orderItems.append(item)
            }
        }
    }
    
    func refresh(filter: OrderStat) {
        orderItems.removeAll()
        
        GiFHUD.setGifWithImageName("loading.gif")
        GiFHUD.show()
        
        let userID = NSUserDefaults.standardUserDefaults().objectForKey("loginUserId")
        HttpReqManager.httpRequestOrders(userID as! String, start: "0", count: "10", stat: filter, completion: { (response) -> Void in
            GiFHUD.dismiss()
            
            self.handleInfo(response)
            self.tableView.reloadData()
            }) { (error) -> Void in
                GiFHUD.dismiss()
                
                self.showAlert("获取信息失败")
        }
    }
    
    func loadMore(filter: OrderStat) {
        GiFHUD.setGifWithImageName("loading.gif")
        GiFHUD.show()
        
        let userID = NSUserDefaults.standardUserDefaults().objectForKey("loginUserId")
        HttpReqManager.httpRequestOrders(userID as! String, start: "\(orderItems.count)", count: "10", stat: filter, completion: { (response) -> Void in
            GiFHUD.dismiss()
            
            self.handleInfo(response)
            var indexPaths = [NSIndexPath]()
            for i in self.orderItems.count..<(self.orderItems.count + 10) {
                indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
            }
            
            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
            }) { (error) -> Void in
                GiFHUD.dismiss()
                
                self.showAlert("获取信息失败")
        }
    }
    
    // MARK: - CollectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("OrderFilterCell", forIndexPath: indexPath) as! OrderFilterCell
        cell.titleLabel.text = OrderStat(rawValue: indexPath.row)?.title()
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! OrderFilterCell
        cell.titleLabel.textColor = greenColor
        
        let tempFilter = OrderStat(rawValue: indexPath.row)!
        if filter != tempFilter {
            filter = tempFilter
            
            self.refresh(filter)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! OrderFilterCell
        cell.titleLabel.textColor = grayColor
    }
    
    // MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItems.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let item = orderItems[indexPath.row]
        
        if item.stat == OrderStat.Closed {
            return 133
        }
        
        return 163
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OrderCell", forIndexPath: indexPath) as! OrderCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let item = orderItems[indexPath.row]
        cell.orderIDLabel.text = item.number
        cell.orderTitleLabel.text = item.activityTitle
        cell.priceLabel.text = "￥ \(item.price)"
        cell.numberLabel.text = "x\(item.tripAdultCount + item.tripYoungCount + item.tripChildCount)"
        cell.orderDateLabel.text = "活动时间：\(item.tripDate) \(item.tripTime)"
        
        let header = "总价："
        let text = NSMutableAttributedString(string: "\(header)￥ \(item.totalPrice)", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(9), NSForegroundColorAttributeName: blackColor])
        text.addAttributes([NSForegroundColorAttributeName: lightGrayColor], range: NSMakeRange(0, header.characters.count))
        cell.totalPriceLabel.attributedText = text
        
        var buttonTitle = "付款"
        if item.stat == OrderStat.Payed {
            buttonTitle = "确认单"
        }
        cell.actionButton.setTitle(buttonTitle, forState: UIControlState.Normal)
        cell.cancelButton.hidden = item.stat != OrderStat.Unpay
        
        return cell
    }
    
    // MARK: - OrderCellDelegate
    
    func didClickAction(cell: OrderCell) {
        guard let indexPath = tableView.indexPathForCell(cell) else {
            return
        }
        
        let item = orderItems[indexPath.row]
        if item.stat == OrderStat.Unpay {
            selectItem = item
            self.performSegueWithIdentifier("PaySegue", sender: self)
        }
        else if item.stat == OrderStat.Payed {
            item.confirm({ (response) -> Void in
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                }, failure: { (error) -> Void in
                    self.showAlert("确认失败")
            })
        }
    }
    
    func didClickCancel(cell: OrderCell) {
        let indexPath = tableView.indexPathForCell(cell)
        let item = orderItems[(indexPath?.row)!]
        item.cancel({ (response) -> Void in
            if let index = self.orderItems.indexOf({ (theItem) -> Bool in
                return (theItem.identifier == item.identifier)
            }) {
                self.orderItems.removeAtIndex(index)
                self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            }
            }) { (error) -> Void in
                self.showAlert("取消失败")
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue == "PaySegue" {
            let vc = segue.destinationViewController as! PayViewController
            vc.orders = [selectItem!]
        }
    }

}
