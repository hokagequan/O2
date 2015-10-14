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

class PayManager: NSObject, WXApiDelegate, APOpenAPIDelegate {
    static let sharedPayManager = PayManager()
    
    let wechatHandler = WeChatHandler()
    let alipayHandler = AliPayHandler()
    
    var isPaying = false
    weak var delegate: PayManagerDelegate?
    
    class func sharedInstance() -> PayManager {
        return sharedPayManager
    }
    
    func handleOpenUrl(url: NSURL) -> Bool {
        var success = WXApi.handleOpenURL(url, delegate: wechatHandler)
        success = APOpenAPI.handleOpenURL(url, delegate: alipayHandler)
        
        return success
    }
    
    func pay(mode: PayMode, params: Dictionary<String, AnyObject>) {
        switch mode {
        case .WeiXin:
            payUsingWeChat(params)
            break
        case .ZhiFuBao:
            payUsingZhiFuBao(params)
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
    
    func payUsingZhiFuBao(params: Dictionary<String, AnyObject>) {}
}

class WeChatHandler: NSObject, WXApiDelegate {
    // MARK: - WXApiDelegate
    
    func onResp(resp: BaseResp!) {
        if resp is PayResp {
            if resp.errCode == WXSuccess.rawValue {
                // 成功
                PayManager.sharedInstance().delegate?.didWeChatPayComplete?(PayManager.sharedInstance(), success: true)
            }
            else {
                // 失败
                PayManager.sharedInstance().delegate?.didAliPayComplete?(PayManager.sharedInstance(), success: false)
            }
        }
    }
}

class AliPayHandler: NSObject, APOpenAPIDelegate {
    // MARK: AliPayDelegate
    
    func onReq(req: APBaseReq!) {
        
    }
}