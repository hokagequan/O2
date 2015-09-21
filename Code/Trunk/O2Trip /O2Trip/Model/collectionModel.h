//
//  collectionModel.h
//  O2Trip
//
//  Created by tao on 15/5/22.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface collectionModel : NSObject
@property(nonatomic,strong)NSString* actiId;
@property(nonatomic,strong)NSString* actiTitle;
@property(nonatomic,strong)NSString* country;
@property(nonatomic,strong)NSString* price;
@property(nonatomic,strong)NSString* type;
@property(nonatomic,strong)NSMutableArray* url;
@property(nonatomic,strong)NSString* tripDistance;
@property(nonatomic,strong)NSString* days;
@property(nonatomic,strong)NSString* praiseNum;
@property(nonatomic,strong)NSString* hasPraise;
-(id)initWithDictionary:(NSDictionary*)dic;
@end
