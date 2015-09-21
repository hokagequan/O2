//
//  detailactivityViewController.h
//  O2Trip
//
//  Created by tao on 15/5/15.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MKtripAnnotation.h"
#import <MapKit/MapKit.h>
#import "actiDetailModel.h"
@interface detailactivityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,UITextFieldDelegate>
{
    BOOL iscall;
    BOOL isbigCell;
    BOOL isShow;
    BOOL isStrech;
    BOOL isScroll;
    int  _a;
    CGRect _lastOffset;
   int  _keyHeight;
    BOOL isediting;
    BOOL isOneRow;
    BOOL isHidden;
    BOOL isOneDiss;
    BOOL istow;
    BOOL isthree;
    BOOL isfour;
    BOOL isfive;
    BOOL isCollect;
   
   
}
@property (weak, nonatomic) IBOutlet UILabel *bgLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)buttonClick:(id)sender;
@property(nonatomic,strong)MKMapView* mapView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *collectionButton;

@property (weak, nonatomic) IBOutlet UIButton *callbutton;

@property(nonatomic,strong)NSString* actiId;
@property(nonatomic,strong)actiDetailModel* activityModel;
@property(nonatomic,strong)NSMutableArray* array;
- (IBAction)collectionButtonClick:(id)sender;
@property(nonatomic,strong)NSMutableArray* dayArray;
@property(nonatomic,strong)NSMutableArray* bigArray;
@property(nonatomic,strong)NSMutableArray* smallArray;
@property(nonatomic,strong)NSMutableArray* timeArray;
- (IBAction)callButton:(id)sender;
@end
