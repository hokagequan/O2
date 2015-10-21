//
//  ShoppingCartItem.swift
//  O2Trip
//
//  Created by Q on 15/9/23.
//  Copyright © 2015年 lst. All rights reserved.
//

import Foundation

class ShoppingCartItem: NSObject {
    
    var identifier: String?
    var activityID: String?
    var activityTitle: String?
    var activityImageName: String?
    var tripDate: String?
    var tripTime: String?
    var tripPersonCount: Int = 0
    var adultCount: Int = 0
    var youngCount: Int = 0
    var childCount: Int = 0
    var price: Int = 0
    var youngPrice: Int = 0
    var childPrice: Int = 0
    var totalPrice: Int = 0
    
    func loadInfo(info: Dictionary<String, AnyObject>) {
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
    
    func loadInfoFromModel(model: actiDetailModel) {
        self.activityID = model.actiId
        self.activityTitle = model.actiTitle
        self.tripDate = model.startDate
        self.tripTime = "00:00"
        self.adultCount = 1
        self.youngCount = 0
        self.childCount = 0
        let intPrice = Int(model.actiPrice)
        self.price = intPrice ?? 0
        self.youngPrice = self.price
        self.childPrice = self.price
        self.totalPrice = self.price * self.adultCount + self.youngPrice * self.youngCount + self.childPrice * self.childCount
    }
}
