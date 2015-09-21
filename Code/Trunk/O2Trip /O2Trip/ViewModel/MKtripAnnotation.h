//
//  MKtripAnnotation.h
//  O2Trip
//
//  Created by tao on 15/5/6.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MKtripAnnotation : NSObject<MKAnnotation>
@property (nonatomic, unsafe_unretained) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *icon;

@end
