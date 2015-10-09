//
//  RefreshAndLoadTableView.swift
//  O2Trip
//
//  Created by Quan on 15/10/9.
//  Copyright © 2015年 lst. All rights reserved.
//

import UIKit

class RefreshAndLoadTableView: UITableView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
        
    var refreshControl: UIRefreshControl? = nil
    
    func enableRefresh(target: NSObject, refresh: Selector) {
        if refreshControl != nil {
            return
        }
        
        refreshControl = UIRefreshControl(frame: CGRectMake(0, 0, self.bounds.size.width, 60))
        refreshControl!.tintColor = UIColor.lightGrayColor()
        refreshControl!.attributedTitle = NSAttributedString(string: "下拉刷新")
        refreshControl!.addTarget(target, action: refresh, forControlEvents: UIControlEvents.ValueChanged)
        self.addSubview(refreshControl!)
    }
    
    func enableLoadMore() {
        
    }
    
    // MARK: - Private
    

}
