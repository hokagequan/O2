//
//  mapViewController.m
//  O2Trip
//
//  Created by tao on 15/5/6.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "mapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "UserViewModel.h"
#import "allModel.h"
@interface mapViewController()<MAMapViewDelegate>
{
    MAMapView* _mapView;
    UIView* _view2;
    BOOL isopen;
    
}
@end
@implementation mapViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    UserViewModel* userModel=[[UserViewModel alloc]init];
    [userModel getgetDestiPostions];
    [userModel setBlockWithReturnBlock:^(id returnValue) {
        self.array=returnValue;
       // NSLog(@"dddd%d",self.array.count);
    } WithErrorBlock:^(id errorCode) {
        
    } WithFailureBlock:^{
        
    }];
}
-(void)viewDidAppear:(BOOL)animated
{
    

    [super viewDidAppear:animated];
    [MAMapServices sharedServices].apiKey=@"b8e93d3716cf621510073757eeb92710";
    _mapView=[[MAMapView alloc]initWithFrame:self.view.frame];
    _mapView.delegate=self;
    _mapView.mapType=MAMapTypeStandard;
    _mapView.userTrackingMode=MAUserTrackingModeFollowWithHeading;
    [self.view addSubview: _mapView];
    UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 20, 120, 30)];
    view.backgroundColor=[UIColor grayColor];
    view.alpha=0.6;
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(10, 5, 15, 20);
    [button setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(60, 5, 40, 20)];
    label.text=@"全部";
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:13];
    [view addSubview:label];
    UIButton* button1=[UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame=CGRectMake(100, 10, 10, 10);
    [button1 setBackgroundImage:[UIImage imageNamed:@"倒三角"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button1];
    [self.view addSubview:view];
    _view2=[[UIView alloc]initWithFrame:CGRectMake(60, -30, 40, 80)];
    //UIView* view2=[[UIView alloc]initWithFrame:CGRectMake(60, 50, 40, 80)];
    _view2.backgroundColor=[UIColor grayColor];
    _view2.alpha=0;
    UIButton* button2=[UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame=CGRectMake(0, 0, 20, 20);
    [button2 setTitle:@"1" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(Button2Click:) forControlEvents:UIControlEventTouchUpInside];
    [_view2 addSubview:button2];
    UIButton* button3=[UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame=CGRectMake(0, 20, 20, 20);
    [button3 setTitle:@"2" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(Button3Click:) forControlEvents:UIControlEventTouchUpInside];
    [_view2 addSubview:button3];
    UIButton* button4=[UIButton buttonWithType:UIButtonTypeCustom];
    button4.frame=CGRectMake(0, 40, 20, 20);
    [button4 setTitle:@"3" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(Button4Click:) forControlEvents:UIControlEventTouchUpInside];
    [_view2 addSubview:button4];
    UIButton* button5=[UIButton buttonWithType:UIButtonTypeCustom];
    button5.frame=CGRectMake(0, 60, 20, 20);
    [button5 setTitle:@"4" forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(Button5Click:) forControlEvents:UIControlEventTouchUpInside];
    [_view2 addSubview:button5];
    [self.view addSubview:_view2];
    isopen=NO;
    UIView* view3=[[UIView alloc]initWithFrame:CGRectMake(250, 20, 30, 30)];
    view3.backgroundColor=[UIColor grayColor];
    view3.alpha=0.6;
    UIButton* refreshButton=[UIButton buttonWithType:UIButtonTypeCustom];
    refreshButton.frame=CGRectMake(0, 0, 30, 30);
    [refreshButton setBackgroundImage:[UIImage imageNamed:@"刷新"] forState:UIControlStateNormal];
    [view3 addSubview:refreshButton];
    [self.view addSubview:view3];
    UIView* view4=[[UIView alloc]initWithFrame:CGRectMake(40, 500, 30, 30)];
    view4.backgroundColor=[UIColor grayColor];
    view4.alpha=0.6;
    UIButton* daoButton=[UIButton buttonWithType:UIButtonTypeCustom];
    daoButton.frame=CGRectMake(0, 0, 30, 30);
    [daoButton setBackgroundImage:[UIImage imageNamed:@"导航箭头"] forState:UIControlStateNormal];
    [view4 addSubview:daoButton];
    [self.view addSubview:view4];
    UIView* view5=[[UIView alloc]initWithFrame:CGRectMake(250, 500, 30, 30)];
    view5.backgroundColor=[UIColor grayColor];
    view5.alpha=0.6;
    UIButton* otherButton=[UIButton buttonWithType:UIButtonTypeCustom];
    otherButton.frame=CGRectMake(0, 0, 30, 30);
    [otherButton setBackgroundImage:[UIImage imageNamed:@"三横杆"] forState:UIControlStateNormal];
    [view5 addSubview:otherButton];
    [self.view addSubview:view5];
   // NSLog(@"%d",self.array.count);
    for (int i=0; i<self.array.count; i++) {
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        allModel* aModel=self.array[i];
        double latitude=[aModel.fsLatitude doubleValue];
        double longitude=[aModel.fsLongtitude doubleValue];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(longitude, latitude);
        pointAnnotation.title = aModel.destiName;
        pointAnnotation.subtitle = aModel.actiName;
        
        [_mapView addAnnotation:pointAnnotation];
    }
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    allModel* aModel=self.array[1];
    double latitude=[aModel.fsLatitude doubleValue];
    double longitude=[aModel.fsLongtitude doubleValue];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(longitude, latitude);
    CLLocationCoordinate2D center=pointAnnotation.coordinate;
   [_mapView setCenterCoordinate:pointAnnotation.coordinate animated:YES];
    MACoordinateSpan span = MACoordinateSpanMake(100, 100);
     MACoordinateRegion region = MACoordinateRegionMake(center, span);
    [_mapView setRegion:region animated:YES];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
//    // 取出用户当前的经纬度
//    CLLocationCoordinate2D center = userLocation.location.coordinate;
//    
//    // 设置地图的中心点（以用户所在的位置为中心点）
//    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
//    
//    // 设置地图的显示范围
//    MACoordinateSpan span = MACoordinateSpanMake(0.5, 0.5);
//    MACoordinateRegion region = MACoordinateRegionMake(center, span);
//    [mapView setRegion:region animated:YES];
}
-(void)Button2Click:(UIButton*)button
{
    //NSLog(@"11");
}
-(void)Button3Click:(UIButton*)button
{
    
}
-(void)Button4Click:(UIButton*)button
{
    
}
-(void)Button5Click:(UIButton*)button
{
    
}
-(void)selectButtonClick:(UIButton*)button
{
    if (isopen==NO) {
        _view2.alpha=0.6;
        _view2.frame=CGRectMake(60, 50, 40, 80);
        isopen=YES;
    }else
    {
        _view2.alpha=0;
        _view2.frame=CGRectMake(60, -30, 40, 80);
        isopen=NO;
    }
    
   
}
-(void)buttonClick:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end


