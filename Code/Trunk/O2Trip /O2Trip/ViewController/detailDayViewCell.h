//
//  HomeViewCCell.h
//  O2Trip
//
//  Created by zhangwen on 15/5/15.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface detailDayViewCell : UITableViewCell<UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UILabel *jieshao;



@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *huodongLabel;




@end
