//
//  OrderItem.swift
//  O2Trip
//
//  Created by Q on 15/9/24.
//  Copyright © 2015年 lst. All rights reserved.
//

import Foundation

enum OrderStat: Int {
    case All = 0
    case Unpay
    case Confirmed
    case Payed
    case Closed
    
    init(key: String) {
        switch key {
        case "all":
            self = .All
        case "unpay":
            self = .Unpay
        case "confirm":
            self = .Confirmed
        case "closed":
            self = .Closed
            
        default:
            self = .All
        }
    }
    
    func key() -> String {
        switch self {
        case .All:
            return "all"
        case .Unpay:
            return "unpay"
        case .Confirmed:
            return "confirm"
        case .Payed:
            return "payed"
        case .Closed:
            return "closed"
        }
    }
    
    func title() -> String {
        switch self {
        case .All:
            return "全部"
        case .Unpay:
            return "未付款"
        case .Confirmed:
            return "已确认"
        case .Payed:
            return "待确认"
        case .Closed:
            return "关闭"
        }
    }
}

class OrderItem {
    
    var identifier: String? = nil
    var activityID: String? = nil
    var activityTitle: String? = nil
    var activityImageName: String? = nil
    var tripDate: String? = nil
    var tripTime: String? = nil
    var number: String? = nil
    var tripPersonCount: Int = 0
    var adultCount: Int = 0
    var youngCount: Int = 0
    var childCount: Int = 0
    var price: Int = 0
    var youngPrice: Int = 0
    var childPrice: Int = 0
    var totalPrice: Int = 0
    var stat: OrderStat = .All
    
    func cancel(completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((ErrorType) -> Void)?) {
        let userID = NSUserDefaults.standardUserDefaults().objectForKey("loginUserId")
        HttpReqManager.httpRequestCancelOrder(userID as! String, orderID: identifier!, completion: { (response) -> Void in
            let success = (response["err_code"] as! String == "200")
            if success == true {
                completion?(response)
            }
            else {
                failure?(NSError(domain: response["msg"] as! String, code: Int(response["err_code"] as! String)!, userInfo: nil))
            }
            }) { (error) -> Void in
                failure?(error)
        }
    }
    
    func confirm(completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((ErrorType) -> Void)?) {
        let userID = NSUserDefaults.standardUserDefaults().objectForKey("loginUserId")
        HttpReqManager.httpRequestConfirmOrder(userID as! String, orderID: identifier!, itemID: activityID!, completion: { (response) -> Void in
            let success = (response["err_code"] as! String == "200")
            if success == true {
                self.stat = OrderStat.Confirmed
                completion?(response)
            }
            else {
                failure?(NSError(domain: response["msg"] as! String, code: Int(response["err_code"] as! String)!, userInfo: nil))
            }
            }) { (error) -> Void in
                failure?(error)
        }
    }
    
    func loadShoppingCartInfo(info: Dictionary<String, AnyObject>) {
        identifier = info["id"] as? String
        activityID = info["actiId"] as? String
        activityTitle = info["title"] as? String
        activityImageName = info["url"] as? String
        tripDate = info["startDate"] as? String
        tripTime = info["startTime"] as? String
        adultCount = info["adultNum"] as! Int
        youngCount = info["youthNum"] as! Int
        childCount = info["childrenNum"] as! Int
        tripPersonCount = adultCount + youngCount + childCount
        price = info["adultPrice"] as! Int
        childPrice = info["childrenPrice"] as! Int
        youngPrice = info["youthPrice"] as! Int
        totalPrice = price * adultCount + youngPrice * youngCount + childPrice * childCount
    }
    
    func loadInfo(info: Dictionary<String, AnyObject>) {
        identifier = info["orderId"] as? String
        number = info["orderNo"] as? String
        price = info["price"] as! Int
        totalPrice = info["orderTotal"] as! Int
        adultCount = info["adultNum"] as! Int
        youngCount = info["youthNum"] as! Int
        childCount = info["childrenNum"] as! Int
        tripPersonCount = adultCount + youngCount + childCount
        activityID = info["actiId"] as? String
        activityTitle = info["actiTitle"] as? String
        tripDate = info["date"] as? String
        tripTime = info["time"] as? String
        activityImageName = info["actiImage"] as? String
        stat = OrderStat(key: (info["orderState"] as? String)!)
    }
    
    func loadSpecailInfo(orderID: String, orderNumber: String, orderStat: String, details: Dictionary<String, AnyObject>) {
        identifier = orderID
        number = orderNumber
        stat = OrderStat(key: orderStat)
        price = details["price"] as! Int
        totalPrice = details["orderTotal"] as! Int
        adultCount = details["adultNum"] as! Int
        youngCount = details["youthNum"] as! Int
        childCount = details["childrenNum"] as! Int
        tripPersonCount = adultCount + youngCount + childCount
        activityID = details["orderItemId"] as? String
        activityTitle = details["itemTitle"] as? String
        tripDate = details["date"] as? String
        tripTime = details["time"] as? String
        activityImageName = details["itemImage"] as? String
    }
}