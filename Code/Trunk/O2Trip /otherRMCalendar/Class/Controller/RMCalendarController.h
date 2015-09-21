//
//  RMCalendarController.h
//  RMCalendar
//
//  Created by 迟浩东 on 15/7/15.
//  Copyright © 2015年 迟浩东(http://www.ruanman.net). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMCalendarLogic.h"
/**
 *  选中日起，回掉结果
 *
 *  @param model 返回模型
 */
typedef void (^CalendarBlock)(RMCalendarModel *model);


/**
 *  起始页面
 */
@interface RMCalendarController : UIViewController

/**
 *  UICollectionView 对象，用于显示布局，类似UITableView
 */

/**
 *  用于存放日期模型数组
 */
@property(nonatomic ,strong) NSMutableArray *calendarMonth;
/**
 *  逻辑处理
 */
@property(nonatomic ,strong) RMCalendarLogic *calendarLogic;
/**
 *  回调
 */
@property(nonatomic, copy) CalendarBlock calendarBlock;
/**
 *  天数
 */
@property(nonatomic, assign) int days;
/**
 *  展示类型
 */
@property(nonatomic, assign) CalendarShowType type;
/**
 *  用于存放价格模型数组
 */
@property(nonatomic, retain) NSMutableArray *modelArr;
/**
 *  无价格的日期是否可点击  默认为NO
 */
@property(nonatomic, assign) BOOL isEnable;
/**
 *  是否展示农历  默认为NO
 */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic, assign) BOOL isDisplayChineseCalendar;
@property (weak, nonatomic) IBOutlet UILabel *headLabel;
@property (weak, nonatomic) IBOutlet UILabel *footLabel;
- (IBAction)backButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *selectDateButton;
@property(nonatomic,strong)NSString* year;
@property(nonatomic,strong)NSString* month;
@property(nonatomic,strong)NSString* day;
@property(nonatomic,strong)NSString* ticketPrice;
@property(nonatomic,strong)NSString* actiName;
@property(nonatomic,strong)NSString* actiId;
@property(nonatomic,strong)NSMutableArray* stateTimeArray;
@property(nonatomic,strong)NSMutableArray* manArray;
/**
 *  初始化对象
 *
 *  @param days 显示总天数，默认365天
 *  @param type 显示类型，详细请见 枚举的定义
 *
 *  @return 当前对象
 */
- (instancetype)initWithDays:(int)days showType:(CalendarShowType)type;

- (instancetype)initWithDays:(int)days showType:(CalendarShowType)type modelArrar:(NSMutableArray *)modelArr;

+ (instancetype)calendarWithDays:(int)days showType:(CalendarShowType)type;

+ (instancetype)calendarWithDays:(int)days showType:(CalendarShowType)type modelArrar:(NSMutableArray *)modelArr;


@end
