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
    
    init(key: String) {
        switch key {
        case "all":
            self = .All
        case "unpay":
            self = .Unpay
        case "confirm":
            self = .Confirmed
            
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
        }
    }
}

class OrderItem {
    
    var identifier: String?
    var number: String?
    var price: String?
    var totalPrice: String?
    var tripAdultCount: Int = 0
    var tripYoungCount: Int = 0
    var tripChildCount: Int = 0
    var activityID: String?
    var activityTitle: String?
    var tripDate: String?
    var tripTime: String?
    var iconImage: String?
    var stat: OrderStat = .All
    
    func loadInfo(info: Dictionary<String, String>) {
        identifier = info["orderId"]
        number = info["orderNo"]
        price = info["price"]
        totalPrice = info["orderTotal"]
        if let adultCount = info["adultNum"] {
            tripAdultCount = Int(adultCount)!
        } else {
            tripAdultCount = 0
        }
        
        if let youngCount = info["youthNum"] {
            tripYoungCount = Int(youngCount)!
        } else {
            tripYoungCount = 0
        }
        
        if let childCount = info["childrenNum"] {
            tripChildCount = Int(childCount)!
        } else {
            tripChildCount = 0
        }
        
        activityID = info["actiId"]
        activityTitle = info["actiTitle"]
        tripDate = info["date"]
        tripTime = info["time"]
        iconImage = info["actiImage"]
        stat = OrderStat(key: info["orderState"]!)
    }
    
    func loadSpecailInfo(orderID: String, orderNumber: String, orderStat: String, details: Dictionary<String, String>) {
        identifier = orderID
        number = orderNumber
        stat = OrderStat(key: orderStat)
        price = details["itemPrice"]
        totalPrice = details["itemTotal"]
        if let adultCount = details["adultNum"] {
            tripAdultCount = Int(adultCount)!
        } else {
            tripAdultCount = 0
        }
        
        if let youngCount = details["youthNum"] {
            tripYoungCount = Int(youngCount)!
        } else {
            tripYoungCount = 0
        }
        
        if let childCount = details["childrenNum"] {
            tripChildCount = Int(childCount)!
        } else {
            tripChildCount = 0
        }

        activityID = details["orderItemId"]
        activityTitle = details["itemTitle"]
        tripDate = details["date"]
        tripTime = details["time"]
        iconImage = details["itemImage"]
    }
}