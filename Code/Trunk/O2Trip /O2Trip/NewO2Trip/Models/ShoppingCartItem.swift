//
//  ShoppingCartItem.swift
//  O2Trip
//
//  Created by Q on 15/9/23.
//  Copyright © 2015年 lst. All rights reserved.
//

import Foundation

class ShoppingCartItem {
    
    var identifier: String?
    var activityID: String?
    var activityTitle: String?
    var activityImageName: String?
    var tripDate: String?
    var tripTime: String?
    var tripPersonCount: String?
    var price: String?
    var totalPrice: String?
    
    func loadInfo(info: Dictionary<String, String>) {
        identifier = info["goodsId"]
        activityID = info["actiId"]
        activityTitle = info["actiTitle"]
        activityImageName = info["actiImage"]
        tripDate = info["date"]
        tripTime = info["time"]
        tripPersonCount = info["number"]
        price = info["price"]
        totalPrice = info["totalPrice"]
    }
}
