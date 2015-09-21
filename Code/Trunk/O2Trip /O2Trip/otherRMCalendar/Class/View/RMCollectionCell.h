//
//  RMCollectionCell.h
//  RMCalendar
//
//  Created by 迟浩东 on 15/7/15.
//  Copyright © 2015年 迟浩东(http://www.ruanman.net). All rights reserved.
//

#import <UIKit/UIKit.h>
@class RMCalendarModel;

@interface RMCollectionCell : UICollectionViewCell
{
    BOOL isfue;
}
@property(nonatomic, strong) RMCalendarModel *model;

@end
