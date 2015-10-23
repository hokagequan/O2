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
            return NSUserDefaults.standardUserDefaults().objectForKey("loginUserId") as! String
        }
    }
    
    class func sharedInstance() -> ODataManager {
        return odataManager
    }
}
