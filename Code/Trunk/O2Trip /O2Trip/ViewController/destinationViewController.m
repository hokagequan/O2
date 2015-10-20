//
//  destinationViewController.m
//  O2Trip
//
//  Created by tao on 15/5/12.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "destinationViewController.h"
#import "activityCell.h"
#import "destinationCell.h"
#import "activityDetailViewController.h"
#import "mapViewController.h"
#import "UserViewModel.h"
#import "UIButton+WebCache.h"
#import "destinationModel.h"
#import "activityModel.h"
#import "smallDestinModel.h"
#import "SVPullToRefresh.h"
#import "GiFHUD.h"
#import "Reachability.h"
#import "searchresultViewController.h"
#define ALERTVIEW(STRING) UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:STRING delegate:self cancelButtonTitle:nil  otherButtonTitles:@"确定", nil];\
[alertView show];
@interface destinationViewController ()<UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

-(void)reachabilityChanged:(NSNotification*)note;

@end

@implementation destinationViewController

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
    isclip=NO;
    ischange=NO;
   
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchBar.layer.borderColor = [UIColor colorWithRed:240 / 255. green:240 / 255. blue:240 / 255. alpha:1.0].CGColor;
    self.searchBar.layer.borderWidth = 1;
    self.searchBar.placeholder = @"探索活动、目的地";
    UITextField *txfSearchField = [_searchBar valueForKey:@"_searchField"];
    txfSearchField.backgroundColor = [UIColor whiteColor];
    
//    _textField=[[UITextField alloc]init];
//    _textField.frame=CGRectMake(16, 22, 288,22);
//    _textField.backgroundColor=[UIColor whiteColor];
//    _textField.borderStyle=UITextBorderStyleRoundedRect;
//    _textField.returnKeyType=UIReturnKeyDone;
//    _textField.textAlignment=NSTextAlignmentCenter;
//    _textField.textColor=[UIColor blackColor];
//    UILabel* placeLabel=[[UILabel alloc]initWithFrame:CGRectMake(95, 28, 120, 12)];
//    placeLabel.text=@"探索活动及目的地";
//    placeLabel.textAlignment=NSTextAlignmentCenter;
//    placeLabel.textColor=[UIColor grayColor];
//    placeLabel.font=[UIFont systemFontOfSize:10];
//    [self.view addSubview:_textField];
//    
//    NSArray *HLC = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[view]-16-|" options:0 metrics:nil views:@{@"view": _textField}];
//    NSArray *VLC = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-22-[view(==22)]" options:0 metrics:nil views:@{@"view": _textField}];
//    [self.view addConstraints:HLC];
//    [self.view addConstraints:VLC];
//    
//     [self.view addSubview:placeLabel];
//    _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(78, 28, 12, 12)];
//    _imageView.image=[UIImage imageNamed:@"discover@3x-15.png"];
//    [self.view addSubview:_imageView];
//    _textField.delegate=self;
//    _textField.tag=1;
    [GiFHUD setGifWithImageName:@"loading.gif"];
    [GiFHUD show];
    self.deArray=[[NSMutableArray alloc]initWithCapacity:0];
    self.acArray=[[NSMutableArray alloc]initWithCapacity:0];
    self.navigationController.navigationBarHidden=YES;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0)
    {
        //设置定位权限 仅ios8有意义
        [self.locationManager requestWhenInUseAuthorization];// 前台定位
        
        //  [locationManager requestAlwaysAuthorization];// 前后台同时定位
    }
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    CLLocationDistance distance=10.0;//十米定位一次
    self.locationManager.distanceFilter=distance;
    [self.locationManager startUpdatingLocation];
    self.geoCoder = [[CLGeocoder alloc] init];
    self.array=[[NSMutableArray alloc]initWithObjects:@"活动类型",@"目的地",nil];
    UserViewModel* viewModel=[[UserViewModel alloc]init];
    [viewModel getActivity];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        self.bigarray=returnValue;
        [GiFHUD dismiss];
       [self.bigarray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           if ([obj isKindOfClass:[activityModel class]]) {
               [self.acArray addObject:obj];
           }else
           {
               [self.deArray addObject:obj];
           }
       }];
        [self.tableView reloadData];
        
    } WithErrorBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
  
       self.tableView.dataSource=self;
       self.tableView.delegate=self;
    __weak destinationViewController* weakSelf = self;
    [_tableView addPullToRefreshWithActionHandler:^{
        UserViewModel* viewModel=[[UserViewModel alloc]init];
        [viewModel getActivity];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            [weakSelf.acArray removeAllObjects];
            [weakSelf.deArray removeAllObjects];
             weakSelf.bigarray=returnValue;
            
            [weakSelf.bigarray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[activityModel class]]) {
                    [weakSelf.acArray addObject:obj];
                }else
                {
                    [weakSelf.deArray addObject:obj];
                }   
            }];
            [weakSelf.tableView reloadData];
          
            [_tableView.pullToRefreshView stopAnimating];
            
           
          
            _tableView.showsInfiniteScrolling = YES;
        } WithErrorBlock:^(id errorCode) {
            
        } WithFailureBlock:^{
            
        }];
        
    }];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==1) {
        [self creatshadow];
        [textField resignFirstResponder];
    }else
    {
        [_textField1 becomeFirstResponder];
    }
    
    
    
}
-(void)creatshadow
{
    _imageView.alpha=0;
    _textField.alpha=0;
    _bgView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-49)];
    _bgView.backgroundColor=[UIColor blackColor];
    _bgView.alpha=0.6;
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=_bgView.frame;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:button];
    [self.view insertSubview:_bgView belowSubview:self.searchBar];
    UILabel* label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    label1.backgroundColor=[UIColor colorWithRed:229/255.0 green:229/255.0  blue:229/255.0  alpha:1];
    [_bgView addSubview:label1];
