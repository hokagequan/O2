//
//  UIViewController+ShowAlert.swift
//  O2Trip
//
//  Created by Quan on 15/9/22.
//  Copyright © 2015年 lst. All rights reserved.
//

import Foundation

extension UIViewController {
    
    func showAlert(message: String) {
        let alert = UIAlertView(title: nil, message: message, delegate: nil, cancelButtonTitle: "确定")
        alert.show()
    }
    
}