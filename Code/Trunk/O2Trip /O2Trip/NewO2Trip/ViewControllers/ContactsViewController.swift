//
//  ContactsViewController.swift
//  O2Trip
//
//  Created by Quan on 15/9/24.
//  Copyright © 2015年 lst. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    var contactItems = [ContactItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        GiFHUD.setGifWithImageName("loading.gif")
        GiFHUD.show()
        
        let userID = NSUserDefaults.standardUserDefaults().objectForKey("loginUserId")
        HttpReqManager.httpRequestContacts(userID as! String, completion: { (response) -> Void in
            GiFHUD.dismiss()
            
            self.handleInfo(response)
            self.layoutViews()
            self.tableView.reloadData()
            }) { (error) -> Void in
                GiFHUD.dismiss()
                
                self.showAlert("获取信息失败")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleInfo(info: Dictionary<String, AnyObject>) {
        let items = info["data"] as! Array<Dictionary<String, String>>
        
        for item in items {
            let contactItem = ContactItem()
            contactItem.loadInfo(item)
            
            contactItems.append(contactItem)
        }
    }
    
    func layoutViews() {
        let emptyAlpha: CGFloat = contactItems.count == 0 ? 1.0 : 0.0
        let detailAlpha: CGFloat = emptyAlpha == 0.0 ? 1.0 : 0.0
        
        UIView.animateWithDuration(0.3) { () -> Void in
            self.emptyView.alpha = emptyAlpha
            self.tableView.alpha = detailAlpha
        }
    }
    
    // MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as! ContactCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let item = contactItems[indexPath.row]
        cell.nameLabel.text = "\(item.lastName)\(item.firstName)"
        cell.phoneLabel.text = item.phone
        cell.weixinLabel.text = item.weixin
        cell.emailLabel.text = item.email
        
        return cell
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
