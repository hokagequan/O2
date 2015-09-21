//
//  allModel.h
//  O2Trip
//
//  Created by tao on 15/7/7.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface allModel : NSObject
@property(nonatomic,strong)NSString* actiId;
@property(nonatomic,strong)NSString* actiName;
@property(nonatomic,strong)NSString* destiName;
@property(nonatomic,strong)NSString* fsLatitude;
@property(nonatomic,strong)NSString* fsLongtitude;
-(id)initWithDictionary:(NSDictionary*)dic;
@end
