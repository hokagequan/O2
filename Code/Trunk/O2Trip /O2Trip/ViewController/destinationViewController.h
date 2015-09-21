//
//  destinationViewController.h
//  O2Trip
//
//  Created by tao on 15/5/12.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface destinationViewController : UIViewController<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    CLLocationDegrees _Latitude;
    CLLocationDegrees _Longitude;
    UIView* _bgView;
    UITextField* _textField1;
    BOOL isclip;
    BOOL ischange;
    UITextField* _textField;
    UIImageView* _imageView;
}
@property(nonatomic,strong)CLGeocoder* geoCoder;
@property(nonatomic,strong)CLLocationManager* locationManager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray* array;
@property(nonatomic,strong)NSMutableArray* acArray;
@property(nonatomic,strong)NSMutableArray* deArray;
@property(nonatomic,strong)NSMutableArray *bigarray;
@property (weak, nonatomic) IBOutlet UILabel *headLabel;


@end
