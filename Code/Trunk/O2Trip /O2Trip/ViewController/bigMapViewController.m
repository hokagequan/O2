//
//  bigMapViewController.m
//  O2Trip
//
//  Created by tao on 15/5/25.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "bigMapViewController.h"

@interface bigMapViewController()
@end
@implementation bigMapViewController
-(CLLocationManager*)locationManager
{
    if (!_locationManager) {
        self.locationManager=[[CLLocationManager alloc]init];
        self.locationManager.delegate=self;
    }
    return _locationManager;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //self.array=[[NSMutableArray alloc]initWithCapacity:0];
    [MAMapServices sharedServices].apiKey=@"b8e93d3716cf621510073757eeb92710";
    self.mapView=[[MAMapView alloc]initWithFrame:self.view.frame];
    _mapView.delegate=self;
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    CLLocationDistance distance=10.0;//十米定位一次
    self.locationManager.distanceFilter=distance;
    _mapView.mapType=MAMapTypeStandard;
    _mapView.userTrackingMode=MAUserTrackingModeFollowWithHeading;
    [self.view addSubview: _mapView];
    UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 20, 120, 30)];
    view.backgroundColor=[UIColor grayColor];
    view.alpha=0.6;
    [self.view addSubview:view];
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(5, 5, 20, 20);
    [button setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonCLick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    for (int i=0; i<self.array.count; i++) {
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        NSDictionary* dic=self.array[i];
        double latitude=[[dic objectForKey:@"latitude"] doubleValue];
        double longitude=[[dic objectForKey:@"longitude"]doubleValue];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(longitude, latitude);
        
        pointAnnotation.title = [dic objectForKey:@"dayNo"];
        pointAnnotation.subtitle = [dic objectForKey:@"dayTitle"];
        
        [_mapView addAnnotation:pointAnnotation];
    }
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    NSDictionary* dic=self.array[0];
    double latitude=[[dic objectForKey:@"latitude"] doubleValue];
    double longitude=[[dic objectForKey:@"longitude"]doubleValue];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(longitude, latitude);
   
    CLLocationCoordinate2D center = pointAnnotation.coordinate;
    [_mapView setCenterCoordinate:pointAnnotation.coordinate animated:YES];
    
    // 设置地图的显示范围
    MACoordinateSpan span = MACoordinateSpanMake(10, 10);
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
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    // 取出用户当前的经纬度
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    //CLLocationDegrees latitude= userLocation.coordinate.latitude  ;
   // CLLocationDegrees longitude=userLocation.coordinate.longitude;
    //NSLog(@"%f,%f",latitude,longitude);
    // 设置地图的中心点（以用户所在的位置为中心点）
    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
    // 设置地图的显示范围
    MACoordinateSpan span = MACoordinateSpanMake(0.5, 0.5);
    MACoordinateRegion region = MACoordinateRegionMake(center, span);
    [mapView setRegion:region animated:YES];
}
-(void)buttonCLick
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
