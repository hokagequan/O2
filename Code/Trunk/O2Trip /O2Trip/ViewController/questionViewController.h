//
//  questionViewController.h
//  O2Trip
//
//  Created by tao on 15/7/6.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface questionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tabelView;
@property(nonatomic,strong)NSMutableArray*  array;
- (IBAction)backButtonClick:(id)sender;
@end
