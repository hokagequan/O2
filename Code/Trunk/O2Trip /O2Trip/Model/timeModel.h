//
//  timeModel.h
//  O2Trip
//
//  Created by tao on 15/7/6.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface timeModel : NSObject
@property(nonatomic,strong)NSString* dayNoArray;
@property(nonatomic)int dayWeekArray;
@property(nonatomic)int priceArray;
-(id)initWithDictionary:(NSDictionary*)dic;
@end
