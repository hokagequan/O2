//
//  activityModel.h
//  O2Trip
//
//  Created by tao on 15/5/22.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface activityModel : NSObject
@property(nonatomic,strong)NSString* countryId;
@property(nonatomic,strong)NSString* countryImg;
@property(nonatomic,strong)NSString* countryName ;
-(id)initWithDictonary:(NSDictionary*)dic;
@end
