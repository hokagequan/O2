//
//  detailactivityViewController.m
//  O2Trip
//
//  Created by tao on 15/5/15.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "detailactivityViewController.h"
#import "detailIntroduceViewCell.h"
#import "detailMapViewCell.h"
#import "detailDayViewCell.h"
#import "detailCommentViewCell.h"
#import "detailCostnotesViewCell.h"
#import "detailPromptViewCell.h"
#import "bigMapViewController.h"
#import "detailButtonViewCell.h"
#import "detailButtonViewCell.h"
#import "UserViewModel.h"
#import "UIImageView+WebCache.h"
#import <MapKit/MapKit.h>
#import "GiFHUD.h"
#import <CoreLocation/CoreLocation.h>
#import "MJAnnotation.h"
#import "Reachability.h"
#import "timeModel.h"
#import "scrollCell.h"
#import "LoginViewController.h"
#import "RMCalendarController.h"
#import "MJExtension.h"
#import "TicketModel.h"
#import "timeViewModel.h"
#import "yearModel.h"
#import "middleViewController.h"
#define ALERTVIEW(STRING) UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:STRING delegate:self cancelButtonTitle:nil  otherButtonTitles:@"确定", nil];\
[alertView show];
#define STRING_SIZE(TEXT,FONT) CGSize size = [TEXT boundingRectWithSize:CGSizeMake(262, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FONT]} context:nil].size;
@interface detailactivityViewController (private)

-(void)reachabilityChanged:(NSNotification*)note;

@end

@interface detailactivityViewController()<UITextViewDelegate>

{
    NSString* _msg;
    detailMapViewCell* _bcell;
    NSMutableArray* _problemArray;
    UIView* _qusetionView;
    UIView* _commentsView;
    NSMutableArray* _imageArray;
    NSMutableArray* _dicArray;
    detailCostnotesViewCell* _ecell;
    NSMutableArray* _array1;
    detailCommentViewCell* _dcell;
    detailIntroduceViewCell* _cell;
    detailDayViewCell* _cell1;
    detailPromptViewCell* _fcell;
    UIView* myView;
    UILabel* _Bglabel;
    BOOL cellOne;
 
    BOOL cellTwo;

    BOOL cellS;
    int k1;
    int k2;
    BOOL cellS1;
    BOOL cellS2;
    int l;
    BOOL cellFour;
    int m;
    BOOL cellFive;
    UITextView* _textView;
    UITextView* _textView1;
    NSMutableArray* _coodinateArray;
    BOOL isCollection;
    UITextField* _textField;
    float _buttonWidth;
}
@end
@implementation detailactivityViewController


