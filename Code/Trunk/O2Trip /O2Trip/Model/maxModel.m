//
//  maxModel.m
//  O2Trip
//
//  Created by tao on 15/9/10.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "maxModel.h"

@implementation maxModel
-(id)initWithDictionary:(NSDictionary*)dic
{
    self=[super init];
    if (self) {
        self.max=[dic objectForKey:@"max"];
        self.min=[dic objectForKey:@"min"];
    }
    return self;
}
@end
