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
    var firstName: String?
    var lastName: String?
    var pinyin: String?
    var weixin: String?
    var phone: String?
    var email: String?
    var gender: String?
    
    func loadInfo(info: Dictionary<String, String>) {
        identifier = info["contactId"]
        firstName = info["lastName"]
        lastName = info["firstName"]
        pinyin = info["py"]
        weixin = info["weChat"]
        phone = info["mobile"]
        email = info["email"]
    }

}
