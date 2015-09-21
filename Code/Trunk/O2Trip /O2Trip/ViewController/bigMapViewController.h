//
//  bigMapViewController.h
//  O2Trip
//
//  Created by tao on 15/5/25.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
@interface bigMapViewController : UIViewController<MAMapViewDelegate,CLLocationManagerDelegate>
{
    //MAMapView* _mapView;

}
@property(nonatomic,strong)CLLocationManager* locationManager;
@property(nonatomic,strong)MAMapView* mapView;
@property(nonatomic,strong)NSMutableArray* array;
@end
