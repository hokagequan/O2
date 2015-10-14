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
    
    func handleOpenUrl(url: NSURL) -> Bool {
        return WXApi.handleOpenURL(url, delegate: self)
    }
    
    func pay(mode: PayMode, params: Dictionary<String, AnyObject>?, order: AliPayOrder?) {
        switch mode {
        case .WeiXin:
            if params == nil {
                delegate?.didWeChatPayComplete?(self, success: false)
                return
            }
            
            payUsingWeChat(params!)
            
            break
        case .ZhiFuBao:
            if order == nil {
                delegate?.didAliPayComplete?(self, success: false)
                return
            }
            payUsingZhiFuBao(order!)
            
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
    
    func payUsingZhiFuBao(order: AliPayOrder) {
        let orderString = order.orderDescription()
        // TODO: 支付宝支付
    }
    
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

class AliPayOrder: NSObject {
    
    let partener: String = ""
    let seller: String = ""
    let notifyUrl: String = ""
    let service: String = "mobile.securitypay.pay"
    let paymentType: String = "1"
    let inputCharset: String = "utf-8"
    let itBPay: String = "30m"
    let showUrl: String = "m.alipay.com"
    var orderNo: String?
    var productName: String?
    var productDescription: String?
    var amount: String?
    
    func orderDescription() -> String {
        var relString = ""
        relString += "partner=\(partener)"
        relString += "&seller_id=\(seller)"
        relString += "&notify_url=\(notifyUrl)"
        relString += "&service=\(service)"
        relString += "&payment_type=\(paymentType)"
        relString += "&_input_charset=\(inputCharset)"
        relString += "&it_b_pay=\(itBPay)"
        relString += "&show_url=\(showUrl)"
        
        if orderNo != nil {
            relString += "&out_trade_no=\(orderNo!)"
        }
        if (productName != nil) {
            relString += "&subject=\(productName!)"
        }
        if (productDescription != nil) {
            relString += "&body=\(productDescription!)"
        }
        if (amount != nil) {
            relString += "&total_fee=\(amount!)"
        }

        return relString;
    }
    
}
