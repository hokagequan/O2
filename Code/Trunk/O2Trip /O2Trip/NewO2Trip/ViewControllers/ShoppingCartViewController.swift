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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
    }
    
    func loadShoppingCartInfo(from: Int, count: Int) {
        GiFHUD.setGifWithImageName("loading.gif")
        GiFHUD.show()
        
        let userID = NSUserDefaults.standardUserDefaults().objectForKey("loginUserId")
        HttpReqManager.httpRequestShoppingCart(userID as! String, start: "\(from)", count: "\(count)", completion: { (response) -> Void in
            self.handleInfo(response)
            // TODO: Load more
            }) { (error) -> Void in
                self.showAlert("获取信息失败")
        }
    }
    
    func refresh() {
        GiFHUD.setGifWithImageName("loading.gif")
        GiFHUD.show()
        
        let userID = NSUserDefaults.standardUserDefaults().objectForKey("loginUserId")
        HttpReqManager.httpRequestShoppingCart(userID as! String, start: "0", count: "10", completion: { (response) -> Void in
            self.handleInfo(response)
            self.tableView.reloadData()
            }) { (error) -> Void in
                self.showAlert("获取信息失败")
        }
    }
    
    // MARK: - Actions
    @IBAction func clickEdit(sender: AnyObject) {
    }
    
    @IBAction func clickSelectAll(sender: AnyObject) {
    }
    
    @IBAction func clickSettle(sender: AnyObject) {
    }
    
    // MARK: - TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ShoppingCartCell", forIndexPath: indexPath) as! ShoppingCartCell
        
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
