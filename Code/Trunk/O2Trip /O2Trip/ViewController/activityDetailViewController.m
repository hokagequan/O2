//
//  activityDetailViewController.m
//  O2Trip
//
//  Created by tao on 15/5/13.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "activityDetailViewController.h"
#import "detailactivityViewController.h"
#import "destinationModel.h"
#import "UIImageView+WebCache.h"
#import "UserViewModel.h"
#import "GiFHUD.h"
#import "SVPullToRefresh.h"
#import "LoginViewController.h"
#define ALERTVIEW(STRING) UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:STRING delegate:self cancelButtonTitle:nil  otherButtonTitles:@"确定", nil];\
[alertView show];
@implementation activityDetailViewController
-(CLLocationManager*)locationManager
{
    if (!_locationManager) {
        self.locationManager=[[CLLocationManager alloc]init];
        self.locationManager.delegate=self;
    }
    return _locationManager;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
  
    self.navigationController.navigationBarHidden=YES;
   
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
}
- (IBAction)buttonClick:(id)sender
{
    [GiFHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.titleView.text=self.text;
    if (self.array.count==0) {
        ALERTVIEW(@"未找到该类型");
        
    }
       self.view.backgroundColor=[UIColor whiteColor];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0)
    {
        //设置定位权限 仅ios8有意义
        [self.locationManager requestWhenInUseAuthorization];// 前台定位
        
        //  [locationManager requestAlwaysAuthorization];// 前后台同时定位
    }
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.locationManager startUpdatingLocation];
    self.geoCoder = [[CLGeocoder alloc] init];
    __weak activityDetailViewController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        UserViewModel* viewModel=[[UserViewModel alloc]init];
        if (self.b==1) {
            NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
            NSString* userId=[userDefaults objectForKey:@"loginUserId"];
            [viewModel getdetailActivity:self.text withlatitude:_latitude withLongtitude:_longitude withUseId:userId];
            [viewModel setBlockWithReturnBlock:^(id returnValue) {
                weakSelf.array=returnValue;
              
                [_tableView reloadData];
                [_tableView.pullToRefreshView stopAnimating];
                _tableView.showsInfiniteScrolling = YES;
            } WithErrorBlock:^(id errorCode) {
                
            } WithFailureBlock:^{
                
            }];
        }else if (self.b==2)
        {
            NSUserDefaults* userdefaults=[NSUserDefaults standardUserDefaults];
            NSString* userId=[userdefaults objectForKey:@"loginUserId"];
            [viewModel getDetailDestination:weakSelf.countryId withlatitude:_latitude withLongtitude:_longitude withUseId:userId];
            [viewModel setBlockWithReturnBlock:^(id returnValue) {
                weakSelf.array=returnValue;
                
                [_tableView reloadData];
                [_tableView.pullToRefreshView stopAnimating];
                _tableView.showsInfiniteScrolling = YES;
            } WithErrorBlock:^(id errorCode) {
                
            } WithFailureBlock:^{
                
            }];
            
        }else
        {
            {
                NSUserDefaults* userdefaults=[NSUserDefaults standardUserDefaults];
                NSString* useId=[userdefaults objectForKey:@"loginUserId"];
                [viewModel getdestination: self.countryId withLatitude:_latitude withLongtitude:_longitude withUseId:useId];
                [viewModel setBlockWithReturnBlock:^(id returnValue) {
                    weakSelf.array=returnValue;
                    [_tableView reloadData];
                    [_tableView.pullToRefreshView stopAnimating];
                    _tableView.showsInfiniteScrolling = YES;
                } WithErrorBlock:^(id errorCode) {
                    
                } WithFailureBlock:^{
                    
                }];
                
            }
            

        }

    }];
    
}


