//
//  OrderItem.swift
//  O2Trip
//
//  Created by Q on 15/9/24.
//  Copyright © 2015年 lst. All rights reserved.
//

import Foundation

// MARK: - Equatable

func ==(lhs: OrderItem, rhs: OrderItem) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

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
    
    init(code: String) {
        switch code {
        case "0":
            self = .Unpay
        case "1":
            self = .Payed
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

class OrderItem: Hashable {
    
    // MARK: - Hashable
    var hashValue: Int {
        get {
            return (identifier! + activityID!).hashValue
        }
    }
    
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
    
    func cancel(completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((NSError?) -> Void)?) {
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
    
    func confirm(completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((NSError?) -> Void)?) {
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
    
    func edit(adultCount: Int, youngCount: Int, childCount: Int, completion: ((Dictionary<String, AnyObject>) -> Void)?, failure: ((NSError?) -> Void)?) {
//        let userID = NSUserDefaults.standardUserDefaults().objectForKey("loginUserId")
        // Test
        let userID = "b8a2597b-b6db-47ee-8175-33356558b726"
        self.identifier = "1"
        self.activityID = "e04e3016-7824-4858-bc3c-60f7bd5da9e6"
        
        HttpReqManager.httpRequestEditShoppingCart(userID as! String, goodID: self.identifier!, activityID: self.activityID!, date: self.tripDate!, time: self.tripTime!, adult: adultCount, young: youngCount, child: childCount, completion: { (response) -> Void in
            if response["err_code"] as! String == "200" {
                self.adultCount = adultCount
                self.youngCount = youngCount
                self.childCount = childCount
                self.tripPersonCount = adultCount + youngCount + childCount
                
                self.totalPrice = self.price * adultCount + self.youngPrice * youngCount + self.childPrice * childCount
            }
            else {
                failure?(NSError(domain: response["msg"] as! String, code: 404, userInfo: nil))
            }
            }, failure: failure)
    }
    
    func loadShoppingCartInfo(info: Dictionary<String, AnyObject>) {
        let intID = info["id"] as! Int
        identifier = "\(intID)"
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
        var floatValue = info["adultPrice"] as! String
        var value = Float(floatValue)
        price = Int(value!)
        floatValue = info["itemTotal"] as! String
        value = Float(floatValue)
        totalPrice = Int(value!)
        floatValue = info["childrenPrice"] as! String
        value = Float(floatValue)
        childPrice = Int(value!)
        floatValue = info["youthPrice"] as! String
        value = Float(floatValue)
        youngPrice = Int(value!)
        floatValue = info["adultNum"] as! String
        adultCount = Int(floatValue)!
        floatValue = info["youthNum"] as! String
        youngCount = Int(floatValue)!
        floatValue = info["childrenNum"] as! String
        childCount = Int(floatValue)!
        tripPersonCount = adultCount + youngCount + childCount
        activityID = info["actiId"] as? String
        activityTitle = info["actiTitle"] as? String
        tripDate = info["date"] as? String
        tripTime = info["time"] as? String
        activityImageName = info["actiImage"] as? String
        stat = OrderStat(key: (info["orderState"] as? String)!)
    }
    
    func loadSpecailInfo(orderID: String, orderNumber: String?, orderStat: String?, details: Dictionary<String, AnyObject>) {
        identifier = orderID
        number = orderNumber
        if orderStat == nil {
            stat = OrderStat.All
        }
        else {
            stat = OrderStat(code: orderStat!)
        }
        var floatValue = details["adultPrice"] as! String
        var value = Float(floatValue)
        price = Int(value!)
        floatValue = details["itemTotal"] as! String
        value = Float(floatValue)
        totalPrice = Int(value!)
        floatValue = details["childrenPrice"] as! String
        value = Float(floatValue)
        childPrice = Int(value!)
        floatValue = details["youthPrice"] as! String
        value = Float(floatValue)
        youngPrice = Int(value!)
        floatValue = details["adultNum"] as! String
        adultCount = Int(floatValue)!
        floatValue = details["youthNum"] as! String
        youngCount = Int(floatValue)!
        floatValue = details["childrenNum"] as! String
        childCount = Int(floatValue)!
        tripPersonCount = adultCount + youngCount + childCount
        activityID = details["orderItemId"] as? String
        activityTitle = details["itemTitle"] as? String
        tripDate = details["date"] as? String
        tripTime = details["time"] as? String
        activityImageName = details["itemImage"] as? String
    }
    
}