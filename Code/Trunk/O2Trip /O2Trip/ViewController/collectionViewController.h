//
//  collectionViewController.h
//  O2Trip
//
//  Created by tao on 15/5/14.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "collectionCell.h"
@interface collectionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    BOOL iscollection;
    BOOL isclip;
    NSInteger _indexpah;
    collectionCell* _cell;
    BOOL isEdting;
    BOOL isNil;
    BOOL flag[10000];
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray* array;
- (IBAction)backButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *bianji;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property(nonatomic,strong)NSMutableArray* cellArray;
@end
