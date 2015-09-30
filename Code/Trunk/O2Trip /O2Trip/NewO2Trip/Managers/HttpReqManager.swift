//
//  HttpReqManager.swift
//  O2Trip
//
//  Created by Q on 15/9/22.
//  Copyright © 2015年 lst. All rights reserved.
//

import Foundation

class HttpReqManager {
    
    static let httpUrl = "http://test.o2lx.com:9090/trip/ws/"
    static let imageUrl = "http://test.o2lx.com:9090/trip"
    
    // 获取购物车列表信息
    class func httpRequestShoppingCart(userID: String, start: String, count: String, completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((ErrorType) -> Void)?) {
        var params = Dictionary<String, String>()
        params["userId"] = userID
        params["startPage"] = start
        params["pageSize"] = count
        self.httpRequest("rest_shopping/getShoppingCart", params: params, completion: { (response) -> Void in
            completion?(response)
            }) { (error) -> Void in
                failure?(error)
        }
    }
    
    // 获取订单列表
    class func httpRequestOrders(userID: String, start: String, count: String, stat: OrderStat, completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((ErrorType) -> Void)?) {
        var params = Dictionary<String, String>()
        params["userId"] = userID
        params["status"] = stat.key()
        params["startPage"] = start
        params["pageSize"] = count
        self.httpRequest("rest_order/getOrderByUser", params: params, completion: { (response) -> Void in
            completion?(response)
            }) { (error) -> Void in
                failure?(error)
        }
    }
    
    // 获取联系人列表
    class func httpRequestContacts(userID: String, completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((ErrorType) -> Void)?) {
        var params = Dictionary<String, String>()
        params["userId"] = userID
        self.httpRequest("rest_contact/getContactList", params: params, completion: { (response) -> Void in
            completion?(response)
            }) { (error) -> Void in
                failure?(error)
        }
    }
    
    // 新增联系人
    class func httpRequestAddContact(userID: String, contact:ContactItem, completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((ErrorType) -> Void)?) {
        var params = Dictionary<String, String>()
        params["userId"] = userID
        params["firstName"] = contact.lastName
        params["lastName"] = contact.firstName
        params["py"] = contact.pinyin
        params["mobile"] = contact.phone
        params["weChat"] = contact.weixin
        params["email"] = contact.email
        self.httpRequest("rest_contact/addContactItem", params: params, completion: { (response) -> Void in
            completion?(response)
            }) { (error) -> Void in
                failure?(error)
        }
    }
    
    // 编辑联系人
    class func httpRequestEditContact(userID: String, contact:ContactItem, completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((ErrorType) -> Void)?) {
        var params = Dictionary<String, String>()
        params["userId"] = userID
        params["contactId"] = contact.identifier
        params["firstName"] = contact.lastName
        params["lastName"] = contact.firstName
        params["py"] = contact.pinyin
        params["mobile"] = contact.phone
        params["weChat"] = contact.weixin
        params["email"] = contact.email
        self.httpRequest("rest_contact/editContactItem", params: params, completion: { (response) -> Void in
            completion?(response)
            }) { (error) -> Void in
                failure?(error)
        }
    }
    
    // MARK: - Private
    
    private class func httpRequest(method: String, params: Dictionary<String, String>, completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((ErrorType) -> Void)?) {
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            let jsonParams = String(data: jsonData, encoding: NSUTF8StringEncoding)
            let url = "\(httpUrl)\(method)?paramjson={\(jsonParams)}"
            
            let afManager = AFHTTPRequestOperationManager()
            afManager.GET(url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding), parameters: "", success: { (operation, response) -> Void in
                completion?(response as! Dictionary<String, AnyObject>)
                }, failure: { (operation, error) -> Void in
                    failure?(error)
            })
        }
        catch let error {
            failure?(error)
        }
    }
}
