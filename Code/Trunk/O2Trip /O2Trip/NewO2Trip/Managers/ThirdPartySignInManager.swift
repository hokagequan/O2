//
//  ThirdPartySignInManager.swift
//  O2Trip
//
//  Created by Q on 15/10/29.
//  Copyright © 2015年 lst. All rights reserved.
//

import UIKit

enum ThirdPartyType: Int {
    case Weibo = 0
    case Wechat
    case QQ
}

class ThirdPartySignInManager: NSObject, WeiboSDKDelegate, WBHttpRequestDelegate, TencentSessionDelegate {
    
    static let thirdPartySignInManager = ThirdPartySignInManager()
    
    let qqAppID = ""
    
    var tencentOAuth: TencentOAuth? = nil
    
    var isDoingSignIn = false
    
    class func defaultManager() -> ThirdPartySignInManager {
        return thirdPartySignInManager
    }
    
    class func isQQInstalled() -> Bool {
        return TencentOAuth.iphoneQQInstalled()
    }
    
    class func isWechatInstalled() -> Bool {
        return WXApi.isWXAppInstalled()
    }
    
    override init() {
        super.init()
        
        tencentOAuth = TencentOAuth(appId: qqAppID, andDelegate: self)
    }
    
    // MARK: - Private
    
    func getWeiboUserInfo() {
        WBHttpRequest(URL: "https://api.weibo.com/2/users/show.json", httpMethod: "GET", params: ["access_token": self.wbToken, @"uid": self.thirdPartyUserInfo.userId], delegate: <#T##WBHttpRequestDelegate!#>, withTag: <#T##String!#>)
//        [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/users/show.json"
//        httpMethod:@"GET"
//        params:@{@"access_token": self.wbToken, @"uid": self.thirdPartyUserInfo.userId}
//        delegate:self
//        withTag:@"getUserInfo"];
    }
    
}