-(void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    CAGradientLayer* layer=[CAGradientLayer layer];
    layer.frame=CGRectMake(0,0, self.bgLabel.frame.size.width, self.bgLabel.frame.size.height);
    layer.colors=[NSArray arrayWithObjects:(id)[UIColor blackColor].CGColor,(id)[UIColor clearColor].CGColor, nil];
    [self.bgLabel.layer insertSublayer:layer atIndex:0];
    self.collectionButton.alpha=1;
    self.backButton.alpha=1;
    _a=0;
    [GiFHUD setGifWithImageName:@"loading.gif"];
    [GiFHUD show];
    self.tableView.separatorStyle=  UITableViewCellSeparatorStyleNone;
    self.backButton.userInteractionEnabled=YES;
    self.array=[[NSMutableArray alloc]initWithCapacity:0];
    self.bigArray=[[NSMutableArray alloc]initWithCapacity:0];
    self.smallArray=[[NSMutableArray alloc]initWithCapacity:0];
    self.navigationController.automaticallyAdjustsScrollViewInsets=NO;
    self.tableView.tag=1;
    UserViewModel* userModel=[[UserViewModel alloc]init];
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    NSString* userId=[userDefaults objectForKey:@"loginUserId"];
    [userModel homeXQ:self.actiId withUserId:userId];
    [userModel setBlockWithReturnBlock:^(id returnValue) {
        self.array=returnValue;
        [GiFHUD dismiss];
        [self.array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[actiDetailModel class]]) {
                [self.bigArray addObject:obj];
                 [self getOtherRequest];
                actiDetailModel* actiModel=[self.bigArray lastObject];
                _problemArray=actiModel.problemsArray;
                
            }else
            {
                [self.smallArray addObject:obj];
                
            }
           
        }];
        actiDetailModel* actiModel=[self.bigArray lastObject];
        self.dayArray=actiModel.actiDay;
        [self.tableView reloadData];
        
           } WithErrorBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
    _tableView.allowsSelection=NO;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.navigationController.navigationBarHidden=YES;
 
    
}
//获取时间的请求
-(void)getOtherRequest
{
    
    UserViewModel* viewModel=[[UserViewModel alloc]init];
    actiDetailModel* actiModel=[self.bigArray lastObject];
    NSDate* date=[[NSDate alloc]init];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //2.设置格式器的格式
    //注意格式的设置：yyyy代表年  MM代表月  dd代表日  hh代表12小时的小时（HH代表24小时）   mm代表分  ss代表秒
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //3.把datePicker中的日期按照这种格式转换
    NSString* dateString = [dateFormatter stringFromDate:date];
    NSArray* array=[dateString componentsSeparatedByString:@"-"];
    NSString* year=[array objectAtIndex:0];
    NSString* month=[array objectAtIndex:1];
    [viewModel gettThreeMonthData:actiModel.actiId withYear:year withMonth:month withNumber:@"12"];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        self.timeArray=returnValue;
    
    } WithErrorBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];

}
-(void)connect
{
    UserViewModel* userModel=[[UserViewModel alloc]init];
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    NSString* userId=[userDefaults objectForKey:@"loginUserId"];
    [userModel homeXQ:self.actiId withUserId:userId];
    [userModel setBlockWithReturnBlock:^(id returnValue) {
        self.array=returnValue;
        [self.array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[actiDetailModel class]]) {
                [self.bigArray addObject:obj];
                
            }else
            {
                [self.smallArray addObject:obj];
                
            }
            
        }];
        actiDetailModel* actiModel=[self.bigArray lastObject];
        self.dayArray=actiModel.actiDay;
        [self.tableView reloadData];
       
    } WithErrorBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];

}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
        if (section==0) {
            return 1;
        }else if(section==1)
        {
            return 1;
        }else if(section==2)
        {
            return 1;
            
        }else if (section==3)
        {
            return 1;
        }
        else if(section==4)
        {
            if (isOneRow==YES) {
              
                return self.dayArray.count;
            }else
            {
                return 1;

            }
            
            //
        }else if(section==5)
        {
            
            return 1;
           
        }else if (section==6)
        {
            return 1;
            
        }else if (section==7)
        {
            return 1;
        }
        else if (section==8)
        {
             actiDetailModel* actiModel=[self.bigArray lastObject];
         
           
            if (isOneDiss==NO) {
                if (actiModel.dicArray.count<4) {
                    return actiModel.dicArray.count;
                }else
                {
                    return 3;
                }
            }else
            {
                return actiModel.dicArray.count;
            }
            
            
        }else
        {
            return 1;
        }

   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        if (indexPath.section==0) {
            return 432;
            

        }else if (indexPath.section==1)
        {
            return 160;
           
        }else if (indexPath.section==2)
        {
            actiDetailModel* actiModel=[self.bigArray lastObject];
           
            if (isStrech==NO) {
                return 183;
            }else
            {
                
                NSString* costNotes=actiModel.costNotes;
                 CGSize size1 = [costNotes boundingRectWithSize:CGSizeMake(180, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
                return size1.height+40;
            }
           
      
            
        }else if (indexPath.section==3)
        {
            actiDetailModel* actiModel=[self.bigArray lastObject];
           NSInteger height =[self textLabelHeight:actiModel.costNotes];
            if (height>4) {
                 return 18;
            }else
            {
                return 0;
            }
           
        }
        else if(indexPath.section==4)
        {
            if (isbigCell==NO) {
                return 293;
            }else{
                 NSDictionary* dic=[self.dayArray objectAtIndex:indexPath.row];
                NSString* desc=[dic objectForKey:@"secnicDesc"];
                CGSize size1 = [desc boundingRectWithSize:CGSizeMake(180, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
                return size1.height+30.0f+162+30;
            }
        }else if (indexPath.section==5)
        {
            NSDictionary* dic=[self.dayArray objectAtIndex:indexPath.row];
            NSString* desc=[dic objectForKey:@"secnicDesc"];
            NSInteger height =[self textLabelHeight:desc];
            if (height>4) {
                return 18;
            }else
            {
                return 0;
            }
           
        }
        else if(indexPath.section==6)
        {
            if (isScroll==NO) {
                return 171;
            }else
            {
                actiDetailModel* actiModel=[self.bigArray lastObject];
                NSString* prompt=actiModel.prompt;
                CGSize size1 = [prompt boundingRectWithSize:CGSizeMake(180, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
                return size1.height+110+60;
            }
    
        }else if (indexPath.section==7)
        {
            actiDetailModel* actiModel=[self.bigArray lastObject];
            NSString* prompt=actiModel.prompt;
           NSInteger height=[self textLabelHeight:prompt];
            if (height>4) {
                return 18;
            }else
            {
                return 0;
            }
            
        }else if (indexPath.section==8)
        {
            actiDetailModel* actiModel=[self.bigArray lastObject];
            NSDictionary* dic=[actiModel.dicArray objectAtIndex:indexPath.row];
            NSString* dissContent=[dic objectForKey:@"dissContent"];
             CGSize size1 = [dissContent boundingRectWithSize:CGSizeMake(180, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:9.5]} context:nil].size;
            return size1.height+46;
           
        }else
        {
            actiDetailModel* actiModel=[self.bigArray lastObject];
            if (actiModel.dicArray.count>3) {
                return 18;
            }else
            {
                return 0;
            }
            
        }

   
  
}
//计算文本行数
-(NSInteger)textLabelHeight:(NSString*)string
{
    NSString* text=@"我";
    STRING_SIZE(text, 9.5);
     CGSize size1 = [string boundingRectWithSize:CGSizeMake(180, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:9.5]} context:nil].size;
    NSInteger height=size1.height/size.height;
    return height;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.section==0) {
            _cell=[tableView dequeueReusableCellWithIdentifier:@"cell10"];
            if (_cell==nil) {
                _cell=[[[NSBundle mainBundle]loadNibNamed:@"detailIntroduceViewCell" owner:self options:nil]lastObject];
            }
            CAGradientLayer* layer=[CAGradientLayer layer];
            layer.frame=CGRectMake(0,0, _cell.bgLabel.frame.size.width, _cell.bgLabel.frame.size.height);
            layer.colors=[NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor,(id)[UIColor blackColor].CGColor, nil];
            [_cell.bgLabel.layer insertSublayer:layer atIndex:0];
            if (self.bigArray.count!=0) {
                actiDetailModel* actiModel=[self.bigArray lastObject];
                _imageArray=actiModel.actiImg;
                if ([actiModel.isfavorite isEqualToString:@"true"]) {
                    [self.collectionButton setImage:[UIImage imageNamed:@"details@3x-07.png"] forState:UIControlStateNormal];
                }
                _coodinateArray=actiModel.scenic;
                if (_imageArray.count>0) {
                    for (int a=0; a<_imageArray.count; a++) {
                        UIImageView* imageView=[[UIImageView alloc]initWithFrame:CGRectMake(_cell.scrollV.frame.size.width*a, _cell.scrollV.frame.origin.y, _cell.scrollV.frame.size.width, _cell.scrollV.frame.size.height)];
                        NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,[_imageArray objectAtIndex:a]]];
                        [imageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            
                        }];
                        [_cell.scrollV addSubview:imageView];
                        
                    }
                    
                }
                if (_imageArray.count>0)
                {
                    _cell.scrollV.contentSize=CGSizeMake(_cell.frame.size.width*_imageArray.count, 0);
                    _cell.scrollV.delegate=self;
                    _cell.scrollV.tag=10;
                    _cell.scrollV.pagingEnabled=YES;
                }
                NSString* label=actiModel.label;
                NSArray* labelArray=[label componentsSeparatedByString:@";"];
             
                _cell.slideScrollView.showsHorizontalScrollIndicator=NO;
                _cell.slideScrollView.showsVerticalScrollIndicator=NO;
                for (int c=0; c<labelArray.count; c++) {
                    NSString* biaoqian=[labelArray objectAtIndex:c];
                    NSLog(@"%@",biaoqian);
                    UIFont* font=[UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:10];
                    CGSize size=[biaoqian sizeWithAttributes:@{NSFontAttributeName:font}];
                    NSLog(@"%@",NSStringFromCGSize(size));
                    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame=CGRectMake(15+(_buttonWidth+8), 10, size.width+12, 18);
                    button.titleLabel.font=[UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:10];
                    NSString*tip=[labelArray objectAtIndex:c];
                    [button setTitle:tip forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor colorWithRed:26/255.0 green:188/255.0 blue:156/255.0 alpha:1] forState:UIControlStateNormal];
                    button.layer.borderWidth=0.5;
                    button.layer.cornerRadius=3.0;
                    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                    CGColorRef borderColorRef = CGColorCreate(colorSpace,(CGFloat[]){ 0.3, 0.7, 0.5, 0.4 });
                    button.layer.borderColor =borderColorRef;
                    CGColorSpaceRelease(colorSpace);
                    [_cell.slideScrollView addSubview:button];
                    _buttonWidth=button.frame.origin.x+button.frame.size.width;
                    
                }
                   _cell.slideScrollView.contentSize=CGSizeMake(_buttonWidth, 0);
                _cell.biaoTi.text=actiModel.actiTitle;
                int a=[actiModel.actiPrice intValue];
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                NSString *string1 = [formatter stringFromNumber:[NSNumber numberWithInt:a]];
                _cell.jiage.text=[NSString stringWithFormat:@"￥%@",string1];
                _cell.jianjie.text=actiModel.actiDesc;
                NSString* accurateTag=actiModel.accurateTag;
                NSArray* tagArray=[accurateTag componentsSeparatedByString:@";"];
                _cell.daysLabel.text=[tagArray objectAtIndex:0];
                _cell.peopleLabel.text=[tagArray objectAtIndex:1];
                _cell.trafficLabel.text=[tagArray objectAtIndex:2];
                _cell.languageLabel.text=[tagArray objectAtIndex:3];
                if (_cell.jianjie.text.length!=0) {
                    [self resetContent:_cell.jianjie];
                }

            }
            
            
            return _cell;
        }else if(indexPath.section==1)
        {
            _bcell=[tableView dequeueReusableCellWithIdentifier:@"cell11"];
            if (_bcell==nil) {
                _bcell=[[[NSBundle mainBundle]loadNibNamed:@"detailMapViewCell" owner:self options:nil]lastObject];
                
            }
            
            if (_a==0) {
                _mapView=[[MKMapView alloc]initWithFrame:_bcell.mapview.frame];
                _mapView.delegate=self;
                _mapView.mapType=MKMapTypeStandard;
                _mapView.userTrackingMode=MKUserTrackingModeFollow;
                [_bcell.mapview addSubview:_mapView];
                _a++;
            }
            [self startAnnotation];

            return _bcell;
        }
        else if(indexPath.section==2)
        {
            _ecell=[tableView dequeueReusableCellWithIdentifier:@"cell14"];
            if (_ecell==nil) {
                _ecell=[[[NSBundle mainBundle]loadNibNamed:@"detailCostnotesViewCell" owner:self options:nil]lastObject];
            }
            if (self.bigArray.count!=0) {
                actiDetailModel* actiModel=[self.bigArray lastObject];
                _ecell.detailPriceLabel.text=actiModel.costNotes;
                [self resetContent:_ecell.detailPriceLabel];
        //NSLog(@"%@",actiModel.costNotes);
               
                
            }
            
            return _ecell;
        }else if (indexPath.section==3)
        {
            detailButtonViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"HomeViewC2Cell"];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"detailButtonViewCell" owner:self options:nil]lastObject];
            }
            [cell.strechButton addTarget: self action:@selector(clipButtonClick:) forControlEvents:UIControlEventTouchUpInside];
          
            
            return cell;

        }
        else if (indexPath.section==4)
        {
            _cell1=[tableView dequeueReusableCellWithIdentifier:@"cell12"];
            if (_cell1==nil) {
                _cell1=[[[NSBundle mainBundle]loadNibNamed:@"detailDayViewCell" owner:self options:nil]lastObject];
            }
            if (indexPath.row==0) {
                _cell1.huodongLabel.alpha=1;
            }else{
                _cell1.huodongLabel.alpha=0;
            }
            
            if (self.dayArray.count!=0) {
                NSDictionary* dic=[self.dayArray objectAtIndex:indexPath.row];
                NSString* desc=[dic objectForKey:@"secnicDesc"];
                _array1=[dic objectForKey:@"secnicImg"];
                _cell1.jieshao.text=desc;
               
                [self resetContent:_cell1.jieshao];
                if (_array1.count>0)
                {
                    for (int a=0; a<_array1.count; a++)
                    {
                        UIImageView* imageView=[[UIImageView alloc]initWithFrame:CGRectMake(_cell1.scrollView.frame.size.width*a, 0, _cell1.scrollView.frame.size.width, _cell1.scrollView.frame.size.height)];
                        NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,[_array1 objectAtIndex:a]]];
                        [imageView sd_setImageWithURL:url];
                        [_cell1.scrollView addSubview:imageView];
                     }
                    
                 }
                if (_array1.count!=0)
                {
                    _cell1.scrollView.delegate=self;
                    _cell1.scrollView.contentSize=CGSizeMake(_cell1.scrollView.frame.size.width*_array1.count, 0);
                    _cell1.scrollView.tag=11+indexPath.row;
                    _cell1.scrollView.bounces=NO;
                    _cell1.scrollView.pagingEnabled=YES;
                    
                 }

            }
            
            
            return _cell1;
            
        }else if (indexPath.section==5)
        {
            detailButtonViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"HomeViewC2Cell"];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"detailButtonViewCell" owner:self options:nil]lastObject];
            }
            [cell.strechButton addTarget: self action:@selector(clipButtonClick1:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
         

            return cell;
            
        }
        else if (indexPath.section==6)
        {
            
            _fcell=[tableView dequeueReusableCellWithIdentifier:@"cell15"];
            if (_fcell==nil) {
                _fcell=[[[NSBundle mainBundle]loadNibNamed:@"detailPromptViewCell" owner:self options:nil]lastObject];
            }
            if (self.bigArray.count!=0)
            {
                actiDetailModel* actiModel=[self.bigArray lastObject];
                _fcell.tip1Label.text=actiModel.prompt;
                [self resetContent:_fcell.tip1Label];
                _fcell.reViewTextField.delegate=self;
                
            }
            return _fcell;
        }else if (indexPath.section==7)
        {
            detailButtonViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"HomeViewC2Cell"];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"detailButtonViewCell" owner:self options:nil]lastObject];
            }
            [cell.strechButton addTarget: self action:@selector(clipButtonClick2:) forControlEvents:UIControlEventTouchUpInside];
            

            return cell;

        }
        else if (indexPath.section==8)
        {
            _dcell=[tableView dequeueReusableCellWithIdentifier:@"cell13"];
            if ( _dcell==nil)
            {
                _dcell=[[[NSBundle mainBundle]loadNibNamed:@"detailCommentViewCell" owner:self options:nil]lastObject];
            }
            if (self.bigArray.count!=0)
            {
                actiDetailModel* actiModel=[self.bigArray lastObject];
                if (actiModel.dicArray.count!=0)
                {
                    NSDictionary* dic=[actiModel.dicArray objectAtIndex:indexPath.row];
                    NSString* dissContent=[dic objectForKey:@"dissContent"];
                    NSString* dissDate=[dic objectForKey:@"dissDate"];
                    NSString* userName =[dic objectForKey:@"userName"];
                    dissDate=[self intervalSinceNow:dissDate];
                    if ([dissDate isEqualToString:@"0分钟前"])
                    {
                        dissDate=@"刚刚";
                    }
                    NSString* imageUrl=[dic objectForKey:@"userImg"];
                    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,imageUrl]];
                    NSString* nickName=[dic objectForKey:@"nickName"];
                    if (imageUrl.length!=0) {
                       [_dcell.headImageView sd_setImageWithURL:url];
                        _dcell.headImageView.layer.masksToBounds=YES;
                        _dcell.headImageView.layer.cornerRadius=16;
                    }else
                    {
                        
                    }
                    if (nickName.length!=0) {
                        _dcell.nameLabe.text=nickName;
                        _dcell.timeLabel.text=dissDate;
                        _dcell.reViewLabel.text=dissContent;
                    }else
                    {
                        _dcell.nameLabe.text=userName;
                        _dcell.timeLabel.text=dissDate;
                        _dcell.reViewLabel.text=dissContent;

                    }
                    
                }
               

            }
            
            return  _dcell;
            
        }else
        {
            detailButtonViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"HomeViewC2Cell"];
            if (cell==nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"detailButtonViewCell" owner:self options:nil]lastObject];
            }
            [cell.strechButton addTarget: self action:@selector(clipButtonClick3:) forControlEvents:UIControlEventTouchUpInside];
          

            return cell;

        }
    
    



}
//点击区展开收缩
-(void)clipButtonClick:(UIButton*)button
{
    isStrech=!isStrech;
    if (istow==NO) {
        button.transform = CGAffineTransformMakeRotation(M_PI);
    }else
    {
        button.transform=CGAffineTransformMakeRotation(2*M_PI);
        
    }
    istow=!istow;
    [self.tableView reloadData];
    
}
-(void)clipButtonClick1:(UIButton*)button
{
    isOneRow=!isOneRow;
    isbigCell=!isbigCell;
    
    if (isthree==NO) {
       button.transform = CGAffineTransformMakeRotation(M_PI);
    }else
    {
        button.transform=CGAffineTransformMakeRotation(2*M_PI);
        
    }
    isthree=!isthree;
    [self.tableView reloadData];
}
-(void)clipButtonClick2:(UIButton*)button
{
    
    isScroll=!isScroll;
    if (isfour==NO) {
        button.transform = CGAffineTransformMakeRotation(M_PI);
    }else
    {
        button.transform=CGAffineTransformMakeRotation(2*M_PI);
        
    }
    isfour=!isfour;
    [self.tableView reloadData];
}
-(void)clipButtonClick3:(UIButton*)button
{
    isOneDiss=!isOneDiss;
    if (isfive==NO) {
        button.transform = CGAffineTransformMakeRotation(M_PI);
    }else
    {
        button.transform=CGAffineTransformMakeRotation(2*M_PI);
        
    }
    isfive=!isfive;
    [self.tableView reloadData];
}
//行间距设置
-(void)resetContent:(UILabel*)label;
{
    NSMutableAttributedString* attributedString=[[NSMutableAttributedString alloc]initWithString:label.text];
    NSMutableParagraphStyle* paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    paragraphStyle.alignment=NSTextAlignmentLeft;
    paragraphStyle.maximumLineHeight=60; //最大的行高
    paragraphStyle.lineSpacing=8.5;//行自定义行高
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, label.text.length)];
    label.attributedText = attributedString;
    [label sizeToFit];
}
//开始编辑判断是否登录
 - (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //NSLog(@"%@",textField.text);
    NSUserDefaults* userDefaults=[[NSUserDefaults alloc]init];
    NSString* useId=[userDefaults objectForKey:@"loginUserId"];
    if (useId.length==0) {
        UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController* riliVC=[SB instantiateViewControllerWithIdentifier:@"LoginView"];
        [textField resignFirstResponder];
        [self.navigationController pushViewController:riliVC animated:YES];
        
    }else
    {
        if (isediting==NO) {
            [self performSelector:@selector(setTextField) withObject:nil afterDelay:0.2];
            isediting=YES;
        }
        

    }
   
}
//当键盘退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    _textField.alpha=0;
    if (isScroll==NO) {
        _fcell.reViewTextField.alpha=1;
    }else{
        
    }
    _Bglabel.alpha=0;
    isediting=NO;
}
-(void)setTextField
{
    _fcell.reViewTextField.alpha=0;
    
    _textField=[[UITextField alloc]initWithFrame:CGRectMake(22, self.view.frame.size.height-_keyHeight-30, 276, 30)];
    _textField.delegate=self;
    _textField.returnKeyType=UIReturnKeySend;
    _textField.borderStyle=UITextBorderStyleRoundedRect;
    _Bglabel=[[UILabel alloc]init];
    _Bglabel.frame=CGRectMake(0, self.view.frame.size.height-_keyHeight-34, self.view.frame.size.width, 38);
     _Bglabel.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:_Bglabel];
    [self.view addSubview:_textField];
    [_textField becomeFirstResponder];
    
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    _keyHeight=height;
    
    
}
//发送评论
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        if ([textField.text isEqualToString:@""]) {
            ALERTVIEW(@"评论为空");
            [textField resignFirstResponder];
            
        }else
        {
            [textField resignFirstResponder];
            NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
            NSString* loginUserId=[userDefaults objectForKey:@"loginUserId"];
            actiDetailModel* actiModel=[self.bigArray lastObject];
            NSString* actiId=actiModel.actiId;
            NSString* level=actiModel.actiLevel;
            NSString* context=textField.text;
            UserViewModel* userModel=[[UserViewModel alloc]init];
            [userModel adddiscum:loginUserId withActiId:actiId withLevel:level withcontext:context];
            [GiFHUD setGifWithImageName:@"loading.gif"];
            [GiFHUD show];
            [userModel setBlockWithReturnBlock:^(id returnValue) {
                if ([returnValue isEqualToString:@"true"]) {
                    textField.text=@"";
                    [GiFHUD dismiss];
                }
            } WithErrorBlock:^(id errorCode) {
                
            } WithFailureBlock:^{
                
            }];
           
            [self connect];
        }

    }
    
    return YES;
}
-(void)bottomButtonClick:(UIButton*)button
{
    _ecell.detailPriceLabel.alpha=0;
    button.alpha=0;
    isStrech=NO;
    [self.tableView reloadData];
    
}
-(void)addButtonCLick:(UIButton*)button
{
    NSUserDefaults* userDefaults=[[NSUserDefaults alloc]init];
    NSString* useId=[userDefaults objectForKey:@"loginUserId"];
    if (useId.length==0) {
        UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController* riliVC=[SB instantiateViewControllerWithIdentifier:@"LoginView"];
        [self.navigationController pushViewController:riliVC animated:YES];
    }else
    {
        _commentsView=[[UIView alloc]initWithFrame:self.view.frame];
        _commentsView.backgroundColor=[UIColor grayColor];
        _commentsView.alpha=0.7;
        [self.view addSubview:_commentsView];
        _textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 200,self.view.frame.size.width, 120)];
        _textView.delegate=self;
        _textView.tag=1;
        _textView.font=[UIFont systemFontOfSize:15];
        _textView.returnKeyType=UIReturnKeyDone;
        [_commentsView addSubview:_textView];
        [_textView becomeFirstResponder];
    }
    
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
  
    if (textView.tag==1) {
        if ([text isEqualToString:@"\n"]) {
            if ([_textView.text isEqualToString:@""]) {
                ALERTVIEW(@"评论为空");
                [textView resignFirstResponder];
                [_commentsView removeFromSuperview];
            }else
            {
                [textView resignFirstResponder];
                _textView.hidden=YES;
                NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
                NSString* loginUserId=[userDefaults objectForKey:@"loginUserId"];
                actiDetailModel* actiModel=[self.bigArray lastObject];
                NSString* actiId=actiModel.actiId;
              //  NSLog(@"-=-=%@",actiModel.actiId);
                NSString* level=actiModel.actiLevel;
                NSString* context=_textView.text;
                UserViewModel* userModel=[[UserViewModel alloc]init];
                [userModel adddiscum:loginUserId withActiId:actiId withLevel:level withcontext:context];
                [_commentsView removeFromSuperview];
                [self connect];
                
            }
            
            
            return NO;
        }

        
    }else
    {
        if ([text isEqualToString:@"\n"]) {
            if ([_textView1.text isEqualToString:@""]) {
                ALERTVIEW(@"提问为空");
                [_textView1 resignFirstResponder];
                [_qusetionView removeFromSuperview];
            }else
            {
                [textView resignFirstResponder];
                NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
                NSString* loginUserId=[userDefaults objectForKey:@"loginUserId"];
                actiDetailModel* actiModel=[self.bigArray lastObject];
                NSString* ActiId=actiModel.actiId;
                NSString* programContent=_textView1.text;
                UserViewModel* userModel=[[UserViewModel alloc]init];
                [userModel addProblem:loginUserId withprogramContent:programContent withActiId:ActiId];
                [_qusetionView removeFromSuperview];
                [self connect];
            }
            
            
            return NO;
        }

    }
    
    return YES;
}
-(void)questionButtonClick:(UIButton*)button
{
    NSUserDefaults* userDefaults=[[NSUserDefaults alloc]init];
    NSString* useId=[userDefaults objectForKey:@"loginUserId"];
    if (useId.length==0) {
        UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController* riliVC=[SB instantiateViewControllerWithIdentifier:@"LoginView"];
        [self.navigationController pushViewController:riliVC animated:YES];
    }else
    {
        _qusetionView=[[UIView alloc]initWithFrame:self.view.frame];
        _qusetionView.backgroundColor=[UIColor grayColor];
        _qusetionView.alpha=0.7;
        [self.view addSubview:_qusetionView];
        _textView1=[[UITextView alloc]initWithFrame:CGRectMake(0, 200,self.view.frame.size.width, 120)];
        _textView1.delegate=self;
        _textView1.tag=2;
        _textView1.font=[UIFont systemFontOfSize:15];
        _textView1.returnKeyType=UIReturnKeyDone;
        [_qusetionView addSubview:_textView1];
        [_textView1 becomeFirstResponder];
    }
   

    
}

