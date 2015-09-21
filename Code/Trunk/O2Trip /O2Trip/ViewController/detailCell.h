//
//  detailCell.h
//  O2Trip
//
//  Created by tao on 15/5/13.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanseLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowLabel;
@property (weak, nonatomic) IBOutlet UIButton *zanLabel;
@property (weak, nonatomic) IBOutlet UILabel *CountsLabel;
@property (weak, nonatomic) IBOutlet UILabel *bgLabel;


@end
