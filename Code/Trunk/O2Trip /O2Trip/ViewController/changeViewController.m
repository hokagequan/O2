//
//  changeViewController.m
//  O2Trip
//
//  Created by tao on 15/5/14.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "changeViewController.h"
#import "collectionViewController.h"
#import "mudidiCell.h"
#import "huodongCell.h"
#import "activityDetailViewController.h"
#import "detailactivityViewController.h"
#import "mapViewController.h"
#import "UserViewModel.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"
#import "actiDetailModel.h"
#import "GiFHUD.h"
#import "SVPullToRefresh.h"
#import "NetRequestClass.h"
#import "Reachability.h"
#import "LoginViewController.h"
#define ALERTVIEW(STRING) UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:STRING delegate:self cancelButtonTitle:nil  otherButtonTitles:@"确定", nil];\
[alertView show];
@interface changeViewController (private)

-(void)reachabilityChanged:(NSNotification*)note;

@end
@implementation changeViewController
{
    NSMutableArray *dict2;
    NSMutableArray *dict5;
    NSDictionary *dict7;
    NSMutableArray *arr;
    CLLocationDegrees _Latitude;
    CLLocationDegrees _Longitude;
    Boolean _success;
    huodongCell* _cell;
    UILabel* _dressLabel;
    UIImageView* _bgImage;
    UIImageView* _bg;
}
-(CLLocationManager*)locationManager
{
    if (!_locationManager) {
        self.locationManager=[[CLLocationManager alloc]init];
        self.locationManager.delegate=self;
    }
    return _locationManager;
    
}

