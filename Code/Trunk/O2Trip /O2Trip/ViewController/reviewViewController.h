//
//  reviewViewController.h
//  O2Trip
//
//  Created by tao on 15/5/14.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface reviewViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tabelView;
@property(nonatomic,strong)NSMutableArray* array;
- (IBAction)backButtonClick:(id)sender;

@end
