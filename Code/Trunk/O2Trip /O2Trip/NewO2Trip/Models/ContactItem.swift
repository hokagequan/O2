//
//  ContactItem.swift
//  O2Trip
//
//  Created by Quan on 15/9/25.
//  Copyright © 2015年 lst. All rights reserved.
//

import Foundation

class ContactItem {
    
    var identifier: String?
    var firstName: String = ""
    var lastName: String = ""
    var pinyin: String?
    var weixin: String?
    var phone: String?
    var email: String?
    var gender: String {
        get {
            switch intGender {
            case 1:
                return "男"
            case 0:
                return "女"
            default:
                return ""
            }
        }
        set {
            switch newValue {
            case "男":
                intGender = 1
                break
            case "女":
                intGender = 0
                break
            default:
                intGender = 1
            }
        }
    }
    var isDefalut: Bool = false
    
    var intGender = 0
    
    func loadInfo(info: Dictionary<String, AnyObject>) {
        let intIdentifier = info["id"] as! Int
        identifier = "\(intIdentifier)"
        firstName = info["lastName"] as! String
        lastName = info["firstName"] as! String
        pinyin = info["py"] as? String
        weixin = info["weChat"] as? String
        phone = info["mobile"] as? String
        email = info["email"] as? String
        intGender = info["sex"] as! Int
        isDefalut = info["default"] as! Bool
    }

}
