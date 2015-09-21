//
//  mylistViewController.h
//  O2Trip
//
//  Created by tao on 15/5/12.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mylistViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)setButtonClick:(id)sender;





@end