-(void)pageControlValueChanged:(UIPageControl*)pagecontroll
{
    
    if (pagecontroll.tag==20) {
        UIScrollView* s=(UIScrollView*)[_cell viewWithTag:10];
        [s setContentOffset:CGPointMake(_cell.frame.size.width*pagecontroll.currentPage, 0) animated:YES];
    }else if (pagecontroll.tag==21)
    {
       // NSLog(@"11");
        
        UIScrollView* s=(UIScrollView*)[_cell1 viewWithTag:11];
        [s setContentOffset:CGPointMake(_cell1.frame.size.width*pagecontroll.currentPage, 0) animated:YES];
        
    }else if (pagecontroll.tag==22)
    {
        UIScrollView* s=(UIScrollView*)[_cell1 viewWithTag:12];
        [s setContentOffset:CGPointMake(_cell1.frame.size.width*pagecontroll.currentPage, 0) animated:YES];
    }else if (pagecontroll.tag==23)
    {
        UIScrollView* s=(UIScrollView*)[_cell1 viewWithTag:13];
        [s setContentOffset:CGPointMake(_cell1.frame.size.width*pagecontroll.currentPage, 0) animated:YES];
    }
   
}
//滑动表隐藏导航
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tableView==scrollView) {
        if (scrollView.contentOffset.y<=0) {
            self.collectionButton.alpha=1;
            self.backButton.alpha=1;

        }else
        {
            if (scrollView.contentOffset.y-_lastOffset.origin.y>0)
            {
                self.collectionButton.alpha=0;
                self.backButton.alpha=0;
        
            }else
            {
                self.collectionButton.alpha=0;
                self.backButton.alpha=1;
    
                
            }
            
        }
        _lastOffset.origin.y=scrollView.contentOffset.y;
        [_textField resignFirstResponder];

    }
  
}


