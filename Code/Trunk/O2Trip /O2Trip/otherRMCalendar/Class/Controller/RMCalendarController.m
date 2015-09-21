//
//  RMCalendarController.m
//  RMCalendar
//
//  Created by 迟浩东 on 15/7/15.
//  Copyright © 2015年 迟浩东(http://www.ruanman.net). All rights reserved.
//

#import "RMCalendarController.h"
#import "RMCalendarCollectionViewLayout.h"
#import "RMCollectionCell.h"
#import "RMCalendarMonthHeaderView.h"
#import "RMCalendarLogic.h"
#import "reservationViewController.h"
#import "UserViewModel.h"
#import "maxModel.h"
#define ALERTVIEW(STRING) UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:STRING delegate:self cancelButtonTitle:nil  otherButtonTitles:@"确定", nil];\
[alertView show];
@interface RMCalendarController ()<UICollectionViewDataSource, UICollectionViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray* _kindArray;
    UIView * _moView;
    UIView* _bgView;
    NSString* _timeString;
    BOOL isSelect;
    UIPickerView* _pickerView;
}
@end

@implementation RMCalendarController

static NSString *MonthHeader = @"MonthHeaderView";

static NSString *DayCell = @"DayCell";

/**
 *  初始化模型数组对象
 */
- (NSMutableArray *)calendarMonth {
    if (!_calendarMonth) {
        _calendarMonth = [NSMutableArray array];
    }
    return _calendarMonth;
}

- (RMCalendarLogic *)calendarLogic {
    if (!_calendarLogic) {
        _calendarLogic = [[RMCalendarLogic alloc] init];
    }
    return _calendarLogic;
}

- (instancetype)initWithDays:(int)days showType:(CalendarShowType)type modelArrar:(NSMutableArray *)modelArr {
    self = [super init];
    if (!self) return nil;
    self.days = days;
    self.type = type;
    self.modelArr = modelArr;
    return self;
}

- (instancetype)initWithDays:(int)days showType:(CalendarShowType)type {
    self = [super init];
    if (!self) return nil;
    self.days = days;
    self.type = type;
    return self;
}

+ (instancetype)calendarWithDays:(int)days showType:(CalendarShowType)type modelArrar:(NSMutableArray *)modelArr {
    return [[self alloc] initWithDays:days showType:type modelArrar:modelArr];
}

+ (instancetype)calendarWithDays:(int)days showType:(CalendarShowType)type {
    return [[self alloc] initWithDays:days showType:type];
}

