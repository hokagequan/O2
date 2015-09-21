//
//  HomeViewDCell.h
//  O2Trip
//
//  Created by zhangwen on 15/5/15.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface detailCommentViewCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabe;
@property (weak, nonatomic) IBOutlet UILabel *reViewLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;



@end
