//
//  ODataManager.swift
//  O2Trip
//
//  Created by Q on 15/10/21.
//  Copyright © 2015年 lst. All rights reserved.
//

import UIKit

class ODataManager: NSObject {
    static let odataManager = ODataManager()
    
    var userID: String {
        get {
            // FIXME: Test
            return "b332b764-81fc-4ae9-bf6f-023e654af9d7"
//            return NSUserDefaults.standardUserDefaults().objectForKey("loginUserId") as! String
        }
    }
    
    class func sharedInstance() -> ODataManager {
        return odataManager
    }
}
