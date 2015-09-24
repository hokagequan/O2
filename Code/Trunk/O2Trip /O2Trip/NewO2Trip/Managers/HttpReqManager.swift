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
        self.httpRequest("rest_shopping/getShoppingCar", params: params, completion: { (response) -> Void in
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
