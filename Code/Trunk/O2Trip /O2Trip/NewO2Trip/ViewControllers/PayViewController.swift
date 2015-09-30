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
    
    var orders = [OrderItem]()
    var contact: ContactItem? = nil

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
    }
    
    // MARK: TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("", forIndexPath: indexPath)
        
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
