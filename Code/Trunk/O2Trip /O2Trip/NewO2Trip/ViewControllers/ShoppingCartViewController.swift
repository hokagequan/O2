//
//  ShoppingCartViewController.swift
//  O2Trip
//
//  Created by Q on 15/9/22.
//  Copyright © 2015年 lst. All rights reserved.
//

import UIKit

class ShoppingCartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ShoppingCartCellDelegate {
    
    @IBOutlet weak var tableView: RefreshAndLoadTableView!
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var settleButton: UIButton!
    @IBOutlet weak var TotalLabel: UILabel!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var rightBaritem: UIButton!
    
    var items = [OrderItem]()
    var selectedIndexes = [Int]()
    var selectedOrder: OrderItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBarHidden = false
        
        emptyView.alpha = 0.0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.enableRefresh(self, refresh: "refresh")
        tableView.enableLoadMore(self, loadMore: "loadMore")
        
        if items.count == 0 {
            self.refresh()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleInfo(info: Dictionary<String, AnyObject>) {
        let data = info["data"] as! Dictionary<String, AnyObject>
        let goods = data["goods"] as! Array<Dictionary<String, AnyObject>>
        
        for i in 0..<goods.count {
            let goodInfo = goods[i]
            let item = OrderItem()
            item.loadShoppingCartInfo(goodInfo)
            items.append(item)
        }
    }
    
    func layoutViews() {
        let emptyAlpha: CGFloat = items.count == 0 ? 1.0 : 0.0
        let detailAlpha: CGFloat = emptyAlpha == 0.0 ? 1.0 : 0.0
        
        UIView.animateWithDuration(0.3) { () -> Void in
            self.emptyView.alpha = emptyAlpha
            self.tableView.alpha = detailAlpha
        }
    }
    
    func loadShoppingCartInfo(from: Int, count: Int) {
        GiFHUD.setGifWithImageName("loading.gif")
        GiFHUD.show()
        
        let userID = NSUserDefaults.standardUserDefaults().objectForKey("loginUserId")
        HttpReqManager.httpRequestShoppingCart(userID as! String, start: "\(from)", count: "\(count)", completion: { (response) -> Void in
            GiFHUD.dismiss()
            
            self.handleInfo(response)
            var indexPaths = [NSIndexPath]()
            for i in from..<count {
                indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
            }
            
            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
            }) { (error) -> Void in
                GiFHUD.dismiss()
                
                self.showAlert("获取信息失败")
        }
    }
    
    func loadMore() {
        let userID = NSUserDefaults.standardUserDefaults().objectForKey("loginUserId")
        HttpReqManager.httpRequestShoppingCart(userID as! String, start: "\(items.count)", count: "10", completion: { (response) -> Void in
            self.tableView.endLoadMore()
            self.handleInfo(response)
            self.tableView.reloadData()
            self.layoutViews()
            }) { (error) -> Void in
                self.tableView.endLoadMore()
                self.showAlert("获取信息失败")
        }
    }
    
    func refresh() {
        items.removeAll()
        
        GiFHUD.setGifWithImageName("loading.gif")
        GiFHUD.show()
        
        self.tableView.refreshControl?.beginRefreshing()
        
        let userID = NSUserDefaults.standardUserDefaults().objectForKey("loginUserId")
        HttpReqManager.httpRequestShoppingCart(userID as! String, start: "0", count: "10", completion: { (response) -> Void in
            GiFHUD.dismiss()
            self.tableView.refreshControl?.endRefreshing()
            self.handleInfo(response)
            self.tableView.reloadData()
            self.layoutViews()
            }) { (error) -> Void in
                GiFHUD.dismiss()
                self.showAlert("获取信息失败")
        }
    }
    
    func refreshSettleInfo() {
        if selectedIndexes.count == 0 {
            rightBaritem.setImage(UIImage(named: "delete_disable"), forState: UIControlState.Normal)
        }
        else {
            rightBaritem.setImage(UIImage(named: "delete_enable"), forState: UIControlState.Normal)
        }
        
        var totalPrice = 0
        
        for index in selectedIndexes {
            let item = items[index]
            totalPrice += item.totalPrice
        }
        
        let text = NSMutableAttributedString(string: "合计：￥ \(totalPrice)", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(12.0), NSForegroundColorAttributeName: UIColor.whiteColor()])
        text.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(9)], range: NSMakeRange(0, "合计：".characters.count))
        TotalLabel.attributedText = text
        
        settleButton.setTitle("结算(\(selectedIndexes.count))", forState: UIControlState.Normal)
        
        selectAllButton.selected = (items.count == selectedIndexes.count)
    }
    
    // MARK: - Actions
    
    @IBAction func clickEdit(sender: AnyObject) {
        if selectedIndexes.count == 0 {
            return
        }
        
        let userID = NSUserDefaults.standardUserDefaults().objectForKey("loginUserId")
        var goods = [String]()
        
        for index in selectedIndexes {
            let item = items[index]
            goods.append(item.activityID!)
        }
        
        GiFHUD.setGifWithImageName("loading.gif")
        GiFHUD.show()
        HttpReqManager.httpRequestDeleteShoppingCart(userID as! String, goodIDs: goods, completion: { (response) -> Void in
            GiFHUD.dismiss()
            if response["err_code"] as! String == "200" && response["flag"] as! String == "true" {
                var toDelItems: Set<OrderItem> = Set()
                for index in self.selectedIndexes {
                    toDelItems.insert(self.items[index])
                }

                let itemsSet = Set(self.items)
                self.items = Array(itemsSet.exclusiveOr(toDelItems))
//                for item in toDelItems {
//                    if self.items.contains(item) {
//                        self.items.removeAtIndex(self.items.indexOf(item)!)
//                    }
//                }
                self.selectedIndexes.removeAll()
                self.tableView.reloadData()
            }
            else {
                self.showAlert("删除失败")
            }
            }, failure: { (error) -> Void in
                GiFHUD.dismiss()
                self.showAlert("删除失败")
        })
    }
    
    @IBAction func clickSelectAll(sender: AnyObject) {
        let button = sender as! UIButton
        button.selected = !button.selected
        
        selectedIndexes.removeAll()
        if button.selected == true {
            for i in 0..<items.count {
                selectedIndexes.append(i)
            }
        }
    }
    
    @IBAction func clickSettle(sender: AnyObject) {
        if selectedIndexes.count == 0 {
            self.showAlert("请选择活动再结算")
            
            return
        }
        
        self.performSegueWithIdentifier("PaySegue", sender: self)
    }
    
    // MARK: - TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ShoppingCartCell", forIndexPath: indexPath) as! ShoppingCartCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.delegate = self
        
        let item = items[indexPath.row]
        cell.titleLabel.text = item.activityTitle
        cell.datelabel.text = "出行日期：\(item.tripDate) \(item.tripTime)"
        cell.numberLabel.text = "出行人数：\(item.tripPersonCount)人"
        let text = NSMutableAttributedString(string: "￥\(item.price) x\(item.tripPersonCount)", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(8), NSForegroundColorAttributeName: UIColor(red: 102.0 / 255.0, green: 102.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)])
        text.addAttributes([NSForegroundColorAttributeName: UIColor(red: 26 / 255.0, green: 188 / 255.0, blue: 156 / 255.0, alpha: 1.0)], range: NSMakeRange(0, "\(item.price)".characters.count + 1))
        cell.priceLabel.attributedText = text
        cell.iconImageView.sd_setImageWithURL(HttpReqManager.imageUrl(item.activityImageName))
        
        cell.selectButton.selected = selectedIndexes.contains(indexPath.row)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedOrder = items[indexPath.row]
        self.performSegueWithIdentifier("EditSegue", sender: self)
    }
    
    // MARK: - ShoppingCartCellDelegate
    
    func didClickSelect(cell: ShoppingCartCell) {
        let indexPath = tableView.indexPathForCell(cell)!
        
        if selectedIndexes.contains(indexPath.row) {
            selectedIndexes.removeAtIndex(selectedIndexes.indexOf(indexPath.row)!)
        }
        else {
            selectedIndexes.append(indexPath.row)
        }
        
        self.refreshSettleInfo()
    }
    
    func didClickImage(cell: ShoppingCartCell) {
        // TODO: 进入商品详情
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "PaySegue" {
            let payViewController = segue.destinationViewController as! PayViewController
            
            var orders = [OrderItem]()
            for index in selectedIndexes {
                orders.append(items[index])
            }
            
            payViewController.orders = orders
        }
        else if segue.identifier == "EditSegue" {
            let editViewController = segue.destinationViewController as! OrderEditViewController
            editViewController.order = selectedOrder
        }
    }

}
