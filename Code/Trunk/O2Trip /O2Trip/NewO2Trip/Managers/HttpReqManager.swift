//
//  HttpReqManager.swift
//  O2Trip
//
//  Created by Q on 15/9/22.
//  Copyright © 2015年 lst. All rights reserved.
//

import Foundation

class HttpReqManager: NSObject {
    
    static let httpUrl = "http://test.o2lx.com:9090/trip/ws/"
    static let imageUrl = "http://test.o2lx.com:9090/trip"
    
    // 获取购物车列表信息
    class func httpRequestShoppingCart(userID: String, start: String, count: String, completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((NSError?) -> Void)?) {
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
    
    // 添加购物车
    class func httpRequestAddShoppingCart(userID: String, shoppingCartItem: ShoppingCartItem, completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((NSError?) -> Void)?) {
        var params = Dictionary<String, String>()
        params["userId"] = userID
        params["actiId"] = shoppingCartItem.activityID
        params["adultNumber"] = "\(shoppingCartItem.adultCount)"
        params["youthNumber"] = "\(shoppingCartItem.youngCount)"
        params["childrenNumber"] = "\(shoppingCartItem.childCount)"
        params["adultPrice"] = "\(shoppingCartItem.price)"
        params["youthPrice"] = "\(shoppingCartItem.youngPrice)"
        params["childrenPrice"] = "\(shoppingCartItem.childPrice)"
        params["date"] = "\(shoppingCartItem.tripDate)"
        params["time"] = "\(shoppingCartItem.tripTime)"
        params["totalPay"] = "\(shoppingCartItem.totalPrice)"
        self.httpPostRequest("rest_shopping/addToShoppingCart", params: params, completion: { (response) -> Void in
            completion?(response)
            }) { (error) -> Void in
                failure?(error)
        }
    }
    
    // 修改购物车
    class func httpRequestEditShoppingCart(userID: String, goodID: String, activityID: String, date: String, time: String, adult: Int, young: Int, child: Int, completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((NSError?) -> Void)?) {
        var params = Dictionary<String, String>()
        params["userId"] = userID
        params["goodsId"] = goodID
        params["actiId"] = activityID
        params["date"] = date
        params["time"] = time
        params["adultNum"] = "\(adult)"
        params["youthNum"] = "\(young)"
        params["childrenNum"] = "\(child)"
        self.httpPostRequest("rest_shopping/editShoppingItem", params: params, completion: { (response) -> Void in
            completion?(response)
            }) { (error) -> Void in
                failure?(error)
        }
    }
    
    // 删除购物车
    class func httpRequestDeleteShoppingCart(userID: String, goodIDs: Array<String>, completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((NSError?) -> Void)?) {
        var params = Dictionary<String, String>()
        params["userId"] = userID
        params["goodsId"] = (goodIDs as NSArray).componentsJoinedByString(",")
        self.httpRequest("rest_shopping/delShoppingItem", params: params, completion: { (response) -> Void in
            completion?(response)
            }) { (error) -> Void in
                failure?(error)
        }
    }
    
    // 获取订单列表
    class func httpRequestOrders(userID: String, start: String, count: String, stat: OrderStat, completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((NSError?) -> Void)?) {
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
    
    // 取消订单
    class func httpRequestCancelOrder(userID: String, orderID: String, completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((NSError?) -> Void)?) {
        var params = Dictionary<String, String>()
        params["userId"] = userID
        params["orderId"] = orderID
        self.httpRequest("rest_order/cancelOrder", params: params, completion: { (response) -> Void in
            completion?(response)
            }) { (error) -> Void in
                failure?(error)
        }
    }
    
    // 确认订单
    class func httpRequestConfirmOrder(userID: String, orderID: String, itemID: String, completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((NSError?) -> Void)?) {
        var params = Dictionary<String, String>()
        params["userId"] = userID
        params["orderId"] = orderID
        params["itemId"] = itemID
        self.httpRequest("rest_order/cancelOrder", params: params, completion: { (response) -> Void in
            completion?(response)
            }) { (error) -> Void in
                failure?(error)
        }
    }
    
    // 获取联系人列表
    class func httpRequestContacts(userID: String, completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((NSError?) -> Void)?) {
        var params = Dictionary<String, String>()
        params["userId"] = userID
        self.httpRequest("rest_shopping/getContactList", params: params, completion: { (response) -> Void in
            completion?(response)
            }) { (error) -> Void in
                failure?(error)
        }
    }
    
    // 新增联系人
    class func httpRequestAddContact(userID: String, contact:ContactItem, completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((NSError?) -> Void)?) {
        var params = Dictionary<String, String>()
        params["userId"] = userID
        params["firstName"] = contact.lastName
        params["lastName"] = contact.firstName
        params["pym"] = contact.pinyin
        params["mobile"] = contact.phone
        params["weChat"] = contact.weixin
        params["email"] = contact.email
        params["sex"] = "\(contact.intGender)"
        self.httpPostRequest("rest_shopping/addContactItem", params: params, completion: { (response) -> Void in
            completion?(response)
            }) { (error) -> Void in
                failure?(error)
        }
    }
    