-(void)bigmapButtonClick
{
    bigMapViewController* bigMapVc=[[bigMapViewController alloc]init];
    bigMapVc.array=_coodinateArray;
    [self.navigationController pushViewController:bigMapVc animated:YES];
    
//    UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    calendarViewController* detailVC=[SB instantiateViewControllerWithIdentifier:@"calendervc"];
////    destinationModel* destinModel=[self.array objectAtIndex:indexPath.row];
////    detailVC.actiId=destinModel.actiId;
//    
//    [self.navigationController pushViewController:detailVC animated:YES];

}
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
////    // 取出用户当前的经纬度
////    CLLocationCoordinate2D center = userLocation.location.coordinate;
////    
////    // 设置地图的中心点（以用户所在的位置为中心点）
////    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
////    
////    // 设置地图的显示范围
////    MKCoordinateSpan span = MKCoordinateSpanMake(0.5,0.5);
////    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
////    [mapView setRegion:region animated:YES];
//}

-(void)startAnnotation
{
    
    actiDetailModel* actiModel=[self.bigArray lastObject];
    for (int y=0; y<actiModel.scenic.count; y++) {
        MKtripAnnotation *anno0 = [[MKtripAnnotation alloc] init];
        NSDictionary* dic=actiModel.scenic[y];
        double latitude=[[dic objectForKey:@"latitude"] doubleValue];
        double longitude=[[dic objectForKey:@"longitude"] doubleValue];
        NSString* title=[dic objectForKey:@"dayTitle"];
        // NSString* day=[dic objectForKey:@"dayNo"];
        anno0.coordinate =CLLocationCoordinate2DMake(longitude, latitude);
        anno0.icon=@"icon@3x.png";
        anno0.title = title;
        anno0.subtitle = @"";
        [self.mapView addAnnotation:anno0];
    }
    MKtripAnnotation *anno0 = [[MKtripAnnotation alloc] init];
     NSDictionary* dic=actiModel.scenic[0];
    double latitude=[[dic objectForKey:@"latitude"] doubleValue];
    double longitude=[[dic objectForKey:@"longitude"] doubleValue];
    anno0.coordinate =CLLocationCoordinate2DMake(longitude, latitude);
    CLLocationCoordinate2D center= anno0.coordinate;
    [_mapView setCenterCoordinate:anno0.coordinate animated:YES];
    MKCoordinateSpan span = MKCoordinateSpanMake(1,1);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [_mapView setRegion:region animated:YES];
    
}
#pragma marks ******************MKMapViewDelegate**********************
-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (![annotation isKindOfClass:[MKtripAnnotation class]]) return nil;
    
    static NSString *ID = @"tuangou";
    // 从缓存池中取出可以循环利用的大头针view
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
        // 显示子标题和标题
        annoView.canShowCallout = YES;
        // 设置大头针描述的偏移量
        annoView.calloutOffset = CGPointMake(0, -10);
        // 设置大头针描述右边的控件
