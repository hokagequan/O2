//
//  PayManager.swift
//  O2Trip
//
//  Created by Quan on 15/10/7.
//  Copyright © 2015年 lst. All rights reserved.
//

import Foundation

enum PayMode: Int {
    case WeiXin = 0
    case ZhiFuBao
}

@objc protocol PayManagerDelegate {
    optional func didWeChatPayComplete(manager: PayManager, success: Bool)
    optional func didAliPayComplete(manager: PayManager, success: Bool)
}

class PayManager: NSObject, WXApiDelegate {
    static let sharedPayManager = PayManager()
    
    var isPaying = false
    weak var delegate: PayManagerDelegate?
    
    class func sharedInstance() -> PayManager {
        return sharedPayManager
    }
    
    func pay(mode: PayMode, params: Dictionary<String, AnyObject>) {
        switch mode {
        case .WeiXin:
            payUsingWeChat(params)
            break
        case .ZhiFuBao:
            payUsingZhiFuBao()
            break
        }
    }
    
    func payUsingWeChat(params: Dictionary<String, AnyObject>) {
        let req = PayReq()
        req.openID              = params["appid"] as! String
        req.partnerId           = params["partnerid"] as! String
        req.prepayId            = params["prepayid"] as! String
        req.nonceStr            = params["noncestr"] as! String
        req.timeStamp           = params["timestamp"] as! UInt32
        req.package             = params["package"] as! String
        req.sign                = params["sign"] as! String
        WXApi.sendReq(req)
    }
    
    func payUsingZhiFuBao() {}
    
    // MARK: - WXApiDelegate
    
    func onResp(resp: BaseResp!) {
        if resp is PayResp {
            if resp.errCode == WXSuccess.rawValue {
                // 成功
                delegate?.didWeChatPayComplete?(self, success: true)
            }
            else {
                // 失败
                delegate?.didAliPayComplete?(self, success: false)
            }
        }
    }
}