    // 编辑联系人
    class func httpRequestEditContact(userID: String, contact:ContactItem, completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((NSError?) -> Void)?) {
        var params = Dictionary<String, String>()
        params["userId"] = userID
        params["contactId"] = contact.identifier
        params["firstName"] = contact.lastName
        params["lastName"] = contact.firstName
        params["pym"] = contact.pinyin
        params["mobile"] = contact.phone
        params["weChat"] = contact.weixin
        params["email"] = contact.email
        params["sex"] = "\(contact.intGender)"
        self.httpPostRequest("rest_shopping/editContactItem", params: params, completion: { (response) -> Void in
            completion?(response)
            }) { (error) -> Void in
                failure?(error)
        }
    }
    
    // 删除联系人
    class func httpReqeustDeleteContact(userID: String, contact:ContactItem, completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((NSError?) -> Void)?) {
        var params = Dictionary<String, String>()
        params["userId"] = userID
        params["contactId"] = contact.identifier
        self.httpRequest("rest_shopping/delContactItem", params: params, completion: { (response) -> Void in
            completion?(response)
            }) { (error) -> Void in
                failure?(error)
        }
    }
    
    // 设置默认联系人
    class func httpRequestSetDefaultContact(userID: String, contact:ContactItem, completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((NSError?) -> Void)?) {
        var params = Dictionary<String, String>()
        params["userId"] = userID
        params["contactId"] = contact.identifier
        self.httpRequest("rest_shopping/setDefaultContact", params: params, completion: { (response) -> Void in
            completion?(response)
            }) { (error) -> Void in
                failure?(error)
        }
    }
    
    // 获取验证码
    class func httpRequestGetVerifyCode(mobile: String, completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((NSError?) -> Void)?) {
        var params = Dictionary<String, String>()
        params["mobile"] = mobile
        self.httpRequest("rest_login/getVerifyCode", params: params, completion: { (response) -> Void in
            completion?(response)
            }) { (error) -> Void in
                failure?(error)
        }
    }
    
    // 注册
    class func httpRequestSignUp(mobile: String, password: String, code: String, completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((NSError?) -> Void)?) {
        var params = Dictionary<String, String>()
        params["account"] = mobile
        params["passWord"] = password
        params["verifyCode"] = code
        self.httpRequest("rest_register_user/register", params: params, completion: { (response) -> Void in
            completion?(response)
            }) { (error) -> Void in
                failure?(error)
        }
    }
    
    // 获取活动
    class func httpRequestGetActivity(longitude: String, latitude: String,  completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((NSError?) -> Void)?) {
        var params = Dictionary<String, String>()
        params["longitude"] = longitude
        params["latitude"] = latitude
        self.httpRequest("rest_acti/getCountryAndType", params: params, completion: { (response) -> Void in
            completion?(response)
            }) { (error) -> Void in
                failure?(error)
        }
    }
    
    class func imageUrl(imageName: String?) -> NSURL? {
        if imageName == nil {
            return nil
        }
        
        let urlString = imageUrl + imageName!
        
        return NSURL(string: urlString)
    }
    
    // MARK: - Private
    
    private class func httpRequest(method: String, params: Dictionary<String, String>, completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((NSError?) -> Void)?) {
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions())
            let jsonParams = String(data: jsonData, encoding: NSUTF8StringEncoding)
            let url = "\(httpUrl)\(method)?paramjson=\(jsonParams!)"
            
            let afManager = AFHTTPRequestOperationManager()
            afManager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/json", "text/plain"]) as Set<NSObject>
            afManager.GET(url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding), parameters: nil, success: { (operation, response) -> Void in
                let rep = response["err_code"] as! String
                if rep == "200" {
                    completion?(response as! Dictionary<String, AnyObject>)
                }
                else {
                    failure?(NSError(domain: response["msg"] as! String, code: 404, userInfo: nil))
                }
                }, failure: { (operation, error) -> Void in
                    failure?(error)
            })
        }
        catch let error {
            if error is NSError {
                failure?(error as? NSError)
            }
            else {
                failure?(nil)
            }
        }
    }
    
    private class func httpPostRequest(method: String, params: Dictionary<String, String>, completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((NSError?) -> Void)?) {
        
        let url = "\(httpUrl)\(method)"
        
        let afManager = AFHTTPRequestOperationManager()
        afManager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/json", "text/plain"]) as Set<NSObject>
        afManager.POST(url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding), parameters: params, success: { (operation, response) -> Void in
            let rep = response["err_code"] as! String
            if rep == "200" {
                completion?(response as! Dictionary<String, AnyObject>)
            }
            else {
                failure?(NSError(domain: response["msg"] as! String, code: 404, userInfo: nil))
            }
            }, failure: { (operation, error) -> Void in
                failure?(error)
        })
    }
}
