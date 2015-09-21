//
//  changeViewController.h
//  O2Trip
//
//  Created by tao on 15/5/14.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface changeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    BOOL isclip;
   BOOL flag[10000];
    CGSize _size;
    int a;
}


@property(nonatomic,assign)CGRect lastOffset;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)CLGeocoder* geoCoder;
@property(nonatomic,strong)CLLocationManager* locationManager;
@property(nonatomic,strong)NSString* name;

@end
