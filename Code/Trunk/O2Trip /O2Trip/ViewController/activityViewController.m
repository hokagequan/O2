//
//  activityViewController.m
//  O2Trip
//
//  Created by tao on 15/5/12.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "activityViewController.h"
#import "MKtripAnnotation.h"
#import "mapCell.h"
#import "moreCell.h"
#import "activityDetailViewController.h"
#import "mapViewController.h"
#import "UserViewModel.h"
#import "SVPullToRefresh.h"
#import "GiFHUD.h"
#import "Reachability.h"
#import "WGS84TOGCJ02.h"
#define ALERTVIEW(STRING) UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:STRING delegate:self cancelButtonTitle:nil  otherButtonTitles:@"确定", nil];\
[alertView show];
@interface activityViewController (private)

-(void)reachabilityChanged:(NSNotification*)note;

@end

@implementation activityViewController
-(CLLocationManager*)locationManager
{
    if (!_locationManager) {
        self.locationManager=[[CLLocationManager alloc]init];
        self.locationManager.delegate=self;
    }
    return _locationManager;
   
}


-(void)viewDidLoad
{

    [super viewDidLoad];
    [GiFHUD setGifWithImageName:@"waiting.gif"];
    [GiFHUD show];
    [self performSelector:@selector(showjuhua) withObject:nil afterDelay:0.1f];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0)
    {
        //设置定位权限 仅ios8有意义
        [self.locationManager requestWhenInUseAuthorization];// 前台定位
        
        //  [locationManager requestAlwaysAuthorization];// 前后台同时定位
    }

    [_mapView setShowsUserLocation:YES];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.locationManager startUpdatingLocation];
    self.geoCoder = [[CLGeocoder alloc] init];
    self.textField.returnKeyType=UIReturnKeySearch;
      __weak activityViewController* weakSelf = self;
    [_tableView addPullToRefreshWithActionHandler:^{

         [weakSelf performSelector:@selector(requestFinished:) withObject:nil afterDelay:2.0f];
    }];
}

-(void)showjuhua
{
  [GiFHUD dismiss];
}

