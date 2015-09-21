//
//  HomeViewACell.h
//  O2Trip
//
//  Created by zhangwen on 15/5/15.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface detailIntroduceViewCell : UITableViewCell<UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;

@property (weak, nonatomic) IBOutlet UILabel *biaoTi;
@property (weak, nonatomic) IBOutlet UILabel *bgLabel;

@property (weak, nonatomic) IBOutlet UILabel *jiage;

@property (weak, nonatomic) IBOutlet UILabel *jianjie;


@property (weak, nonatomic) IBOutlet UIScrollView *slideScrollView;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *trafficLabel;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;





@end
