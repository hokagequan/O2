//
//  ShoppingCartViewController.swift
//  O2Trip
//
//  Created by Q on 15/9/22.
//  Copyright © 2015年 lst. All rights reserved.
//

import UIKit

class ShoppingCartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var settleButton: UIButton!
    @IBOutlet weak var TotalLabel: UILabel!
    
    var items = [ShoppingCartItem]()
    var selectedIndexes = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleInfo(info: Dictionary<String, AnyObject>) {
        let goods = info["goods"] as! Array<Dictionary<String, String>>
        
        for i in 0..<goods.count {
            let goodInfo = goods[i]
            let item = ShoppingCartItem()
            item.loadInfo(goodInfo)
            items.append(item)
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
    
    func refresh() {
        items.removeAll()
        
        GiFHUD.setGifWithImageName("loading.gif")
        GiFHUD.show()
        
        let userID = NSUserDefaults.standardUserDefaults().objectForKey("loginUserId")
        HttpReqManager.httpRequestShoppingCart(userID as! String, start: "0", count: "10", completion: { (response) -> Void in
            GiFHUD.dismiss()
            self.handleInfo(response)
            self.tableView.reloadData()
            }) { (error) -> Void in
                GiFHUD.dismiss()
                self.showAlert("获取信息失败")
        }
    }
    
    func refreshSettleInfo() {
        var totalPrice = 0
        for item in items {
            totalPrice += Int(item.totalPrice!)!
        }
        
        let text = NSAttributedString(string: "合计：￥ \(totalPrice)", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(12.0), NSForegroundColorAttributeName: UIColor.whiteColor()])
        TotalLabel.attributedText = text
        
        settleButton.setTitle("结算(\(items.count))", forState: UIControlState.Normal)
        
        selectAllButton.selected = (items.count == selectedIndexes.count)
    }
    
    // MARK: - Actions
    @IBAction func clickEdit(sender: AnyObject) {
        // TODO: 编辑
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
        // TODO: 结算
    }
    
    // MARK: - TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ShoppingCartCell", forIndexPath: indexPath) as! ShoppingCartCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let item = items[indexPath.row]
        cell.titleLabel.text = item.activityTitle
        cell.datelabel.text = "出行日期：\(item.tripDate) \(item.tripTime)"
        cell.numberLabel.text = "出行人数：\(item.tripPersonCount)人"
        let text = NSMutableAttributedString(string: "￥\(item.price) x\(item.tripPersonCount)", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(12), NSForegroundColorAttributeName: UIColor(red: 140.0 / 255.0, green: 140.0 / 255.0, blue: 140.0 / 255.0, alpha: 1.0)])
        cell.priceLabel.attributedText = text
        
        cell.selected = selectedIndexes.contains(indexPath.row)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if selectedIndexes.contains(indexPath.row) {
            selectedIndexes.removeAtIndex(selectedIndexes.indexOf(indexPath.row)!)
        }
        else {
            selectedIndexes.append(indexPath.row)
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ShoppingCartCell
        cell.selected = selectedIndexes.contains(indexPath.row)
        
        self.refreshSettleInfo()
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