- (void)setModelArr:(NSMutableArray *)modelArr {
#if __has_feature(objc_arc)
    _modelArr = modelArr;
#else
    if (_modelArr != modelArr) {
        [_modelArr release];
        _modelArr = [modelArr retain];
    }
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manArray=[[NSMutableArray alloc]initWithCapacity:0];
    self.stateTimeArray=[[NSMutableArray alloc]initWithCapacity:0];
    UserViewModel* userModel=[[UserViewModel alloc]init];
    [userModel getStartTime:self.actiId];
    [userModel setBlockWithReturnBlock:^(id returnValue) {
        _kindArray=returnValue;
        NSLog(@"_kindArray==%@",_kindArray);
        [_kindArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[maxModel class]]) {
                [self.manArray addObject:obj];
              
            }else
            {
                [self.stateTimeArray addObject:obj];
              
            }
        }];
        [_pickerView reloadAllComponents];
    } WithErrorBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
    if (self.year.length!=0) {
         [self.selectDateButton setTitle:[NSString stringWithFormat:@"预定%@年%@月%@日",self.year,self.month,self.day] forState:UIControlStateNormal];
    }
    
       //选择日期按钮
    [self.selectDateButton addTarget:self action:@selector(selectDateButton:) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor=[UIColor whiteColor];
    // 定义Layout对象
    
    RMCalendarCollectionViewLayout *layout = [[RMCalendarCollectionViewLayout alloc] init];
    self.collectionView.collectionViewLayout=layout;
    // 初始化CollectionView
    //self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(16, self.headLabel.frame.size.height+self.footLabel.frame.size.height, self.view.frame.size.width-32, self.view.frame.size.height/1.55) collectionViewLayout:layout];
    
#if !__has_feature(objc_arc)
    [layout release];
#endif
    
    // 注册CollectionView的Cell
    [self.collectionView registerClass:[RMCollectionCell class] forCellWithReuseIdentifier:DayCell];
    
    [self.collectionView registerClass:[RMCalendarMonthHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader];
    
//    self.collectionView.bounces = NO;//将网格视图的下拉效果关闭
    
    self.collectionView.delegate = self;//实现网格视图的delegate
    self.collectionView.dataSource = self;//实现网格视图的dataSource
    self.collectionView.showsHorizontalScrollIndicator=NO;
    self.collectionView.showsVerticalScrollIndicator=NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];

    self.calendarMonth = [self getMonthArrayOfDays:self.days showType:self.type isEnable:self.isEnable modelArr:self.modelArr];
}
//创建弹出的试图
-(void)setShowView
{
    _moView=[[UIView alloc]initWithFrame:self.view.frame];
    _moView.backgroundColor=[UIColor blackColor];
    _moView.alpha=0;
    [self.view addSubview:_moView];
    _bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 1500, self.view.frame.size.width, self.view.frame.size.height-self.collectionView.frame.size.height-self.collectionView.frame.origin.y-29)];
    _bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_bgView];
    UILabel* bgLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _bgView.frame.size.width, 45)];
    bgLabel.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_bgView addSubview:bgLabel];
    UIButton* cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame=CGRectMake(0, 0, 60, 45);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font=[UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:13];
    [cancelButton setTitleColor:[UIColor colorWithRed:26/255.0 green:188/255.0 blue:156/255.0 alpha:1] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:cancelButton];
    UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(60, 0, self.view.frame.size.width-(60*2), 45)];
    label.text=@"请选择活动时间";
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:11];
    label.textColor=[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    [_bgView addSubview:label];
    UIButton* finishzButton=[UIButton buttonWithType:UIButtonTypeCustom];
    finishzButton.frame=CGRectMake(_bgView.frame.size.width-60, 0,60, 45);
    [finishzButton setTitle:@"确定" forState:UIControlStateNormal];
    finishzButton.titleLabel.font=[UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:13];
    [finishzButton setTitleColor:[UIColor colorWithRed:26/255.0 green:188/255.0 blue:156/255.0 alpha:1] forState:UIControlStateNormal];
    [finishzButton addTarget:self action:@selector(finishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:finishzButton];
     _pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, 162)];
    //注意：如果你想让pickView现实数据，一定要设置数据源协议
     _pickerView.dataSource = self;
    //注意：如果你想使用pickView的代理方法，一定要设置delegate
     _pickerView.delegate = self;
    //现实选中框
    [ _pickerView showsSelectionIndicator];
    //选中第几列的第几行
    [_pickerView selectRow:0 inComponent:0 animated:YES];
   

    [_bgView addSubview:  _pickerView];
   
}
//选择时间点击事件
-(void)selectDateButton:(UIButton*)button
{
    if (self.stateTimeArray.count!=0) {
        _timeString=[self.stateTimeArray objectAtIndex:0];

    }
      if (self.year.length==0) {
        ALERTVIEW(@"请先选择日期");
    }else
    {
        if (isSelect==NO) {
            [self setShowView];
            [ self performSelector:@selector(showView:) withObject:button afterDelay:0.2];
            
        }else
        {
            UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            reservationViewController* reservationVC=[SB instantiateViewControllerWithIdentifier:@"reservationViewController"];
            reservationVC.actiName=self.actiName;
            reservationVC.yearString=self.year;
            reservationVC.monthString=self.month;
            reservationVC.dayString=self.day;
            reservationVC.priceString=self.ticketPrice;
            reservationVC.dateString=_timeString;
            reservationVC.maxArray=self.manArray;
            reservationVC.actiId=self.actiId;
            NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
            [userDefaults setObject:self.actiId forKey:@"actiId"];
            [userDefaults synchronize];
            [self.navigationController pushViewController:reservationVC animated:YES];
        }

    }
    
}
//弹出选择时间试图
-(void)showView:(UIButton*)button
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    _moView.alpha=0.3;
    _bgView.frame=CGRectMake(0, self.collectionView.frame.size.height+29+self.collectionView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-self.collectionView.frame.size.height-self.collectionView.frame.origin.y-29);
    [UIView commitAnimations];
}
//取消的点击事件
-(void)cancelButtonClick:(UIButton*)button
{
    [_moView removeFromSuperview];
    [_bgView removeFromSuperview];
}
//确定选取的点击事件
-(void)finishButtonClick:(UIButton*)button
{
    [_moView removeFromSuperview];
    [_bgView removeFromSuperview];
   
    UILabel* Bglabel=[[UILabel alloc]initWithFrame:CGRectMake(0, self.collectionView.frame.size.height+self.collectionView.frame.origin.y+45, self.view.frame.size.width, 30)];
    Bglabel.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:Bglabel];
    UILabel* label1=[[UILabel alloc]initWithFrame:CGRectMake(16, self.collectionView.frame.size.height+self.collectionView.frame.origin.y+45, 60,30)];
    label1.text=@"出发时间";
    label1.font=[UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:11];
    [self.view addSubview:label1];
    UILabel* label2=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-16-60, self.collectionView.frame.size.height+self.collectionView.frame.origin.y+45, 60, 30)];
    label2.textAlignment=NSTextAlignmentRight;
    label2.text=_timeString;
    label2.font=[UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:11];
    [self.view addSubview:label2];
    [self.selectDateButton setTitle:[NSString stringWithFormat:@"预定%@年%@月%@日%@",self.year,self.month,self.day,_timeString] forState:UIControlStateNormal];
    isSelect=YES;
    
}
#pragma mark   ----UIPickerViewDataSource----
//设置pickerView现实几列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //列
    return 1;
}
//设置每列可以现实的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //行
    
    //设置第0列的行数
   
        return self.stateTimeArray.count;
   
}
//每列现实的数据
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
        return [self.stateTimeArray objectAtIndex:row];
    
  
}
//点击选择row
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString* string=[self.stateTimeArray objectAtIndex:row];
//     [self.selectDateButton setTitle:[NSString stringWithFormat:@"预定%@年%@月%@日%@",self.year,self.month,self.day,string] forState:UIControlStateNormal];
    //[_selectDateButton setTitle:string forState:UIControlStateNormal];
    _timeString=string;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  获取Days天数内的数组
 *
 *  @param days 天数
 *  @param type 显示类型
 *  @param arr  模型数组
 *  @return 数组
 */
