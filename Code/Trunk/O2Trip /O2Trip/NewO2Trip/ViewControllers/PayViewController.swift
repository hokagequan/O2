//
//  PayViewController.swift
//  O2Trip
//
//  Created by Quan on 15/9/26.
//  Copyright © 2015年 lst. All rights reserved.
//

import UIKit

class PayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var payTableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    
    var orders = [OrderItem]()
    var contact: ContactItem? = nil
    var payMode: PayMode = PayMode.WeiXin

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        GiFHUD.setGifWithImageName("loading.gif")
        GiFHUD.show()
        
        let userID = NSUserDefaults.standardUserDefaults().objectForKey("loginUserId")
        HttpReqManager.httpRequestContacts(userID as! String, completion: { (response) -> Void in
            GiFHUD.dismiss()
            self.handleContactInfo(response)
            
            }) { (error) -> Void in
                GiFHUD.dismiss()
                
                self.showAlert("获取信息失败")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleContactInfo(info: Dictionary<String, AnyObject>) {
        let items = info["data"] as! Array<Dictionary<String, String>>
        
        for item in items {
            let contactItem = ContactItem()
            contactItem.loadInfo(item)
            contact = contactItem
            
            if contactItem.isDefalut == true {
                break
            }
        }
        
        // Reload Table View's first cell
        payTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    // MARK: - Actions
    
    @IBAction func clickConfirm(sender: AnyObject) {
        // TODO: 支付
    }
    
    // MARK: - TableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return orders.count + 1
        }
        else if section == 2 {
            return 2
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 111
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2 {
            return footerView
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 联系人
        if indexPath.section == 0 {
            if contact == nil {
                let cell = tableView.dequeueReusableCellWithIdentifier("ContactNoOneCell", forIndexPath: indexPath) as! ContactNoOneCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                let text = NSMutableAttributedString(string: "新建联系人", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(11), NSForegroundColorAttributeName: blackColor])
                text.addAttributes([NSForegroundColorAttributeName: greenColor], range: NSMakeRange(0, 2))
                cell.titleLabel.attributedText = text
                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as! ContactCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                cell.nameLabel.text = "\(contact!.lastName)\(contact!.firstName)"
                cell.phoneLabel.text = contact!.phone
                cell.weixinLabel.text = contact!.weixin
                cell.emailLabel.text = contact!.email
                
                return cell
            }
        }
        // 订单
        else if indexPath.section == 1 {
            if indexPath.row == orders.count {
                let cell = tableView.dequeueReusableCellWithIdentifier("PayTotalCell", forIndexPath: indexPath) as! PayTotalCell
                
                let count = "\(orders.count)"
                let text = NSMutableAttributedString(string: "共\(count)个产品", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(9), NSForegroundColorAttributeName: grayColor])
                text.addAttributes([NSForegroundColorAttributeName: greenColor], range: NSMakeRange(1, count.characters.count))
                cell.countLabel.attributedText = text
                
                var price = 0
                for order in orders {
                    price += Int(order.totalPrice!)!
                }
                let priceText = NSMutableAttributedString(string: "实付 ￥\(price)", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(12), NSForegroundColorAttributeName: greenColor])
                priceText.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(11), NSForegroundColorAttributeName: blackColor], range: NSMakeRange(0, 2))
                cell.priceLabel.attributedText = priceText
                
                return cell
            }
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ShoppingCartCell", forIndexPath: indexPath) as! ShoppingCartCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            let item = orders[indexPath.row]
            cell.titleLabel.text = item.activityTitle
            cell.datelabel.text = "出行日期：\(item.tripDate) \(item.tripTime)"
            
            let personCount = item.tripAdultCount + item.tripYoungCount + item.tripChildCount
            cell.numberLabel.text = "出行人数：\(personCount)人"
            let text = NSMutableAttributedString(string: "￥\(item.price) x\(personCount)", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(8), NSForegroundColorAttributeName: UIColor(red: 102.0 / 255.0, green: 102.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)])
            text.addAttributes([NSForegroundColorAttributeName: UIColor(red: 26 / 255.0, green: 188 / 255.0, blue: 156 / 255.0, alpha: 1.0)], range: NSMakeRange(0, "\(item.price)".characters.count + 1))
            cell.priceLabel.attributedText = text
            
            return cell
        }
        // 支付方式
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("PayModeCell", forIndexPath: indexPath) as! PayModeCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.selected = payMode.rawValue == indexPath.row
            
            if indexPath.row == 0 {
                cell.iconImageView.image = UIImage(named: "pay_wechat")
                cell.titleLabel.text = "微信支付"
            }
            else if indexPath.row == 1 {
                cell.iconImageView.image = UIImage(named: "pay_zhifubao")
                cell.titleLabel.text = "支付宝"
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if contact == nil {
                self.performSegueWithIdentifier("AddContactSegue", sender: self)
            }
        }
        else if indexPath.section == 2 {
            payMode = PayMode(rawValue: indexPath.row)!
        }
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