//        annoView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
//        // 设置大头针描述左边的控件
//        annoView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        // [annoView addSubview:[UIButton buttonWithType:UIButtonTypeCustom]];
        
    }
    
    // 传递模型
    annoView.annotation = annotation;
    
    // 设置图片
    MKtripAnnotation *tripAnnotation = annotation;
    annoView.image = [UIImage imageNamed:tripAnnotation.icon];
    return annoView;
    
}

- (IBAction)buttonClick:(id)sender
{
    [GiFHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)collectionButtonClick:(id)sender
{
    
    NSUserDefaults *userDefaults=[[NSUserDefaults alloc]init];
    NSString* userID=[userDefaults objectForKey:@"loginUserId"];
   // NSLog(@"=-=%@",userID);
    if (userID.length==0) {
        UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController* detailVC=[SB instantiateViewControllerWithIdentifier:@"LoginView"];
        [self.navigationController pushViewController:detailVC animated:YES];

    }else
    {
        actiDetailModel* actiModel=[self.bigArray lastObject];
        UserViewModel* viewModel=[[UserViewModel alloc]init];
        if ([actiModel.isfavorite isEqualToString:@"true"]) {
            ALERTVIEW(@"亲，你收藏过了哦");
        }else
        {
            if (isCollect==NO)
            {
                [viewModel addCollect:userID withactiId:actiModel.actiId];
                [viewModel setBlockWithReturnBlock:^(id returnValue) {
                    _msg=returnValue;
                    if ([_msg isEqualToString:@"add success"]) {
                        [self.collectionButton setImage:[UIImage imageNamed:@"details@3x-07.png"] forState:UIControlStateNormal];
                    }
                } WithErrorBlock:^(id errorCode) {
                    
                } WithFailureBlock:^{
                    
                }];
                isCollect=YES;
            }else
            {
                ALERTVIEW(@"亲，你收藏过了哦");
            }
            
        }
        
  
        
    }
    
}
//计算指定时间与当前时间的时间差
-(NSString*)intervalSinceNow:(NSString*)theDate
{
    
    NSDateFormatter* date=[[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate*d=[date dateFromString:theDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat=[NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString* timeString=@"";
    NSTimeInterval cha=now-late;
    if (cha/3600<1) {
        timeString=[NSString stringWithFormat:@"%f",cha/60];
        timeString=[timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟前",timeString];
    }
    if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    if (cha/2592000>1) {
        timeString = [NSString stringWithFormat:@"%f", cha/2592000];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@月前", timeString];
    }
    return timeString;
    
}
- (IBAction)callButton:(id)sender
{
    // CalendarShowTypeMultiple 显示多月
    // CalendarShowTypeSingle   显示单月
    //RMCalendarController *c = [RMCalendarController calendarWithDays:365 showType:CalendarShowTypeMultiple];
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    NSString* loginUserId=[userDefaults objectForKey:@"loginUserId"];
    if (loginUserId.length==0) {
        UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        middleViewController* middleVc=[SB instantiateViewControllerWithIdentifier:@"middleViewController"];
        [self.navigationController pushViewController:middleVc animated:YES];
    }else
    {
        if (self.timeArray.count!=0) {
            actiDetailModel* actiModel=[self.bigArray lastObject];
            UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            RMCalendarController* RMCalendarVC=[SB instantiateViewControllerWithIdentifier:@"RMCalendarController"];
            RMCalendarVC.days=365;
            RMCalendarVC.type=CalendarShowTypeMultiple;
            // 此处用到MJ大神开发的框架，根据自己需求调整是否需要
            NSMutableArray* array1=[[NSMutableArray alloc]initWithCapacity:0];
            for (timeViewModel* timeModel in self.timeArray) {
                if (timeModel.stock!=0) {
                    NSArray* array=[timeModel.date componentsSeparatedByString:@"-"];
                    NSMutableDictionary* dic=[[NSMutableDictionary alloc]init];
                    [dic setObject:[array objectAtIndex:0]forKey:@"year"];
                    [dic setObject:[array objectAtIndex:1]forKey:@"month"];
                    [dic setObject:[array objectAtIndex:2]forKey:@"day"];
                    [dic setObject:@"1" forKey:@"ticketCount"];
                    [dic setObject:timeModel.prices forKey:@"ticketPrice"];
                    [array1 addObject:dic];
                    
                }
            }
            
            RMCalendarVC.modelArr=[TicketModel objectArrayWithKeyValuesArray:array1] ;
            // 是否展现农历
            // c.isDisplayChineseCalendar = YES;
            // YES 没有价格的日期可点击
            // NO  没有价格的日期不可点击
            RMCalendarVC.isEnable = NO;
            __weak RMCalendarController* weakSelf=RMCalendarVC;
            RMCalendarVC.calendarBlock = ^(RMCalendarModel *model) {
                if (model.ticketModel.ticketCount) {
                   // NSLog(@"%lu-%lu-%lu-票价%.1f",(unsigned long)model.year,(unsigned long)model.month,(unsigned long)model.day, model.ticketModel.ticketPrice);
                    weakSelf.year=[NSString stringWithFormat:@"%lu",model.year];
                    weakSelf.month=[NSString stringWithFormat:@"%lu",model.month];
                    weakSelf.day=[NSString stringWithFormat:@"%lu",model.day];
                    weakSelf.ticketPrice=[NSString stringWithFormat:@"%f",model.ticketModel.ticketPrice];
                    weakSelf.actiName=actiModel.actiTitle;
                } else {
                    //NSLog(@"%lu-%lu-%lu",(unsigned long)model.year,(unsigned long)model.month,(unsigned long)model.day);
                }
                
            };
            weakSelf.actiId=actiModel.actiId;
            [self.navigationController pushViewController:RMCalendarVC animated:YES];

        }
       
    }
   
}

#pragma mark - Actions

- (IBAction)clickAddToShoppingCart:(id)sender {
    // TODO: 加入购物车
}


-(void)dealloc
{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
    _mapView.delegate=nil;
    self.tableView.dataSource=nil;
    self.tableView.delegate=nil;
}
@end
