//
//  acModel.h
//  O2Trip
//
//  Created by tao on 15/8/21.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface acModel : NSObject
@property(nonatomic,strong)NSString* actiId;
@property(nonatomic,strong)NSMutableArray* actiImage;
@property(nonatomic,strong)NSString* actiTitle;
@property(nonatomic,strong)NSString* actiType;
@property(nonatomic,strong)NSString* days;
@property(nonatomic,strong)NSString* descName;
@property(nonatomic,strong)NSString* discussNum;
@property(nonatomic,strong)NSString* distance;
@property(nonatomic,strong)NSString* hasPraise;
@property(nonatomic,strong)NSString* origPrice;
@property(nonatomic,strong)NSString* physicalStrength;
@property(nonatomic,strong)NSString* praiseNum;
@property(nonatomic,strong)NSString* specialPrice;
@property(nonatomic,strong)NSString* tripDistance;
-(id)initWithDictionanry:(NSDictionary*)dic;



@end
