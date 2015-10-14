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

class PayManager {
    static let sharedPayManager = PayManager()
    
    var isPaying = false
    
    class func sharedInstance() -> PayManager {
        return sharedPayManager
    }
    
    func pay(mode: PayMode) {
        switch mode {
        case .WeiXin:
            payUsingWeChat()
            break
        case .ZhiFuBao:
            payUsingZhiFuBao()
            break
        }
    }
    
    func payUsingWeChat() {}
    
    func payUsingZhiFuBao() {}
}