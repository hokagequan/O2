//
//  RefreshAndLoadTableView.swift
//  O2Trip
//
//  Created by Quan on 15/10/9.
//  Copyright © 2015年 lst. All rights reserved.
//

import UIKit

class RefreshAndLoadTableView: UITableView, RefreshControlDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
        
    var refreshControl: UIRefreshControl? = nil
    var loadMoreControl: RefreshControl? = nil
    var loadMoreSelector: Selector? = nil
    weak var loadMoreTarget: NSObject? = nil
    
    func enableRefresh(target: NSObject, refresh: Selector) {
        if refreshControl != nil {
            return
        }
        
        loadMoreTarget = target
        refreshControl = UIRefreshControl(frame: CGRectMake(0, 0, self.bounds.size.width, 60))
        refreshControl!.tintColor = UIColor.lightGrayColor()
        refreshControl!.attributedTitle = NSAttributedString(string: "下拉刷新")
        refreshControl!.addTarget(target, action: refresh, forControlEvents: UIControlEvents.ValueChanged)
        self.addSubview(refreshControl!)
    }
    
    func enableLoadMore(target: NSObject, loadMore: Selector) {
        if loadMoreControl != nil {
            return
        }
        
        loadMoreControl = RefreshControl(scrollView: self, delegate: self)
        loadMoreControl?.bottomEnabled = true
        loadMoreSelector = loadMore
    }
    
    func endLoadMore() {
        loadMoreControl?.finishRefreshingDirection(RefreshDirectionBottom)
    }
    
    // MARK: - Private
    
    // MARK: - RefreshControl
    func refreshControl(refreshControl: RefreshControl!, didEngageRefreshDirection direction: RefreshDirection) {
        if direction == RefreshDirectionBottom {
            loadMoreTarget?.performSelector(loadMoreSelector!)
        }
    }

}
