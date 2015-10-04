//
//  NewContactViewController.swift
//  O2Trip
//
//  Created by Quan on 15/9/25.
//  Copyright © 2015年 lst. All rights reserved.
//

import UIKit

class NewContactViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    var contactInfo: ContactItem? = nil
    var pageType: ContactPageType = .Add
    
    enum ContactPageType {
        case Add
        case Edit
    }
    
    enum ContactDetailRow: Int {
        case LastName = 0
        case FirstName
        case PinYin
        case Gender
        case Phone
        case Weixin
        case Email
        case Max
        
        func title() -> String {
            switch self {
            case .LastName:
                return "姓氏"
            case .FirstName:
                return "名字"
            case .PinYin:
                return "拼音"
            case .Gender:
                return "性别"
            case .Phone:
                return "手机号"
            case .Weixin:
                return "微信"
            case .Email:
                return "邮箱"
            default:
                return ""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBarHidden = false
        
        if pageType == .Add {
            self.title = "新建联系人"
            contactInfo = ContactItem()
        }
        else if pageType == .Edit {
            self.title = "编辑联系人"
        }
        
        saveButton.layer.cornerRadius = 4.0
        saveButton.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func clickSave(sender: AnyObject) {
        GiFHUD.setGifWithImageName("loading.gif")
        GiFHUD.show()
        
        let userID = NSUserDefaults.standardUserDefaults().objectForKey("loginUserId")
        if pageType == .Add {
            HttpReqManager.httpRequestAddContact(userID as! String, contact: contactInfo!, completion: { (response) -> Void in
                GiFHUD.dismiss()
                self.navigationController?.popViewControllerAnimated(true)
                }, failure: { (error) -> Void in
                    self.showAlert("添加联系人失败")
            })
        }
        else if pageType == .Edit {
            HttpReqManager.httpRequestEditContact(userID as! String, contact: contactInfo!, completion: { (response) -> Void in
                GiFHUD.dismiss()
                self.navigationController?.popViewControllerAnimated(true)
                }, failure: { (error) -> Void in
                    self.showAlert("更新联系人失败")
            })
        }
    }
    
    // MARK: TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactDetailRow.Max.rawValue
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactEditCell", forIndexPath: indexPath) as! ContactEditCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.titleLabel.text = ContactDetailRow(rawValue: indexPath.row)?.title()
        
        if pageType == ContactPageType.Edit {
            switch indexPath.row {
            case ContactDetailRow.LastName.rawValue:
                cell.detailTextField.text = contactInfo?.lastName
                break
            case ContactDetailRow.FirstName.rawValue:
                cell.detailTextField.text = contactInfo?.firstName
                break
            case ContactDetailRow.PinYin.rawValue:
                cell.detailTextField.text = contactInfo?.pinyin
                break
            case ContactDetailRow.Gender.rawValue:
                cell.detailTextField.text = contactInfo?.gender
                break
            case ContactDetailRow.Phone.rawValue:
                cell.detailTextField.text = contactInfo?.phone
                break
            case ContactDetailRow.Weixin.rawValue:
                cell.detailTextField.text = contactInfo?.weixin
                break
            case ContactDetailRow.Email.rawValue:
                cell.detailTextField.text = contactInfo?.email
                break
            default:
                break
            }
        }
        
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
