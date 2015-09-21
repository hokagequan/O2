//
//  searchresultViewController.h
//  O2Trip
//
//  Created by tao on 15/8/21.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface searchresultViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
{
    BOOL flag[10000];
}
- (IBAction)backButtonClick:(id)sender;
@property(nonatomic,strong)CLGeocoder* geoCoder;
@property(nonatomic,strong)CLLocationManager* locationManager;
@property(nonatomic,strong)NSString* textFieldText;
@property(nonatomic,strong)NSMutableArray* acArray;
@property(nonatomic,strong)NSMutableArray* deArray;
@property(nonatomic,strong)NSMutableArray *bigarray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