//    _textField1=[[UITextField alloc]initWithFrame:CGRectMake(16, 22, 258, 22)];
//    _textField1.backgroundColor=[UIColor whiteColor];
//    _textField1.borderStyle=UITextBorderStyleRoundedRect;
//    _textField1.returnKeyType=UIReturnKeySearch;
//    _textField1.textAlignment=NSTextAlignmentLeft;
//    _textField1.textColor=[UIColor blackColor];
//    [_bgView addSubview:_textField1];
//    _textField1.tag=2;
//    _textField1.delegate=self;
//    UIImageView* imageview=[[UIImageView alloc]initWithFrame:CGRectMake(18, 22, 15, 15)];
//    imageview.image=[UIImage imageNamed:@"discover@3x-15.png"];
//    [_bgView addSubview:imageview];
//    UIButton* cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    cancelButton.frame=CGRectMake(272, 24, 40, 20);
//    cancelButton.titleLabel.font=[UIFont systemFontOfSize:13];
//    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//    [cancelButton setTitleColor:[UIColor colorWithRed:26/255.0 green:188/255.0 blue:156/255.0 alpha:1] forState:UIControlStateNormal];
//    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_bgView addSubview:cancelButton];
    
    
}
//点击灰色地方返回
-(void)buttonClick:(UIButton*)button
{
//    _imageView.alpha=1;
//    _textField.alpha=1;
//    _textField.frame=CGRectMake(16, 22, 288, 22);
//    _textField1.text=@"";
//    _textField.text=@"";
//    [_textField resignFirstResponder];
//    [_bgView removeFromSuperview];
    
    [self cancelButtonClick:nil];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
        if ([string isEqualToString:@"\n"])
        {
            [textField resignFirstResponder];
            [self connectInternet];
        }
    
   
      return YES;
}
-(void)connectInternet
{
//    self.textField.alpha=1;
//    self.textField.frame=CGRectMake(16, 15, 288, 30);
//    self.glassimage.alpha=1;
//    _textField1.text=@"";
//    self.textField.text=@"";
//    [self.textField resignFirstResponder];
//    [_bgView removeFromSuperview];
    if (_textField1.text.length!=0) {
            UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            searchresultViewController* searchVC=[SB instantiateViewControllerWithIdentifier:@"searchResultVC"];
             searchVC.textFieldText=_textField1.text;
            [self.navigationController pushViewController:searchVC animated:YES];

    }else
    {
        ALERTVIEW(@"请输入你要搜索的内容");
    }
//    UserViewModel* userModel=[[UserViewModel alloc]init];
//    NSUserDefaults* userDefaults =[NSUserDefaults standardUserDefaults];
//    NSString* user_id=[userDefaults objectForKey:@"loginUserId"];
//    [userModel searchActivity:_textField1.text withUserId:user_id withLatitude:33.00 withLongtitude:44.00];

}
-(void)cancelButtonClick:(UIButton*)button
{
    _imageView.alpha=1;
    _textField.alpha=1;
    _textField.frame=CGRectMake(16, 22, 288, 22);
    _textField1.text=@"";
    _textField.text=@"";
    [_textField resignFirstResponder];
    [_bgView removeFromSuperview];
    [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton = NO;
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

#pragma mark - SearchBar

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self creatshadow];
    
    searchBar.showsCancelButton = YES;
    
    for (UIView *subView in [(UIView *)[[searchBar subviews] firstObject] subviews]) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subView;
            [button setTitle:@"搜索" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:26 / 255.0 green:188 / 255.0 blue:156 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        }
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self cancelButtonClick:nil];
    [self connectInternet];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"])
    {
        [searchBar resignFirstResponder];
        [self connectInternet];
    }
    
    return YES;
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
     //NSLog(@"==%f,==%f",latitude,longitude);
    _Latitude=latitude;
    _Longitude=longitude;
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    [self.geoCoder reverseGeocodeLocation:location1 completionHandler:^(NSArray *placemarks, NSError *error) {
        // NSLog(@"%@----%@",placemarks,error);
        
        CLPlacemark *place = [placemarks lastObject];
        ;
        if (place.country!=nil) {
           // _dressLabel.text=[NSString stringWithFormat:@"%@%@",place.country,place.administrativeArea];
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
      
    }else
    {
        
        return 1;
       
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 174;
    }else{
        return 328;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        activityCell * cell=[tableView dequeueReusableCellWithIdentifier:@"activitycell"];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"activityCell" owner:self options:nil]lastObject];
        }
        cell.selected=NO;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        smallDestinModel* smallModel=[[smallDestinModel alloc]init];
        if (indexPath.row*5<self.deArray.count) {
            smallModel=[self.deArray objectAtIndex:indexPath.row*5];
           cell.footLabel.text=smallModel.typeName;
            NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,smallModel.typeImg]];
            [cell.footButton sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
            cell.footButton.tag=1;
            [cell.footButton addTarget:self action:@selector(footButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (indexPath.row*5+1<self.deArray.count) {
            smallModel=[self.deArray objectAtIndex:indexPath.row*5+1];
         cell.jumpLabel.text=smallModel.typeName;
            NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,smallModel.typeImg]];
            [cell.jumpButton sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
            cell.jumpButton.tag=2;
            [cell.jumpButton addTarget:self action:@selector(footButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        }
        if (indexPath.row*5+2<self.deArray.count) {
            smallModel=[self.deArray objectAtIndex:indexPath.row*5+2];
            cell.wadingLabel.text=smallModel.typeName;
            NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,smallModel.typeImg]];
            cell.wadingButton.tag=3;
            [cell.wadingButton sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
            [cell.wadingButton addTarget:self action:@selector(footButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (indexPath.row*5+3<self.deArray.count) {
            smallModel=[self.deArray objectAtIndex:indexPath.row*5+3];
            cell.sailingLabel.text=smallModel.typeName;
            NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,smallModel.typeImg]];
            [cell.sailingButton sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
            cell.sailingButton.tag=4;
            [cell.sailingButton addTarget:self action:@selector(footButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (indexPath.row*5+4<self.deArray.count) {
            smallModel=[self.deArray objectAtIndex:indexPath.row*5+4];
            cell.openLabel.text=smallModel.typeName;
            NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,smallModel.typeImg]];
            cell.openButton.tag=5;
            [cell.openButton sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
            [cell.openButton addTarget:self action:@selector(footButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        }
        if (indexPath.row*5+5<self.deArray.count) {
            smallModel=[self.deArray objectAtIndex:indexPath.row*5+5];
            cell.driveLabel.text=smallModel.typeName;
            NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,smallModel.typeImg]];
            [cell.driveButton sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
            cell.driveButton.tag=6;
            [cell.driveButton addTarget:self action:@selector(footButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (indexPath.row*5+6<self.deArray.count) {
            smallModel=[self.deArray objectAtIndex:indexPath.row*5+6];
            cell.campingLabel.text=smallModel.typeName;
            NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,smallModel.typeImg]];
            [cell.campingButton sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
            cell.campingButton.tag=7;
            [cell.campingButton addTarget:self action:@selector(footButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (indexPath.row*5+7<self.deArray.count) {
            smallModel=[self.deArray objectAtIndex:indexPath.row*5+7];
            cell.skilabel.text=smallModel.typeName;
            NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,smallModel.typeImg]];
            [cell.skiButton sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
            cell.skiButton.tag=8;
            [cell.skiButton addTarget:self action:@selector(footButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (indexPath.row*5+8<self.deArray.count) {
            smallModel=[self.deArray objectAtIndex:indexPath.row*5+8];
            cell.divingLabel.text=smallModel.typeName;
            NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,smallModel.typeImg]];
            [cell.divingButton sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
            cell.divingButton.tag=9;
            [cell.divingButton addTarget:self action:@selector(footButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (indexPath.row*5+9<self.deArray.count) {
            smallModel=[self.deArray objectAtIndex:indexPath.row*5+9];
            cell.honeyLabel.text=smallModel.typeName;
            NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,smallModel.typeImg]];
            [cell.honeyButton sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];

            [cell.honeyButton addTarget:self action:@selector(footButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.honeyButton.tag=10;
        }
       
        
        
        return cell;
    }else
    {
        
        destinationCell* cell=[tableView dequeueReusableCellWithIdentifier:@"destinationcell"];
        cell.selected=NO;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"destinationCell" owner:self options:nil]objectAtIndex:0];
        }
        activityModel * actiModel=[[activityModel alloc]init];
        if (indexPath.row<self.acArray.count) {
            
            actiModel=[self.acArray objectAtIndex:indexPath.row];
            [cell.meiButton setTitle:actiModel.countryName forState:UIControlStateNormal];
            NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,actiModel.countryImg]];
            cell.selected=NO;
            cell.meiButton.tag=1;
            //cell.meiView.layer.masksToBounds=YES;
           // cell.meiView.layer.cornerRadius=2.6;
            cell.meiButton.layer.masksToBounds=YES;
            cell.meiButton.layer.cornerRadius=2.6;
            [cell.meiButton sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
            //[cell.zmeiButton addTarget:self action:@selector(meiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.meiButton addTarget:self action:@selector(meiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (indexPath.row+1<self.acArray.count) {
            actiModel=[self.acArray objectAtIndex:indexPath.row+1];
            [cell.yinButton setTitle:actiModel.countryName forState:UIControlStateNormal];
             NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,actiModel.countryImg]];
            cell.yinButton.tag=2;
            cell.yinButton.layer.masksToBounds=YES;
            cell.yinButton.layer.cornerRadius=2.6;
            //cell.yinView.layer.masksToBounds=YES;
            //cell.yinView.layer.cornerRadius=2.6;
             [cell.yinButton sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
             //[cell.yinButton addTarget:self action:@selector(meiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.yinButton addTarget:self action:@selector(meiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (indexPath.row+2<self.acArray.count) {
            actiModel=[self.acArray objectAtIndex:indexPath.row+2];
            [cell.ruiButton setTitle:actiModel.countryName forState:UIControlStateNormal];
             NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,actiModel.countryImg]];
            cell.ruiButton.tag=3;
            cell.ruiButton.layer.masksToBounds=YES;
            cell.ruiButton.layer.cornerRadius=2.6;
            //cell.ruiView.layer.masksToBounds=YES;
            //cell.ruiView.layer.cornerRadius=2.6;
            [cell.ruiButton sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
            //[cell.zruiButton addTarget:self action:@selector(meiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.ruiButton addTarget:self action:@selector(meiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (indexPath.row+3<self.acArray.count) {
            actiModel=[self.acArray objectAtIndex:indexPath.row+3];
            [cell.nuoButton setTitle:actiModel.countryName forState:UIControlStateNormal];
             NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,actiModel.countryImg]];
            cell.nuoButton.layer.masksToBounds=YES;
            cell.nuoButton.layer.cornerRadius=2.6;
            //cell.nuoView.layer.masksToBounds=YES;
            //cell.nuoView.layer.cornerRadius=2.6;
            [cell.nuoButton sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
            //[cell.znuoButton addTarget:self action:@selector(meiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.nuoButton addTarget:self action:@selector(meiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
             cell.nuoButton.tag=4;
          
        }
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)footButtonClick:(UIButton*)button
{
    
    
    [GiFHUD setGifWithImageName:@"loading.gif"];
    [GiFHUD show];
    if (isclip==NO) {
        smallDestinModel* smallModel=[[smallDestinModel alloc]init];
        //NSLog(@"tag==%d",button.tag);
        smallModel=[self.deArray objectAtIndex:button.tag-1];
        UserViewModel* useviewModel=[[UserViewModel alloc]init];
        //NSLog(@"==%@",smallModel.typeName);
        NSUserDefaults* useDefaults=[NSUserDefaults standardUserDefaults];
        NSString* useId=[useDefaults objectForKey:@"loginUserId"];
        [useviewModel getdetailActivity:smallModel.typeName withlatitude:_Latitude withLongtitude:_Longitude withUseId:useId];
        [useviewModel setBlockWithReturnBlock:^(id returnValue) {
            [GiFHUD dismiss];
            UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            activityDetailViewController* detailVC=[SB instantiateViewControllerWithIdentifier:@"activityDetailViewController"];
            detailVC.array=returnValue;
            detailVC.text=smallModel.typeName;
            detailVC.b=1;
            [self.navigationController pushViewController:detailVC animated:YES];
        } WithErrorBlock:^(id errorCode) {
            
        } WithFailureBlock:^{
            
        }];
        isclip=YES;
        

    }
   


   
}

-(void)meiButtonClick:(UIButton*)button
{

    if (ischange==NO) {
        [GiFHUD setGifWithImageName:@"loading.gif"];
        [GiFHUD show];
        activityModel * acModel=[[activityModel alloc]init];
        acModel=[self.acArray objectAtIndex:button.tag-1];
        UserViewModel* useviewModel=[[UserViewModel alloc]init];
        NSUserDefaults* userdefaults=[NSUserDefaults standardUserDefaults];
        NSString* useId=[userdefaults objectForKey:@"loginUserId"];
        [useviewModel getdestination:acModel.countryId withLatitude:_Latitude withLongtitude:_Longitude withUseId:useId];
        [useviewModel setBlockWithReturnBlock:^(id returnValue) {
            [GiFHUD dismiss];
            UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            activityDetailViewController* detailVC=[SB instantiateViewControllerWithIdentifier:@"activityDetailViewController"];
            detailVC.array=returnValue;
            activityModel * actiModel=[[activityModel alloc]init];
            actiModel=[self.acArray objectAtIndex:button.tag-1];
            detailVC.text=actiModel.countryName;
            detailVC.countryId=actiModel.countryId;
            [self.navigationController pushViewController:detailVC animated:YES];
        } WithErrorBlock:^(id errorCode) {
            
        } WithFailureBlock:^{
            
        }];
        ischange=YES;

    }
   
    
   
   
}
- (IBAction)mapButtonClick:(id)sender
{
    UIStoryboard* SB=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    mapViewController* mapVC=[SB instantiateViewControllerWithIdentifier:@"mapViewController"];
    [self.navigationController pushViewController:mapVC animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [GiFHUD dismiss];
}
-(void)dealloc
{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