-(void)requestFinished:(id)object
{
    
    [_tableView.pullToRefreshView stopAnimating];
    
    //刷新表
    [_tableView reloadData];
    self.myview.alpha=0;
    self.dressLabel.alpha=0;
    _tableView.showsInfiniteScrolling = YES;
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
    _Latitude=latitude;
    _Longitude=longitude;
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    [self.geoCoder reverseGeocodeLocation:location1 completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *place = [placemarks lastObject];
       ;
        if (place.administrativeArea!=nil&&place.thoroughfare!=nil) {
            _bigLabel.text =[NSString stringWithFormat:@"%@%@",place.country,place.administrativeArea];
            _dressLabel.text=[NSString stringWithFormat:@"当前位置:%@",place.thoroughfare];
           
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
        return 1;
    }
    else
    {
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 211;
    }else
    {
        return 98;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        mapCell* cell=[tableView dequeueReusableCellWithIdentifier:@"mapcell"];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"mapCell" owner:self options:nil]lastObject];
        }
        cell.selected=NO;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.mapImageView.image=[UIImage imageNamed:@"世界地图坐标.jpg"];
        [cell.bingButton addTarget:self action:@selector(bingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.luoButton addTarget:self action:@selector(luoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
         [cell.fenButton addTarget:self action:@selector(fenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
         [cell.xiButton addTarget:self action:@selector(xiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
         [cell.maButton addTarget:self action:@selector(maButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;

    }else
    {
        moreCell* cell=[tableView dequeueReusableCellWithIdentifier:@"morecell"];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"moreCell" owner:self options:nil]lastObject];
            
        }
        cell.selected=NO;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell.button1 setTitle:@"冰岛" forState:UIControlStateNormal];
        [cell.button2 setTitle:@"挪威" forState:UIControlStateNormal];
        [cell.button3 setTitle:@"芬兰" forState:UIControlStateNormal];
        [cell.button4 setTitle:@"西班牙" forState:UIControlStateNormal];
        [cell.button5 setTitle:@"马来西亚" forState:UIControlStateNormal];
        [cell.button1 addTarget:self action:@selector(bingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button2 addTarget:self action:@selector(luoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button3 addTarget:self action:@selector(fenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button4 addTarget:self action:@selector(xiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button5 addTarget:self action:@selector(maButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)bingButtonClick:(UIButton*)button
{
    if (isClip==NO) {
        UserViewModel* viewModel=[[UserViewModel alloc]init];
        NSUserDefaults* userdefaults=[NSUserDefaults standardUserDefaults];
        NSString* userId=[userdefaults objectForKey:@"loginUserId"];
        [viewModel getDetailDestination:@"冰岛" withlatitude:_Latitude withLongtitude:_Longitude withUseId:userId];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            self.array=returnValue;
            
            UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            activityDetailViewController* detailVC=[SB instantiateViewControllerWithIdentifier:@"activityDetailViewController"];
            detailVC.array=self.array;
          detailVC.countryId=@"冰岛";
            detailVC.text=@"冰岛";
            detailVC.b=2;
            [self.navigationController pushViewController:detailVC animated:YES];
            
        } WithErrorBlock:^(id errorCode) {
            //NSLog(@"出错");
        } WithFailureBlock:^{
            //NSLog(@"失败");
        }];
        isClip=YES;

    }else{
        isClip=NO;
    }
    
   
}
-(void)luoButtonClick:(UIButton*)button
{

    if (isClip==NO) {
        NSUserDefaults* userdefaults=[NSUserDefaults standardUserDefaults];
        NSString* userId=[userdefaults objectForKey:@"loginUserId"];
        UserViewModel* viewModel=[[UserViewModel alloc]init];
        [viewModel getDetailDestination:@"挪威" withlatitude:_Latitude withLongtitude:_Longitude withUseId:userId];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            self.array=returnValue;
          
            UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            activityDetailViewController* detailVC=[SB instantiateViewControllerWithIdentifier:@"activityDetailViewController"];
            detailVC.array=self.array;
            detailVC.countryId=@"挪威";
             detailVC.text=@"挪威";
            [self.navigationController pushViewController:detailVC animated:YES];
            
        } WithErrorBlock:^(id errorCode) {
           // NSLog(@"出错");
        } WithFailureBlock:^{
           // NSLog(@"失败");
        }];
        isClip=YES;
      

    }else
    {
        
        
        isClip=NO;
    }
    
}
-(void)fenButtonClick:(UIButton*)button
{
  
    if (isClip==NO) {
        UserViewModel* viewModel=[[UserViewModel alloc]init];
        NSUserDefaults* userdefaults=[NSUserDefaults standardUserDefaults];
        NSString* userId=[userdefaults objectForKey:@"loginUserId"];
        [viewModel getDetailDestination:@"芬兰" withlatitude:_Latitude withLongtitude:_Longitude withUseId:userId];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            self.array=returnValue;
            UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            activityDetailViewController* detailVC=[SB instantiateViewControllerWithIdentifier:@"activityDetailViewController"];
            detailVC.array=self.array;
            detailVC.countryId=@"芬兰";
            detailVC.text=@"芬兰";
            [self.navigationController pushViewController:detailVC animated:YES];
            
        } WithErrorBlock:^(id errorCode) {
            //NSLog(@"出错");
        } WithFailureBlock:^{
            //NSLog(@"失败");
        }];
        isClip=YES;
    }else
    {
        isClip=NO;
    }
   

}
-(void)xiButtonClick:(UIButton*)button
{

    if (isClip==NO) {
        UserViewModel* viewModel=[[UserViewModel alloc]init];
        NSUserDefaults* userdefaults=[NSUserDefaults standardUserDefaults];
        NSString* userId=[userdefaults objectForKey:@"loginUserId"];
        [viewModel getDetailDestination:@"西班牙" withlatitude:_Latitude withLongtitude:_Longitude withUseId:userId];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            self.array=returnValue;
            UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            activityDetailViewController* detailVC=[SB instantiateViewControllerWithIdentifier:@"activityDetailViewController"];
            detailVC.array=self.array;
                detailVC.countryId=@"西班牙";
                detailVC.text=@"西班牙";
            [self.navigationController pushViewController:detailVC animated:YES];
            
        } WithErrorBlock:^(id errorCode) {
            //NSLog(@"出错");
        } WithFailureBlock:^{
            //NSLog(@"失败");
        }];
        isClip=YES;

    }else
    {
        isClip=NO;
    }
   
}
-(void)maButtonClick:(UIButton*)button
{

    if (isClip==NO) {
        UserViewModel* viewModel=[[UserViewModel alloc]init];
        NSUserDefaults* userdefaults=[NSUserDefaults standardUserDefaults];
        NSString* userId=[userdefaults objectForKey:@"loginUserId"];
        [viewModel getDetailDestination:@"马来西亚" withlatitude:_Latitude withLongtitude:_Longitude withUseId:userId];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            self.array=returnValue;
            UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            activityDetailViewController* detailVC=[SB instantiateViewControllerWithIdentifier:@"activityDetailViewController"];
            detailVC.array=self.array;
             detailVC.countryId=@"马来西亚";
            detailVC.text=@"马来西亚";
            [self.navigationController pushViewController:detailVC animated:YES];
            
        } WithErrorBlock:^(id errorCode) {
           // NSLog(@"出错");
        } WithFailureBlock:^{
            //NSLog(@"失败");
        }];
        isClip=YES;

    }else
    {
        isClip=NO;
    }
   
}
- (IBAction)MapButtonClick:(id)sender
{
    UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
   mapViewController* mapVC=[SB instantiateViewControllerWithIdentifier:@"mapViewController"];
    [self.navigationController pushViewController:mapVC animated:YES];
}
-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
