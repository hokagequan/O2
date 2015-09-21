//
//  scrollCell.m
//  O2Trip
//
//  Created by tao on 15/7/7.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "scrollCell.h"

@implementation scrollCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _Label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 1, 40, 74)];
        _Label1.font=[UIFont systemFontOfSize:7];
        [self addSubview:_Label1];
        
        _Label2 = [[UILabel alloc] initWithFrame:CGRectMake(20,-4, 45,60)];
        _Label2.textAlignment=NSTextAlignmentCenter;
        _Label2.font=[UIFont systemFontOfSize:7];
        [self addSubview:_Label2];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