#pragma mark - CoreLocation 代理
#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）
//此方法会调用多次 来进行更为精准的定位
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{

    CLLocation* location = [locations lastObject];
    CLLocationDegrees latitude= location.coordinate.latitude  ;
    CLLocationDegrees longitude=location.coordinate.longitude;
    _latitude=latitude;
    _longitude=longitude;
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    [self.geoCoder reverseGeocodeLocation:location1 completionHandler:^(NSArray *placemarks, NSError *error) {
       
        
        CLPlacemark *place = [placemarks lastObject];
        ;
        if (place.thoroughfare!=nil) {
            _dressLabel.text=[NSString stringWithFormat:@"当前位置:%@",place.thoroughfare];
        }
        
    }];
    
}
#pragma marks *********UITableViewDelegate****************
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 246;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell=[tableView dequeueReusableCellWithIdentifier:@"detailcell"];
    if (_cell==nil) {
        _cell=[[[NSBundle mainBundle]loadNibNamed:@"detailCell" owner:self options:nil]lastObject];
    }
    destinationModel* destimodel=[self.array objectAtIndex:indexPath.row];
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,[destimodel.actiImage lastObject]]];
    [_cell.bigImageView sd_setImageWithURL:url];
    CAGradientLayer* layer=[CAGradientLayer layer];
    layer.frame=CGRectMake(0,0, _cell.bgLabel.frame.size.width, _cell.bgLabel.frame.size.height);
    layer.colors=[NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor,(id)[UIColor blackColor].CGColor, nil];
    [_cell.bgLabel.layer insertSublayer:layer atIndex:0];
    //int i=[destimodel.origPrice intValue];
    int j=[destimodel.specialPrice intValue];
   // int z=i-j;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    //NSString *string1 = [formatter stringFromNumber:[NSNumber numberWithInt:i]];
    NSString *string2 = [formatter stringFromNumber:[NSNumber numberWithInt:j]];
    //NSString *string3 = [formatter stringFromNumber:[NSNumber numberWithInt:z]];
    _cell.distanseLabel.text=[NSString stringWithFormat:@"%@%@KM",destimodel.actiType,destimodel.tripDistance];
       _cell.dayLabel.text=[NSString stringWithFormat:@"%@天",destimodel.days];
    _cell.messageLabel.text=[NSString stringWithFormat:@"%@",destimodel.discussNum];
    //int x= [_cell.resouceLabel.text intValue]-[_cell.nowLabel.text intValue];
    _cell.nowLabel.text=[NSString stringWithFormat:@"￥%@",string2];
    _cell.introduceLabel.text=destimodel.actiTitle;
    _cell.zanLabel.tag=indexPath.row;
    NSString* string=destimodel.hasPraise;
    if ([string isEqualToString:@"true"]) {
        [_cell.zanLabel setImage:[UIImage imageNamed:@"@3x_home-04.png"] forState:UIControlStateNormal];
    }

    [_cell.zanLabel addTarget:self action:@selector(zanLabelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _cell.CountsLabel.text=destimodel.praiseNum;
    return _cell;
}
-(void)zanLabelButtonClick:(UIButton*)button
{
    destinationModel* destinModel=[self.array objectAtIndex:button.tag];
    UserViewModel* userModel=[[UserViewModel alloc]init];
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSString* useId=[userDefaults objectForKey:@"loginUserId"];
    if (useId.length!=0) {
              [userModel clippraise:useId withactiId:destinModel.actiId];
        [userModel setBlockWithReturnBlock:^(id returnValue) {
            destinModel.praiseNum=returnValue;
            [self.tableView reloadData];
            NSIndexPath* indexpath=[NSIndexPath indexPathForItem:button.tag inSection:0];
            detailCell* cell=(detailCell*)[self.tableView  cellForRowAtIndexPath:indexpath];
            NSString* string=destinModel.hasPraise;
            if (isclip==NO) {
                if ([string isEqualToString:@"true"]) {
                    [cell.zanLabel setImage:[UIImage imageNamed:@"@3x_home-03.png"] forState:UIControlStateNormal];
                }else
                {
                    [cell.zanLabel setImage:[UIImage imageNamed:@"@3x_home-04.png"] forState:UIControlStateNormal];
                }
                isclip=YES;
            }else
            {
                if ([string isEqualToString:@"true"]) {
                    [cell.zanLabel setImage:[UIImage imageNamed:@"@3x_home-04.png"] forState:UIControlStateNormal];
                }else
                {
                    [cell.zanLabel setImage:[UIImage imageNamed:@"@3x_home-03.png"] forState:UIControlStateNormal];
                }
                isclip=NO;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    detailactivityViewController* detailVC=[SB instantiateViewControllerWithIdentifier:@"detailactivityViewController"];
    destinationModel* destinModel=[self.array objectAtIndex:indexPath.row];
    detailVC.actiId=destinModel.actiId;
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
