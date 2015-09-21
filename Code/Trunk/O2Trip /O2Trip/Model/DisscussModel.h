//
//  DisscussModel.h
//  O2Trip
//
//  Created by tao on 15/5/26.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DisscussModel : NSObject
@property(nonatomic,strong)NSString* dissContent;
@property(nonatomic,strong)NSString* dissDate;
@property(nonatomic,strong)NSString* level;
@property(nonatomic,strong)NSString* userId;
@property(nonatomic,strong)NSString* userName;
@property(nonatomic,strong)NSString* actiPrice;
@property(nonatomic,strong)NSString* actiTitle;
-(id)initWithDictionary:(NSDictionary*)dic;
@end
