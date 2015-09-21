//
//  maxModel.h
//  O2Trip
//
//  Created by tao on 15/9/10.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface maxModel : NSObject
@property(nonatomic,strong)NSString* max;
@property(nonatomic,strong)NSString* min;
-(id)initWithDictionary:(NSDictionary*)dic;
@end
