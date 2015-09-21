//
//  activityViewController.h
//  O2Trip
//
//  Created by tao on 15/5/12.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface activityViewController : UIViewController<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate>
{
    MKMapView* _mapView;
    BOOL isClip;
    CLLocationDegrees _Latitude;
    CLLocationDegrees _Longitude;
}
@property(nonatomic,strong)CLGeocoder* geoCoder;
@property(nonatomic,strong)CLLocationManager* locationManager;
@property (weak, nonatomic) IBOutlet UILabel *dressLabel;
@property (weak, nonatomic) IBOutlet UILabel *bigLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray* array;
- (IBAction)MapButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *myview;

@end
