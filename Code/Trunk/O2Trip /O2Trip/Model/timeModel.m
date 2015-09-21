//
//  timeModel.m
//  O2Trip
//
//  Created by tao on 15/7/6.
//  Copyright (c) 2015年 lst. All rights reserved.
//

#import "timeModel.h"

@implementation timeModel
-(id)initWithDictionary:(NSDictionary*)dic
{
    self=[super init];
    if (self) {
        self.dayNoArray=[dic objectForKey:@"dayNo"];
        self.dayWeekArray=[dic objectForKey:@"dayWeek"];
        self.priceArray=[dic objectForKey:@"priceArray"];
    }
    return self;
}
@end
