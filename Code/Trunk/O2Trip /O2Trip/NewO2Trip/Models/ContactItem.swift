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
    var gender: String?
    var isDefalut: Bool = false
    
    func loadInfo(info: Dictionary<String, AnyObject>) {
        let intIdentifier = info["id"] as! Int
        identifier = "\(intIdentifier)"
        firstName = info["lastName"] as! String
        lastName = info["firstName"] as! String
        pinyin = info["py"] as? String
        weixin = info["weChat"] as? String
        phone = info["mobile"] as? String
        email = info["email"] as? String
        let intGender = info["sex"] as! Int
        gender = "\(intGender)"
        isDefalut = info["default"] as! Bool
    }

}
