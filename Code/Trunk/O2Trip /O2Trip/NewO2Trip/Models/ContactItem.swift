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
    var name: String?
    var weixin: String?
    var phone: String?
    var email: String?
    
    func loadInfo(info: Dictionary<String, String>) {
        identifier = info["contactId"]
        let firstName = info["firstName"]
        let lastName = info["lastName"]
        name = "\(lastName)\(firstName)"
        weixin = info["weChat"]
        phone = info["mobile"]
        email = info["email"]
    }

}