- (IBAction)mapButtonClick:(id)sender
{
    UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    mapViewController* mapVC=[SB instantiateViewControllerWithIdentifier:@"mapViewController"];
    [self.navigationController pushViewController:mapVC animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
  
   
}
-(void)textHeight
{
    UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    label.backgroundColor=[UIColor redColor];
    [self.view addSubview:label];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
     a=0;
    _dressLabel=[[UILabel alloc]init];
    _bgImage=[[UIImageView alloc]init];
    _bgImage.image=[UIImage imageNamed:@"@3x_home-08.png"];
    [self.view addSubview:_bgImage];
    _bg=[[UIImageView alloc]init];
    _bg.image=[UIImage imageNamed:@"@3x_home-01.png"];
    [self.view addSubview:_bg];
    [self.view addSubview:_dressLabel];
    
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.apple.com"];
    
    // start the notifier which will cause the reachability object to retain itself!
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(showAlertView) withObject:nil afterDelay:0.2];
            
            
        });
    };
    
    [reach startNotifier];
    [GiFHUD setGifWithImageName:@"loading.gif"];
    [GiFHUD show];
     _tableView.delegate=self;
     _tableView.dataSource=self;
    [self getRequest];
    self.navigationController.navigationBarHidden=YES;
    self.navigationController.automaticallyAdjustsScrollViewInsets=NO;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0)
    {
        //设置定位权限 仅ios8有意义
        [self.locationManager requestWhenInUseAuthorization];// 前台定位
        
        //  [locationManager requestAlwaysAuthorization];// 前后台同时定位
    }
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.locationManager startUpdatingLocation];
    self.geoCoder = [[CLGeocoder alloc] init];
    __weak changeViewController * weakVC = self;
    [weakVC.tableView addPullToRefreshWithActionHandler:^{
        NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
        NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
        NSString* useId=[userDefaults objectForKey:@"loginUserId"];
        [paramjsonV appendFormat:@"{"];
        [paramjsonV appendFormat:@"\"longitude\":\"%f\",",_Latitude];
        [paramjsonV appendFormat:@"\"latitude\":\"%f\",",_Longitude];
        [paramjsonV appendFormat:@"\"userId\":\"%@\"",useId];
        [paramjsonV appendFormat:@"}"];
        
        NSDictionary *parameter = @{PARAMJSON:paramjsonV};
        
        NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_acti/indexActi"];
        [NetRequestClass NetRequestGETWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
            NSDictionary *dict1=returnValue;
            [GiFHUD dismiss];
            NSDictionary *dict3=[dict1 objectForKey:@"data"];
            dict2=[dict3 objectForKey:@"destination"];
            dict5=[dict3 objectForKey:@"acti"];
            [_tableView reloadData];
            [_tableView.pullToRefreshView stopAnimating];
            _tableView.showsInfiniteScrolling = YES;
           
           
        } WithErrorCodeBlock:^(id errorCode) {
            DDLog(@"=-=-=-=%@", errorCode);
            //[self errorCodeWithDic:errorCode];
            
        } WithFailureBlock:^{
            // [self netFailure];
            DDLog(@"========================%@",url);
            DDLog(@"网络异常");
            
        }];

    }];
    [_tableView.pullToRefreshView setTitle:@"下拉刷新" forState:SVPullToRefreshStateStopped];
    
}
-(void)showjuhua
{
   [GiFHUD dismiss];
}
-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
       
    }
    else
    {
       
    }
}
-(void)showAlertView
{
    
    ALERTVIEW(@"网络不可用");
}
-(void)getRequest
{
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    NSString* useId=[userDefaults objectForKey:@"loginUserId"];
    NSMutableString *paramjsonV=[NSMutableString stringWithCapacity:50];
    [paramjsonV appendFormat:@"{"];
    [paramjsonV appendFormat:@"\"longitude\":\"%f\",",_Latitude];
    [paramjsonV appendFormat:@"\"latitude\":\"%f\",",_Longitude];
    [paramjsonV appendFormat:@"\"userId\":\"%@\"",useId];
    [paramjsonV appendFormat:@"}"];
    NSDictionary *parameter = @{PARAMJSON:paramjsonV};
    NSString *url=[NSString stringWithFormat:@"%@%@",REQUESTURL,@"rest_acti/indexActi"];
    [NetRequestClass NetRequestGETWithRequestURL:url WithParameter:parameter WithReturnValeuBlock:^(id returnValue) {
        NSDictionary *dict1=returnValue;
        NSDictionary *dict3=[dict1 objectForKey:@"data"];
        dict2=[dict3 objectForKey:@"destination"];
        dict5=[dict3 objectForKey:@"acti"];
        [GiFHUD dismiss];
        [_tableView reloadData];
        
    } WithErrorCodeBlock:^(id errorCode) {
        DDLog(@"=-=-=-=%@", errorCode);
    } WithFailureBlock:^{
    }];

}
#pragma mark - CoreLocation 代理
#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）
//此方法会调用多次 来进行更为精准的定位
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    // NSLog(@"1111");
    CLLocation* location = [locations lastObject];
    CLLocationDegrees latitude= location.coordinate.latitude  ;
    CLLocationDegrees longitude=location.coordinate.longitude;
    _Latitude=latitude;
    _Longitude=longitude;
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    [self.geoCoder reverseGeocodeLocation:location1 completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *place = [placemarks lastObject];
        ;
        if (place.country!=nil&&place.thoroughfare!=nil) {
           
                _dressLabel.font=[UIFont systemFontOfSize:10];
                _dressLabel.textColor=[UIColor whiteColor];
                CGSize size = [place.administrativeArea sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]}];
                _size=size;
                _dressLabel.frame=CGRectMake(16, 49, size.width, size.height);
                _bgImage.frame=CGRectMake(0, 31, 20+size.width, 50);
                _dressLabel.text =[NSString stringWithFormat:@"%@",place.administrativeArea];
                _bg.frame=CGRectMake(5, 51, 12, 12);
        }
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return dict2.count;
        
    }else{
        return dict5.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        mudidiCell* cell=[tableView dequeueReusableCellWithIdentifier:@"mudidiCell"];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"mudidiCell" owner:self options:nil]objectAtIndex:0];
        }
        cell.cityName.text=[dict2[indexPath.row] objectForKey:@"destiName"];
        
        cell.cityName.font=[UIFont fontWithName:@"FZLTXHJW" size:13];
        cell.number_hd.text=[dict2[indexPath.row] objectForKey:@"actiNum"];
        cell.number_hd.text=[NSString stringWithFormat:@"热门目的地"];
         NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,[dict2[indexPath.row] objectForKey:@"destiImg"]]];
        [cell.bj_image sd_setImageWithURL:url];
        return cell;
    }else
    {
        _cell=[tableView dequeueReusableCellWithIdentifier:@"huodongCell"];
        if (_cell==nil) {
            _cell=[[[NSBundle mainBundle]loadNibNamed:@"huodongCell" owner:self options:nil]objectAtIndex:1];
        }
        int i=(int)indexPath.row;
        dict7=dict5[i];
        arr=[dict7 objectForKey:@"actiImage"];
        if (arr.count>0) {
            NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,[arr lastObject]]];
            [_cell.bj_name_xq sd_setImageWithURL:url];
           
        }
        CAGradientLayer* layer=[CAGradientLayer layer];
        layer.frame=CGRectMake(0,0, _cell.bgLabel.frame.size.width, _cell.bgLabel.frame.size.height);
        layer.colors=[NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor,(id)[UIColor blackColor].CGColor, nil];
        [_cell.bgLabel.layer insertSublayer:layer atIndex:0];
        _cell.tuBuType.text=[dict5[i] objectForKey:@"tripDistance"];
        NSString* type=[dict5[i]objectForKey:@"actiType"];
        _cell.tuBuType.text=[NSString stringWithFormat:@"%@,%@KM",type,_cell.tuBuType.text];
        _cell.tBTime.text=[NSString stringWithFormat:@"%@天",[dict5[i] objectForKey:@"days"]];
        _cell.numberT.text=[dict5[i] objectForKey:@"discussNum"];
        int z=[[dict5[i] objectForKey:@"specialPrice"]intValue];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSString *string2 = [formatter stringFromNumber:[NSNumber numberWithInt:z]];
        _cell.Tjia.text=[NSString stringWithFormat:@"￥%@",string2];
        _cell.dZnumber.text=[dict5[i] objectForKey:@"praiseNum"];
        NSString* string=[dict5[i]objectForKey:@"hasPraise"];
        if ([string isEqualToString:@"true"]) {
            [_cell.zanButton setBackgroundImage:[UIImage imageNamed:@"@3x_home-04.png"] forState:UIControlStateNormal];
            
        }else
        {
            [_cell.zanButton setBackgroundImage:[UIImage imageNamed:@"@3x_home-03.png"] forState:UIControlStateNormal];
        }
        _cell.nameHD.text=[dict5[i] objectForKey:@"actiTitle"];
        _cell.zanButton.tag=indexPath.row;
        [_cell.zanButton addTarget:self action:@selector(zanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        return _cell;
    }

    
}
-(void)zanButtonClick:(UIButton*)button
{
    NSString* actiId=[[dict5 objectAtIndex:button.tag]objectForKey:@"actiId"];
    UserViewModel* userModel=[[UserViewModel alloc]init];
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSString* useId=[userDefaults objectForKey:@"loginUserId"];
    if (useId.length!=0) {
        [userModel clippraise:useId withactiId:actiId];
        [userModel setBlockWithReturnBlock:^(id returnValue) {
            NSIndexPath* indexpath=[NSIndexPath indexPathForItem:button.tag inSection:1];
            huodongCell* cell=(huodongCell*)[self.tableView  cellForRowAtIndexPath:indexpath];
            NSString* num=[dict5[button.tag] objectForKey:@"praiseNum"] ;
            NSString* string=[dict5[button.tag]objectForKey:@"hasPraise"];
            if (flag[button.tag]==NO) {
                if ([string isEqualToString:@"true"]) {
                    NSInteger y=[num intValue]-1;
                    cell.dZnumber.text=[NSString stringWithFormat:@"%ld",y];
                    flag[button.tag]=YES;
                    [cell.zanButton setBackgroundImage:[UIImage imageNamed:@"@3x_home-03.png"] forState:UIControlStateNormal];
                }else
                {
                    NSInteger y=[num intValue]+1;
                    cell.dZnumber.text=[NSString stringWithFormat:@"%ld",y];
                    flag[button.tag]=YES;
                    [cell.zanButton setBackgroundImage:[UIImage imageNamed:@"@3x_home-04.png"] forState:UIControlStateNormal];
                }
               
            }else
            {
                if ([string isEqualToString:@"true"]) {
                    cell.dZnumber.text=num;
                    [cell.zanButton setBackgroundImage:[UIImage imageNamed:@"@3x_home-04.png"] forState:UIControlStateNormal];
                    flag[button.tag]=NO;

                }else
                {
                    cell.dZnumber.text=num;
                    [cell.zanButton setBackgroundImage:[UIImage imageNamed:@"@3x_home-03.png"] forState:UIControlStateNormal];
                    flag[button.tag]=NO;
                }
            }
        } WithErrorBlock:^(id errorCode) {
            
        } WithFailureBlock:^{
            
        }];

    }else
    {
        UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController* riliVC=[SB instantiateViewControllerWithIdentifier:@"LoginView"];
        [self.navigationController pushViewController:riliVC animated:YES];

    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<=0) {
        
        _dressLabel.frame=CGRectMake(16, 49, _size.width, _size.height);
        _bgImage.frame=CGRectMake(0, 31, 20+_size.width, 50);
        _bg.frame=CGRectMake(5, 51, 12, 12);
    }else
    {
        if (scrollView.contentOffset.y-_lastOffset.origin.y>0) {
           _dressLabel.frame=CGRectMake(18, -20, 31, 16);
           _bgImage.frame=CGRectMake(0, -50, 54, 50);
           _bg.frame=CGRectMake(5, -100, 12, 12);
        }else
        {
            _dressLabel.frame=CGRectMake(16, 49, _size.width, _size.height);
            _bgImage.frame=CGRectMake(0, 31, 20+_size.width, 50);
            _bg.frame=CGRectMake(5, 51, 12, 12);
        }

        
    }
      _lastOffset.origin.y=scrollView.contentOffset.y;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 276;
    }else
    {
        return 246;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        UserViewModel* userModel=[[UserViewModel alloc]init];
        NSString* countryId=[dict2[indexPath.row] objectForKey:@"destiId"];
        NSUserDefaults* userdefaults=[NSUserDefaults standardUserDefaults];
        NSString* useId=[userdefaults objectForKey:@"loginUserId"];
        [userModel getdestination:countryId withLatitude:_Latitude withLongtitude:_Longitude withUseId:useId];
        [userModel setBlockWithReturnBlock:^(id returnValue) {
            UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            activityDetailViewController* detailVC=[SB instantiateViewControllerWithIdentifier:@"activityDetailViewController"];
            _name=[dict2[indexPath.row] objectForKey:@"destiName"];
            detailVC.text=_name;
            detailVC.countryId=countryId;
            detailVC.array=returnValue;
            [self.navigationController pushViewController:detailVC animated:YES];
        } WithErrorBlock:^(id errorCode) {
            
        } WithFailureBlock:^{
            
        }];
    }else
    {
        NSString* actiId=[dict5[indexPath.row] objectForKey:@"actiId"];
              UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        detailactivityViewController* detailVC=[SB instantiateViewControllerWithIdentifier:@"detailactivityViewController"];
        detailVC.actiId=actiId;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
    
}
-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