- (NSMutableArray *)getMonthArrayOfDays:(int)days showType:(CalendarShowType)type isEnable:(BOOL)isEnable modelArr:(NSArray *)arr
{
    NSDate *date = [NSDate date];
    
    NSDate *selectdate  = [NSDate date];
    //返回数据模型数组
    return [self.calendarLogic reloadCalendarView:date selectDate:selectdate needDays:days showType:type isEnable:isEnable priceModelArr:arr isChineseCalendar:self.isDisplayChineseCalendar];
}

#pragma mark - CollectionView 数据源

// 返回组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.calendarMonth.count;
}
// 返回每组行数
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *arrary = [self.calendarMonth objectAtIndex:section];
    return arrary.count;
}

#pragma mark - CollectionView 代理

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RMCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DayCell forIndexPath:indexPath];
    NSArray *months = [self.calendarMonth objectAtIndex:indexPath.section];
    RMCalendarModel *model = [months objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
        RMCalendarModel *model = [month_Array objectAtIndex:15];
        RMCalendarMonthHeaderView *monthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader forIndexPath:indexPath];
        monthHeader.masterLabel.text = [NSString stringWithFormat:@"%lu年 %lu月",(unsigned long)model.year,(unsigned long)model.month];//@"日期";
        monthHeader.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
        reusableview = monthHeader;
    }
    return reusableview;
    
}

- (void)collectionView:(nonnull UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSArray *months = [self.calendarMonth objectAtIndex:indexPath.section];
    RMCalendarModel *model = [months objectAtIndex:indexPath.row];
    if (model.style == CellDayTypeClick || model.style == CellDayTypeFutur || model.style == CellDayTypeWeek) {
        [self.calendarLogic selectLogic:model];
        if (self.calendarBlock) {
            self.calendarBlock(model);
        }
    }
    [self.collectionView reloadData];
}

- (BOOL)collectionView:(nonnull UICollectionView *)collectionView shouldSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return YES;
}
//返回上一页
- (IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dealloc {
#if !__has_feature(objc_arc)
    [self.collectionView release];
    [super dealloc];
#endif
}



@end
