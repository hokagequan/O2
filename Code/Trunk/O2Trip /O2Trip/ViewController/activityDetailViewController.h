//
//  activityDetailViewController.h
//  O2Trip
//
//  Created by tao on 15/5/13.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "detailCell.h"
@interface activityDetailViewController : UIViewController<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    detailCell* _cell;
    CLLocationDegrees _latitude;
    CLLocationDegrees _longitude;
    
        BOOL isclip;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *dressLabel;
@property(nonatomic,strong)CLGeocoder* geoCoder;
@property(nonatomic,strong)CLLocationManager* locationManager;
@property(nonatomic,strong)NSMutableArray* array;
- (IBAction)buttonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *myView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property(nonatomic,strong)NSString* text;
@property(nonatomic,assign)NSInteger b;
@property(nonatomic,strong)NSString* countryId;
@end
