//
//  searchresultViewController.m
//  O2Trip
//
//  Created by tao on 15/8/21.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "searchresultViewController.h"
#import "mudidiCell.h"
#import "huodongCell.h"
#import "UserViewModel.h"
#import "destinationModel.h"
#import "UIImageView+WebCache.h"
#import "GiFHUD.h"
#import "destinationModel.h"
#import "acModel.h"
#import "deModel.h"
#import "LoginViewController.h"
#import "detailactivityViewController.h"
@interface searchresultViewController ()
{
    CLLocationDegrees _Latitude;
    CLLocationDegrees _Longitude;
}
@end

@implementation searchresultViewController
-(CLLocationManager*)locationManager
{
    if (!_locationManager) {
        self.locationManager=[[CLLocationManager alloc]init];
        self.locationManager.delegate=self;
    }
    return _locationManager;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [GiFHUD setGifWithImageName:@"loading.gif"];
    [GiFHUD show];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0)
    {
        //设置定位权限 仅ios8有意义
        [self.locationManager requestWhenInUseAuthorization];// 前台定位
        
        //  [locationManager requestAlwaysAuthorization];// 前后台同时定位
    }
    [self.locationManager startUpdatingLocation];
    self.geoCoder = [[CLGeocoder alloc] init];
     self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor=[UIColor grayColor];
    self.acArray=[[NSMutableArray alloc]initWithCapacity:0];
    self.deArray=[[NSMutableArray alloc]initWithCapacity:0];
        UserViewModel* userModel=[[UserViewModel alloc]init];
        NSUserDefaults* userDefaults =[NSUserDefaults standardUserDefaults];
        NSString* user_id=[userDefaults objectForKey:@"loginUserId"];
        [userModel searchActivity:self.textFieldText withUserId:user_id withLatitude:30.00 withLongtitude:40.00];
       [userModel setBlockWithReturnBlock:^(id returnValue) {
           self.bigarray=returnValue;
           [GiFHUD dismiss];
          
           [self.bigarray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
               if ([obj isKindOfClass:[acModel class]]) {
                   [self.acArray addObject:obj];
               }else
               {
                   [self.deArray addObject:obj];
               }
           }];
           if (self.acArray.count==0) {
               [self creatNoSearchResultView];
           }
           [self.tableView reloadData];

       } WithErrorBlock:^(id errorCode) {
           
       } WithFailureBlock:^{
           
       }];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    // Do any additional setup after loading the view.
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
    
    // NSLog(@"==%f,==%f",latitude,longitude);
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    [self.geoCoder reverseGeocodeLocation:location1 completionHandler:^(NSArray *placemarks, NSError *error) {
        // NSLog(@"%@----%@",placemarks,error);
        
        CLPlacemark *place = [placemarks lastObject];
        ;
        if (place.country!=nil) {
           
           
        }
        
    }];
    
}

-(void)creatNoSearchResultView
{
    UIImageView* bg=[[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-54)/2, 195, 54, 54)];
    bg.image=[UIImage imageNamed:@"collect1@2x.jpg"];
    [self.view addSubview:bg];
    UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-150)/2, 270, 150, 16)];
    label.font=[UIFont systemFontOfSize:13];
    label.text=@"暂无搜索结果~";
    label.textAlignment= NSTextAlignmentCenter;
    label.textColor=[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    [self.view addSubview:label];
   
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma marks 表的代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 276;
    }else
    {
        return 246;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        
        return 0;
       
    }else
    {
        
        return self.acArray.count;
       
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        mudidiCell* cell=[tableView dequeueReusableCellWithIdentifier:@"mudidiCell"];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"mudidiCell" owner:self options:nil]lastObject];
        }
        if (self.deArray.count!=0) {
            deModel* dModel=[self.deArray objectAtIndex:indexPath.row];
            cell.cityName.text=dModel.destiName;
            cell.cityName.font=[UIFont fontWithName:@"FZLTXHJW" size:13];
            cell.number_hd.text=dModel.actiNum;
            //NSLog(@"dddd%@",[dict2[indexPath.row] objectForKey:@"destiName"]);
            cell.number_hd.text=[NSString stringWithFormat:@"热门目的地"];
            NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,dModel.destiImg]];
            [cell.bj_image sd_setImageWithURL:url];
        }
       
        
        return cell;
    }else
    {
        huodongCell* cell=[tableView dequeueReusableCellWithIdentifier:@"huodongCell"];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"huodongCell" owner:self options:nil]lastObject];
        }
        acModel* aModel=[self.acArray objectAtIndex:indexPath.row];
        NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,[aModel.actiImage lastObject]]];
        [cell.bj_name_xq sd_setImageWithURL:url];
        cell.tuBuType.text=aModel.tripDistance;
        NSString* type=aModel.actiType;
        cell.tuBuType.text=[NSString stringWithFormat:@"%@,%@KM",type,cell.tuBuType.text];
        cell.tBTime.text=aModel.days;
        cell.numberT.text=aModel.discussNum;
        //int j=[aModel.origPrice intValue];
        int z=[aModel.specialPrice intValue];
        //int y=j-z;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
       // NSString *string1 = [formatter stringFromNumber:[NSNumber numberWithInt:j]];
        NSString *string2 = [formatter stringFromNumber:[NSNumber numberWithInt:z]];
        //NSString *string3 = [formatter stringFromNumber:[NSNumber numberWithInt:y]];
        cell.Tjia.text=[NSString stringWithFormat:@"￥%@",string2];
        cell.dZnumber.text=aModel.praiseNum;
        NSString* string=aModel.hasPraise;
        if ([string isEqualToString:@"true"]) {
            [cell.zanButton setBackgroundImage:[UIImage imageNamed:@"@3x_home-04.png"] forState:UIControlStateNormal];
            
        }else
        {
            [cell.zanButton setBackgroundImage:[UIImage imageNamed:@"@3x_home-03.png"] forState:UIControlStateNormal];
        }
        cell.nameHD.text=aModel.actiTitle;
        cell.zanButton.tag=indexPath.row;
        [cell.zanButton addTarget:self action:@selector(zanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;

    }
}
//点赞
-(void)zanButtonClick:(UIButton*)button
{
    acModel* aModel=[self.acArray objectAtIndex:button.tag];
    NSString* actiId=aModel.actiId;
    UserViewModel* userModel=[[UserViewModel alloc]init];
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSString* useId=[userDefaults objectForKey:@"loginUserId"];
    if (useId.length!=0) {
        //NSLog(@"mlgb%@",useId);
        [userModel clippraise:useId withactiId:actiId];
        [userModel setBlockWithReturnBlock:^(id returnValue) {
            
            //[self getRequest];
            //NSLog(@"--%@",returnValue);
            NSIndexPath* indexpath=[NSIndexPath indexPathForItem:button.tag inSection:1];
            huodongCell* cell=(huodongCell*)[self.tableView  cellForRowAtIndexPath:indexpath];
            NSString* num=aModel.praiseNum ;
            NSString* string=aModel.hasPraise;
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
            
            //cell.dZnumber=[dict5[button.tag] objectForKey:@"praiseNum"];
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
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UserViewModel* userModel=[[UserViewModel alloc]init];
    acModel* aModel=[self.acArray objectAtIndex:indexPath.row];
    //[userModel homeXQ:actiId];
    UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    detailactivityViewController* detailVC=[SB instantiateViewControllerWithIdentifier:@"detailactivityViewController"];
    detailVC.actiId=aModel.actiId;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
